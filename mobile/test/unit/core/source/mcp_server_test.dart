import 'dart:async';
import 'dart:convert';

import 'package:flutter_template/core/common/config.dart';
import 'package:flutter_template/core/model/health_data_request.dart';
import 'package:flutter_template/core/model/mcp_exceptions.dart';
import 'package:flutter_template/core/service/health_data_manager.dart';
import 'package:flutter_template/core/service/server/mcp_server.dart';
import 'package:flutter_template/core/service/server/mcp_transport.dart';
import 'package:flutter_template/model/vytal_health_data_category.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mock_websocket.dart';
import '../../../helpers/test_data_factory.dart';

class MockHealthDataManager extends Mock implements HealthDataManager {}

class FakeMcpTransport implements McpTransport {
  FakeMcpTransport();

  final StreamController<McpTransportEvent> _statusController =
      StreamController<McpTransportEvent>.broadcast();
  final StreamController<String> _messageController =
      StreamController<String>.broadcast();

  Future<void> Function()? onStartCallback;
  Future<void> Function()? onStopCallback;
  Future<void> Function(String message)? onSendCallback;

  final List<String> sentMessages = <String>[];

  bool _isConnected = false;

  @override
  Stream<McpTransportEvent> get events => _statusController.stream;

  @override
  Stream<String> get messages => _messageController.stream;

  @override
  bool get isConnected => _isConnected;

  @override
  Future<void> start() async {
    if (onStartCallback != null) {
      await onStartCallback!();
    }
  }

  @override
  Future<void> stop() async {
    _isConnected = false;
    if (onStopCallback != null) {
      await onStopCallback!();
    }
  }

  @override
  Future<void> send(String message) async {
    sentMessages.add(message);
    if (onSendCallback != null) {
      await onSendCallback!(message);
    }
  }

  @override
  Future<void> dispose() async {
    await stop();
    await _statusController.close();
    await _messageController.close();
  }

  void emitStatus(McpTransportEvent event) {
    event.when(
      connecting: () {
        _isConnected = false;
      },
      connected: () {
        _isConnected = true;
      },
      disconnected: (_, __) {
        _isConnected = false;
      },
    );
    _statusController.add(event);
  }

  void emitMessage(String message) {
    _messageController.add(message);
  }
}

void main() {
  setUpAll(() {
    Config.wsUrl = 'ws://localhost:8080/ws';
    Config.gptIntegrationUrl = 'http://localhost:3000';
    Config.appDirectoryPath = '/tmp/test';
    Config.landingUrl = 'http://localhost:3000';
    Config.testingMode = true;

    registerFallbackValue(TestDataFactory.createHealthDataRequest());
  });

  group('HealthMcpServerService', () {
    late HealthMcpServerService mcpServer;
    late MockHealthDataManager mockHealthDataManager;
    late FakeMcpTransport fakeTransport;

    setUp(() {
      mockHealthDataManager = MockHealthDataManager();
      fakeTransport = FakeMcpTransport();
      mcpServer = HealthMcpServerService(
        healthDataManager: mockHealthDataManager,
        transport: fakeTransport,
      );
    });

    tearDown(() async {
      await mcpServer.dispose();
      await fakeTransport.dispose();
    });

    group('connection management', () {
      test('starts disconnected', () {
        expect(mcpServer.isConnected, isFalse);
      });

      test('connectToBackend establishes connection after handshake', () async {
        expect(mcpServer.isConnected, isFalse);

        fakeTransport.onStartCallback = () async {
          fakeTransport
            ..emitStatus(const McpTransportEvent.connecting())
            ..emitStatus(const McpTransportEvent.connected());
          final handshake =
              WebSocketTestMessageFactory.createConnectionCodeMessage(
            code: '1234',
            word: 'lion',
            message: 'Connected',
          );
          fakeTransport.emitMessage(jsonEncode(handshake));
        };

        final state = await mcpServer.connectToBackend();

        expect(state, isA<McpConnectionStateConnected>());
        expect(mcpServer.isConnected, isTrue);
      });

      test('stop closes connection when connected', () async {
        fakeTransport.emitStatus(const McpTransportEvent.connected());
        expect(mcpServer.isConnected, isFalse);

        await mcpServer.stop();

        expect(mcpServer.isConnected, isFalse);
      });
    });

    group('connection state stream', () {
      test('starts with disconnected state', () {
        expect(mcpServer.currentStatus, isA<McpConnectionStateDisconnected>());
        expect(mcpServer.isDisconnected, isTrue);
        expect(mcpServer.isConnected, isFalse);
        expect(mcpServer.isConnecting, isFalse);
      });

      test('emits connecting state when transport connects', () async {
        final states = <McpConnectionState>[];
        final sub = mcpServer.status.listen(states.add);

        fakeTransport.emitStatus(const McpTransportEvent.connecting());

        await Future<void>.delayed(const Duration(milliseconds: 10));
        await sub.cancel();

        expect(
          states.any((state) => state is McpConnectionStateConnecting),
          isTrue,
        );
      });

      test('emits disconnected state when transport disconnects', () async {
        final states = <McpConnectionState>[];
        final sub = mcpServer.status.listen(states.add);

        fakeTransport.emitStatus(
          const McpTransportEvent.disconnected(
            errorMessage: 'Network error',
            lostConnection: true,
          ),
        );

        await Future<void>.delayed(const Duration(milliseconds: 10));
        await sub.cancel();

        expect(states.last, isA<McpConnectionStateDisconnected>());
        final last = states.last as McpConnectionStateDisconnected;
        expect(last.errorMessage, contains('Network error'));
        expect(last.lostConnection, isTrue);
      });
    });

    group('message handling', () {
      test('handles health data request message correctly', () async {
        final requestMessage =
            WebSocketTestMessageFactory.createHealthDataRequestMessage(
          id: 'test-123',
          valueType: 'STEPS',
          startTime: '2024-01-01T00:00:00Z',
          endTime: '2024-01-02T00:00:00Z',
        );

        final expectedResponse = TestDataFactory.createHealthDataResponse(
          valueType: 'STEPS',
          count: 10,
        );

        when(() => mockHealthDataManager.processHealthDataRequest(any()))
            .thenAnswer((_) async => expectedResponse);

        await mcpServer.handleBackendMessage(jsonEncode(requestMessage));

        verify(() => mockHealthDataManager.processHealthDataRequest(any()))
            .called(1);
      });

      test('handles connection code message correctly', () async {
        final stateChanges = <McpConnectionState>[];
        final subscription = mcpServer.status.listen(stateChanges.add);

        final codeMessage =
            WebSocketTestMessageFactory.createConnectionCodeMessage(
          code: 'ABC123',
          word: 'elephant',
          message: 'Connection established',
        );

        await mcpServer.handleBackendMessage(jsonEncode(codeMessage));

        await subscription.cancel();

        expect(
          stateChanges.any((state) => state is McpConnectionStateConnected),
          isTrue,
        );
      });

      test('handles unknown message type gracefully', () async {
        final unknownMessage =
            WebSocketTestMessageFactory.createUnknownMessage();

        await mcpServer.handleBackendMessage(jsonEncode(unknownMessage));
      });

      test('handles malformed JSON gracefully', () async {
        const malformedJson = '{"invalid": json}';

        await mcpServer.handleBackendMessage(malformedJson);
      });

      test('handles health data request processing errors', () async {
        final requestMessage =
            WebSocketTestMessageFactory.createHealthDataRequestMessage();

        when(() => mockHealthDataManager.processHealthDataRequest(any()))
            .thenThrow(Exception('Processing failed'));

        await mcpServer.handleBackendMessage(jsonEncode(requestMessage));

        verify(() => mockHealthDataManager.processHealthDataRequest(any()))
            .called(1);
      });
    });

    group('health data request processing', () {
      test('processes valid health data request', () async {
        final request = TestDataFactory.createHealthDataRequest(
          valueType: VytalHealthDataCategory.STEPS,
          startTime: DateTime(2024, 1, 1),
          endTime: DateTime(2024, 1, 2),
        );

        final expectedResponse = TestDataFactory.createHealthDataResponse(
          success: true,
          count: 5,
          valueType: 'STEPS',
        );

        when(() => mockHealthDataManager.processHealthDataRequest(request))
            .thenAnswer((_) async => expectedResponse);

        final result = await mcpServer.handleHealthDataRequest(request);

        expect(result['success'], isTrue);
        expect(result['count'], equals(5));
        expect(result['value_type'], equals('STEPS'));
        verify(() => mockHealthDataManager.processHealthDataRequest(request))
            .called(1);
      });

      test('handles health data manager exceptions', () async {
        final request = TestDataFactory.createHealthDataRequest();

        when(() => mockHealthDataManager.processHealthDataRequest(request))
            .thenThrow(
          const HealthMcpServerException('Data processing failed'),
        );

        final result = await mcpServer.handleHealthDataRequest(request);

        expect(result['success'], isFalse);
        expect(result['error_message'], contains('Data processing failed'));
      });

      test('handles permission exceptions', () async {
        final request = TestDataFactory.createHealthDataRequest();

        when(() => mockHealthDataManager.processHealthDataRequest(request))
            .thenThrow(const HealthPermissionException('Permission denied'));

        final result = await mcpServer.handleHealthDataRequest(request);

        expect(result['success'], isFalse);
        expect(result['error_message'], contains('Permission denied'));
      });

      test('handles health data unavailable exceptions', () async {
        final request = TestDataFactory.createHealthDataRequest();

        when(() => mockHealthDataManager.processHealthDataRequest(request))
            .thenThrow(
          const HealthDataUnavailableException(
            'Health Connect not available',
          ),
        );

        final result = await mcpServer.handleHealthDataRequest(request);

        expect(result['success'], isFalse);
        expect(
          result['error_message'],
          contains('Health Connect not available'),
        );
      });

      test('handles general exceptions', () async {
        final request = TestDataFactory.createHealthDataRequest();

        when(() => mockHealthDataManager.processHealthDataRequest(request))
            .thenThrow(Exception('Unexpected error'));

        final result = await mcpServer.handleHealthDataRequest(request);

        expect(result['success'], isFalse);
        expect(result['error_message'], contains('Unexpected error'));
      });
    });

    group('message sending', () {
      test('sendToBackend throws when not connected', () async {
        final message = {'type': 'test', 'data': 'test data'};

        expect(
          () => mcpServer.sendToBackend(message),
          throwsA(isA<Exception>()),
        );
      });

      test('sendToBackend delegates to transport when connected', () async {
        fakeTransport.emitStatus(const McpTransportEvent.connected());
        final payload = {'type': 'test', 'data': 'sample'};

        await mcpServer.handleBackendMessage(
          jsonEncode(
            WebSocketTestMessageFactory.createConnectionCodeMessage(
              code: 'ABC123',
              word: 'falcon',
              message: 'Ready',
            ),
          ),
        );

        await mcpServer.sendToBackend(payload);

        expect(fakeTransport.sentMessages, isNotEmpty);
      });
    });

    group('backend message parsing', () {
      test('parses health data request message correctly', () async {
        final messageJson =
            WebSocketTestMessageFactory.createHealthDataRequestMessage(
          id: 'request-123',
          valueType: 'STEPS',
          startTime: '2024-01-01T00:00:00Z',
          endTime: '2024-01-02T00:00:00Z',
          groupBy: 'DAY',
          statistic: 'SUM',
        );

        when(() => mockHealthDataManager.processHealthDataRequest(any()))
            .thenAnswer(
          (_) async => TestDataFactory.createHealthDataResponse(),
        );

        await mcpServer.handleBackendMessage(jsonEncode(messageJson));

        final captured = verify(
          () => mockHealthDataManager.processHealthDataRequest(captureAny()),
        ).captured;
        final request = captured.first as HealthDataRequest;
        expect(request.valueType, equals(VytalHealthDataCategory.STEPS));
        expect(
          request.startTime.toIso8601String(),
          equals('2024-01-01T00:00:00.000Z'),
        );
        expect(
          request.endTime.toIso8601String(),
          equals('2024-01-02T00:00:00.000Z'),
        );
      });

      test('handles missing payload fields gracefully', () async {
        final messageJson =
            WebSocketTestMessageFactory.createHealthDataRequestMessage(
          id: 'request-123',
          valueType: 'STEPS',
          startTime: '2024-01-01T00:00:00Z',
          endTime: '2024-01-02T00:00:00Z',
        );

        when(() => mockHealthDataManager.processHealthDataRequest(any()))
            .thenAnswer(
          (_) async => TestDataFactory.createHealthDataResponse(),
        );

        await mcpServer.handleBackendMessage(jsonEncode(messageJson));

        verify(() => mockHealthDataManager.processHealthDataRequest(any()))
            .called(1);
      });

      test('handles invalid value type gracefully', () async {
        final messageJson = {
          'type': 'health_data_request',
          'request_id': 'request-123',
          'payload': {
            'value_type': 'INVALID_TYPE',
            'start_time': '2024-01-01T00:00:00Z',
            'end_time': '2024-01-02T00:00:00Z',
          },
        };

        await mcpServer.handleBackendMessage(jsonEncode(messageJson));
      });

      test('handles invalid date format gracefully', () async {
        final messageJson = {
          'type': 'health_data_request',
          'request_id': 'request-123',
          'payload': {
            'value_type': 'STEPS',
            'start_time': 'invalid-date',
            'end_time': '2024-01-02T00:00:00Z',
          },
        };

        await mcpServer.handleBackendMessage(jsonEncode(messageJson));
      });
    });
  });
}
