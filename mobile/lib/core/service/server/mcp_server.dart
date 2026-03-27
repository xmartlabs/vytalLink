import 'dart:async';
import 'dart:convert';

import 'package:flutter_template/core/common/analytics_manager.dart';
import 'package:flutter_template/core/common/config.dart';
import 'package:flutter_template/core/common/logger.dart';
import 'package:flutter_template/core/model/backend_message.dart';
import 'package:flutter_template/core/model/backend_response.dart';
import 'package:flutter_template/core/model/health_data_request.dart';
import 'package:flutter_template/core/model/health_data_response.dart';
import 'package:flutter_template/core/model/mcp_connection_state.dart';
import 'package:flutter_template/core/model/mcp_exceptions.dart';
import 'package:flutter_template/core/model/summary_request.dart';
import 'package:flutter_template/core/service/health_data_manager.dart';
import 'package:flutter_template/core/service/server/foreground_mcp_transport.dart';
import 'package:flutter_template/core/service/server/mcp_background_service.dart';
import 'package:flutter_template/core/service/server/mcp_transport.dart';
import 'package:flutter_template/core/service/summary_data_manager.dart';
import 'package:flutter_template/core/service/server/websocket_mcp_transport.dart';
import 'package:rxdart/rxdart.dart';

export 'package:flutter_template/core/model/mcp_connection_state.dart';

class HealthMcpServerService {
  HealthMcpServerService({
    HealthDataManager? healthDataManager,
    SummaryDataManager? summaryDataManager,
    McpTransport? transport,
    Uri? backendUri,
    bool? useForegroundTransport,
  })  : _healthDataManager = healthDataManager ?? HealthDataManager(),
        _summaryDataManager = summaryDataManager ??
            SummaryDataManager(
              healthDataManager: healthDataManager,
            ),
        _connectionState = BehaviorSubject<McpConnectionState>.seeded(
          const McpConnectionState.disconnected(),
        ),
        _backendUri = backendUri ?? Uri.parse(Config.wsUrl),
        _foregroundPreferred = useForegroundTransport ??
            (transport == null
                ? Config.useForegroundService
                : transport is ForegroundMcpTransport) {
    _attachTransport(
      transport ??
          _createDefaultTransport(
            backendUri ?? Uri.parse(Config.wsUrl),
            _foregroundPreferred,
          ),
    );
  }

  final BehaviorSubject<McpConnectionState> _connectionState;
  final HealthDataManager _healthDataManager;
  final SummaryDataManager _summaryDataManager;
  final Uri _backendUri;
  final bool _foregroundPreferred;
  bool _foregroundFallbackAttempted = false;
  late McpTransport _transport;

  StreamSubscription<McpTransportEvent>? _transportStatusSubscription;
  StreamSubscription<String>? _transportMessageSubscription;

  void _attachTransport(McpTransport transport) {
    _transport = transport;
    _transportStatusSubscription =
        _transport.events.listen(_handleTransportEvent);
    _transportMessageSubscription =
        _transport.messages.listen(_handleTransportMessage);
  }

  Future<void> _replaceTransport(McpTransport transport) async {
    await _transportStatusSubscription?.cancel();
    await _transportMessageSubscription?.cancel();
    _transportStatusSubscription = null;
    _transportMessageSubscription = null;
    await _transport.dispose();
    _attachTransport(transport);
  }

  Stream<McpConnectionState> get status => _connectionState.stream;

  McpConnectionState get currentStatus =>
      _connectionState.valueOrNull ??
      const McpConnectionState.disconnected(lostConnection: false);

  bool get isConnected => currentStatus is McpConnectionStateConnected;

  bool get isConnecting => currentStatus is McpConnectionStateConnecting;

  bool get isDisconnected => currentStatus is McpConnectionStateDisconnected;

  String _messageRequestId(Map<String, dynamic> rawMessage) =>
      rawMessage['request_id']?.toString() ??
      rawMessage['requestId']?.toString() ??
      'n/a';

  String _messageResponseId(Map<String, dynamic> rawMessage) =>
      rawMessage['request_id']?.toString() ??
      rawMessage['requestId']?.toString() ??
      rawMessage['id']?.toString() ??
      '';

  Future<void> stop() async {
    await _transport.stop();
    _connectionState.add(const McpConnectionState.disconnected());
  }

  Future<McpConnectionState> connectToBackend() async {
    _connectionState.add(const McpConnectionState.connecting());

    try {
      await _transport.start();
    } catch (error, stackTrace) {
      final fallbackAttempted = await _tryFallbackTransport(error, stackTrace);
      if (fallbackAttempted) {
        return connectToBackend();
      }

      Logger.e(
        'Failed to connect to backend',
        error,
        stackTrace,
      );
      AnalyticsManager.logMcpConnectionError(
        errorMessage: error.toString(),
      );
      _connectionState.add(
        McpConnectionState.disconnected(
          errorMessage: error.toString(),
          lostConnection: true,
        ),
      );
      throw HealthMcpServerException('Failed to connect to backend', error);
    }

    return _connectionState.stream
        .where(
          (state) =>
              state is McpConnectionStateConnected ||
              state is McpConnectionStateDisconnected,
        )
        .first;
  }

  Future<void> sendToBackend(Map<String, dynamic> message) async {
    if (!isConnected) {
      throw Exception('Not connected to backend');
    }

    final jsonMessage = jsonEncode(message);
    await _transport.send(jsonMessage);
    Logger.d('[MCP] Sent response to backend: $jsonMessage');
  }

  Future<void> handleBackendMessage(String data) async {
    Map<String, dynamic>? rawMessage;
    try {
      rawMessage = jsonDecode(data) as Map<String, dynamic>;
      Logger.d('[MCP] Received raw message: $rawMessage');
      final BackendMessage message = BackendMessage.fromJson(rawMessage);

      Logger.d(
        '[MCP] Parsed backend message: '
        'type=${message.runtimeType} '
        'requestId=${_messageRequestId(rawMessage)}',
      );

      switch (message) {
        case final HealthDataRequestMessage dataRequestMessage:
          await _handleDataRequestMessage(dataRequestMessage);
          break;

        case final SummaryRequestMessage summaryRequestMessage:
          await _handleSummaryRequestMessage(summaryRequestMessage);
          break;

        case final ConnectionCodeMessage codeMessage:
          _handleConnectionCredentialsMessage(codeMessage);
          break;

        case UnknownMessage():
          Logger.w('[MCP] Unknown message type received');
          break;
      }
    } catch (e) {
      Logger.e('[MCP] Error processing backend message: $e', e);
      try {
        final String? msgType = rawMessage != null
            ? (rawMessage['type'] as String? ?? '').toLowerCase()
            : null;
        if (msgType == 'summary_request') {
          final dynamic payload = rawMessage?['payload'];
          final payloadMap = payload is Map<String, dynamic> ? payload : null;
          final errorResponse = BackendResponse.summaryResponse(
            id: rawMessage != null ? _messageResponseId(rawMessage) : '',
            data: {
              'success': false,
              'start_time': payloadMap?['start_time'] as String? ?? '',
              'end_time': payloadMap?['end_time'] as String? ?? '',
              'results': <Map<String, dynamic>>[],
              'error_message':
                  'Error processing summary request: ${e.toString()}',
            },
          );
          await sendToBackend(errorResponse.toJson());
        } else {
          final errorResponse = HealthDataErrorResponse(
            success: false,
            errorMessage: 'Error retrieving health data: ${e.toString()}',
          );
          await sendToBackend(errorResponse.toJson());
        }
      } catch (innerError) {
        Logger.e(
          '[MCP] Error sending error message to backend: $innerError',
          innerError,
        );
      }
    }
  }

  void _handleConnectionCredentialsMessage(
    ConnectionCodeMessage message,
  ) {
    Logger.d('[MCP] Received connection code: ${message.code}');
    AnalyticsManager.logMcpConnectionStarted();

    McpBackgroundService.startOrUpdate(
      connectionCode: message.code,
      connectionWord: message.word,
    ).ignore();
    _connectionState.add(
      McpConnectionState.connected(
        credentials: (
          connectionWord: message.word,
          connectionPin: message.code,
        ),
        message: message.message,
      ),
    );
  }

  Future<void> _handleDataRequestMessage(
    HealthDataRequestMessage message,
  ) async {
    final request = HealthDataRequest.fromJson(message.payload);
    Logger.d('[MCP] Handling health data request: ${message.id}');
    AnalyticsManager.logHealthDataRequest(request);
    final responseData = await handleHealthDataRequest(request);
    final backendResponse = BackendResponse.healthDataResponse(
      id: message.id,
      data: responseData,
    );
    await sendToBackend(backendResponse.toJson());
  }

  Future<void> _handleSummaryRequestMessage(
    SummaryRequestMessage message,
  ) async {
    final request = SummaryRequest.fromJson(message.payload);
    Logger.d('[MCP] Handling summary request: ${message.id}');
    AnalyticsManager.logSummaryRequest(request);
    try {
      final responseData =
          await _summaryDataManager.processSummaryRequest(request);
      AnalyticsManager.logSummaryResponse(
        metricCount: responseData.results.length,
      );
      final backendResponse = BackendResponse.summaryResponse(
        id: message.id,
        data: responseData.toJson(),
      );
      await sendToBackend(backendResponse.toJson());
    } catch (e) {
      Logger.e('[MCP] Error handling summary request: $e', e);
      AnalyticsManager.logSummaryError(
        errorType: e.runtimeType.toString(),
        errorMessage: e.toString(),
      );
      final errorResponse = BackendResponse.summaryResponse(
        id: message.id,
        data: {
          'success': false,
          'start_time': request.startTime.toIso8601String(),
          'end_time': request.endTime.toIso8601String(),
          'results': <Map<String, dynamic>>[],
          'error_message': 'Error retrieving summary data: ${e.toString()}',
        },
      );
      try {
        await sendToBackend(errorResponse.toJson());
      } catch (innerError) {
        Logger.e(
          '[MCP] Error sending summary error response: $innerError',
          innerError,
        );
      }
    }
  }

  Future<Map<String, dynamic>> handleHealthDataRequest(
    HealthDataRequest request,
  ) async {
    try {
      final response =
          await _healthDataManager.processHealthDataRequest(request);
      AnalyticsManager.logHealthDataResponse(response);
      return response.toJson();
    } catch (e) {
      Logger.e('Error handling health data request: $e', e);
      final errorResponse = HealthDataErrorResponse(
        success: false,
        errorMessage: 'Error retrieving health data: ${e.toString()}',
      );
      AnalyticsManager.logHealthDataError(
        valueType: request.valueType.name,
        errorType: e.runtimeType.toString(),
        errorMessage: e.toString(),
      );
      return errorResponse.toJson();
    }
  }

  Future<void> dispose() async {
    await _transportStatusSubscription?.cancel();
    await _transportMessageSubscription?.cancel();
    await _transport.dispose();
    await _connectionState.close();
  }

  void _handleTransportEvent(McpTransportEvent event) {
    event.when(
      connecting: () {
        _connectionState.add(const McpConnectionState.connecting());
      },
      connected: () {
        Logger.d('Transport connected to $_backendUri');
      },
      disconnected: (errorMessage, lostConnection) {
        if (lostConnection) {
          AnalyticsManager.logMcpConnectionLost();
        }
        _connectionState.add(
          McpConnectionState.disconnected(
            errorMessage: errorMessage,
            lostConnection: lostConnection,
          ),
        );
      },
    );
  }

  void _handleTransportMessage(String data) {
    unawaited(handleBackendMessage(data));
  }

  Future<bool> _tryFallbackTransport(
    Object error,
    StackTrace stackTrace,
  ) async {
    if (_foregroundFallbackAttempted || !_foregroundPreferred) {
      return false;
    }

    if (_transport is! ForegroundMcpTransport) {
      return false;
    }

    final message = error.toString().toLowerCase();
    final bool looksLikeTimeout =
        error is TimeoutException || message.contains('timeout');

    if (!looksLikeTimeout) {
      return false;
    }

    _foregroundFallbackAttempted = true;

    Logger.w(
      'Foreground MCP transport did not respond; use WebSocket transport',
      error,
      stackTrace,
    );

    try {
      await _replaceTransport(
        WebSocketMcpTransport(backendUri: _backendUri),
      );
      return true;
    } catch (replacementError, replacementStackTrace) {
      Logger.w(
        'Failed to switch to WebSocket transport after foreground failure',
        replacementError,
        replacementStackTrace,
      );
      return false;
    }
  }

  static McpTransport _createDefaultTransport(
    Uri backendUri,
    bool useForegroundTransport,
  ) {
    if (useForegroundTransport) {
      return ForegroundMcpTransport(backendUri: backendUri);
    }

    return WebSocketMcpTransport(backendUri: backendUri);
  }
}
