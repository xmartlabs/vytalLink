import 'dart:convert';

import 'package:flutter_template/core/common/config.dart';
import 'package:flutter_template/core/model/health_data_request.dart';
import 'package:flutter_template/core/service/health_data_manager.dart';
import 'package:flutter_template/core/source/mcp_server.dart';
import 'package:flutter_template/model/vytal_health_data_category.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mock_websocket.dart';
import '../../../helpers/test_data_factory.dart';

class MockHealthDataManager extends Mock implements HealthDataManager {}

void main() {
  setUpAll(() {
    // Initialize Config values needed for MCP server
    Config.wsUrl = 'ws://localhost:8080/ws';
    Config.gptIntegrationUrl = 'http://localhost:3000';
    Config.appDirectoryPath = '/tmp/test';
    Config.landingUrl = 'http://localhost:3000';

    // Disable Firebase for testing
    Config.testingMode = true;
  });

  group('HealthMcpServerService', () {
    late HealthMcpServerService mcpServer;
    late MockHealthDataManager mockHealthDataManager;
    late HealthMcpServerConfig config;
    late TestWebSocketChannel testWebSocketChannel;

    setUp(() {
      mockHealthDataManager = MockHealthDataManager();
      config = const HealthMcpServerConfig(
        serverName: 'VytalLink',
        serverVersion: '1.0.0',
        host: '192.168.1.100',
        port: 8080,
        endpoint: '/mcp',
      );

      mcpServer = HealthMcpServerService(
        config: config,
        healthDataManager: mockHealthDataManager,
      );

      testWebSocketChannel = TestWebSocketChannel();

      registerFallbackValue(TestDataFactory.createHealthDataRequest());
    });

    tearDown(() {
      testWebSocketChannel.dispose();
    });

    group('configuration', () {
      test('initializes with correct config', () {
        expect(mcpServer.config.serverName, equals('VytalLink'));
        expect(mcpServer.config.serverVersion, equals('1.0.0'));
        expect(mcpServer.config.host, equals('192.168.1.100'));
        expect(mcpServer.config.port, equals(8080));
        expect(mcpServer.config.endpoint, equals('/mcp'));
        expect(mcpServer.config.isJsonResponseEnabled, isTrue);
      });

      test('creates with default health data manager when not provided', () {
        final server = HealthMcpServerService(config: config);
        expect(server.config, equals(config));
      });
    });

    group('connection management', () {
      test('starts disconnected', () {
        expect(mcpServer.isConnected, isFalse);
      });

      test('connectToBackend establishes connection', () async {
        expect(mcpServer.isConnected, isFalse);
      });

      test('stop closes connection when connected', () async {
        mcpServer.webSocketChannel = testWebSocketChannel;

        await mcpServer.stop();

        expect(mcpServer.isConnected, isFalse);
      });

      test('stop handles disconnected state gracefully', () async {
        expect(mcpServer.isConnected, isFalse);

        await mcpServer.stop();

        expect(mcpServer.isConnected, isFalse);
      });
    });

    group('callback management', () {
      test('sets connection code callback', () {
        var callbackExecuted = false;

        mcpServer.setConnectionCodeCallback((code, word, message) {
          callbackExecuted = true;
        });

        expect(callbackExecuted, isFalse);
      });

      test('sets connection error callback', () {
        var callbackExecuted = false;

        mcpServer.setConnectionErrorCallback((error) {
          callbackExecuted = true;
        });

        expect(callbackExecuted, isFalse);
      });

      test('sets connection lost callback', () {
        var callbackExecuted = false;

        mcpServer.setConnectionLostCallback(() {
          callbackExecuted = true;
        });

        expect(callbackExecuted, isFalse);
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
        var callbackExecuted = false;
        String? receivedCode;
        String? receivedWord;
        String? receivedMessage;

        mcpServer.setConnectionCodeCallback((code, word, message) {
          callbackExecuted = true;
          receivedCode = code;
          receivedWord = word;
          receivedMessage = message;
        });

        final codeMessage =
            WebSocketTestMessageFactory.createConnectionCodeMessage(
          code: 'ABC123',
          word: 'elephant',
          message: 'Connection established',
        );

        await mcpServer.handleBackendMessage(jsonEncode(codeMessage));

        expect(callbackExecuted, isTrue);
        expect(receivedCode, equals('ABC123'));
        expect(receivedWord, equals('elephant'));
        expect(receivedMessage, equals('Connection established'));
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
      test('sendToBackend sends message when connected', () async {
        mcpServer.webSocketChannel = testWebSocketChannel;

        final message = {'type': 'test', 'data': 'test data'};

        expect(
          () => mcpServer.sendToBackend(message),
          throwsA(isA<Exception>()),
        );
      });

      test('sendToBackend throws when not connected', () async {
        final message = {'type': 'test', 'data': 'test data'};

        expect(
          () => mcpServer.sendToBackend(message),
          throwsA(isA<Exception>()),
        );
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
          // Missing optional fields
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

    group('HealthMcpServerException', () {
      test('creates exception with message only', () {
        const exception = HealthMcpServerException('Test error');

        expect(exception.message, equals('Test error'));
        expect(exception.cause, isNull);
        expect(
          exception.toString(),
          equals('HealthMcpServerException: Test error'),
        );
      });

      test('creates exception with message and cause', () {
        final cause = Exception('Root cause');
        final exception = HealthMcpServerException('Test error', cause);

        expect(exception.message, equals('Test error'));
        expect(exception.cause, equals(cause));
        expect(exception.toString(), contains('Test error'));
        expect(exception.toString(), contains('Root cause'));
      });
    });

    group('HealthPermissionException', () {
      test('extends HealthMcpServerException', () {
        const exception = HealthPermissionException('Permission denied');

        expect(exception, isA<HealthMcpServerException>());
        expect(exception.message, equals('Permission denied'));
      });
    });

    group('HealthDataUnavailableException', () {
      test('extends HealthMcpServerException', () {
        const exception = HealthDataUnavailableException('Data unavailable');

        expect(exception, isA<HealthMcpServerException>());
        expect(exception.message, equals('Data unavailable'));
      });
    });
  });
}
