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
import 'package:flutter_template/core/service/health_data_manager.dart';
import 'package:flutter_template/core/service/server/foreground_mcp_transport.dart';
import 'package:flutter_template/core/service/server/mcp_background_service.dart';
import 'package:flutter_template/core/service/server/mcp_transport.dart';
import 'package:flutter_template/core/service/server/websocket_mcp_transport.dart';
import 'package:rxdart/rxdart.dart';

export 'package:flutter_template/core/model/mcp_connection_state.dart';

class HealthMcpServerService {
  HealthMcpServerService({
    HealthDataManager? healthDataManager,
    McpTransport? transport,
    Uri? backendUri,
    bool? useForegroundTransport,
  })  : _healthDataManager = healthDataManager ?? HealthDataManager(),
        _connectionState = BehaviorSubject<McpConnectionState>.seeded(
          const McpConnectionState.disconnected(),
        ),
        _backendUri = backendUri ?? Uri.parse(Config.wsUrl),
        _transport = transport ??
            _createDefaultTransport(
              backendUri ?? Uri.parse(Config.wsUrl),
              useForegroundTransport ?? Config.useForegroundService,
            ) {
    _transportStatusSubscription =
        _transport.events.listen(_handleTransportEvent);
    _transportMessageSubscription =
        _transport.messages.listen(_handleTransportMessage);
  }

  final BehaviorSubject<McpConnectionState> _connectionState;
  final HealthDataManager _healthDataManager;
  final Uri _backendUri;
  final McpTransport _transport;

  StreamSubscription<McpTransportEvent>? _transportStatusSubscription;
  StreamSubscription<String>? _transportMessageSubscription;

  Stream<McpConnectionState> get status => _connectionState.stream;

  McpConnectionState get currentStatus =>
      _connectionState.valueOrNull ??
      const McpConnectionState.disconnected(lostConnection: false);

  bool get isConnected => currentStatus is McpConnectionStateConnected;

  bool get isConnecting => currentStatus is McpConnectionStateConnecting;

  bool get isDisconnected => currentStatus is McpConnectionStateDisconnected;

  Future<void> stop() async {
    await _transport.stop();
    _connectionState.add(const McpConnectionState.disconnected());
  }

  Future<McpConnectionState> connectToBackend() async {
    _connectionState.add(const McpConnectionState.connecting());

    try {
      await _transport.start();
    } catch (error, stackTrace) {
      Logger.e('Failed to connect to backend: $error', stackTrace);
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
    Logger.d('Sent message to backend: $jsonMessage');
  }

  Future<void> handleBackendMessage(String data) async {
    try {
      final Map<String, dynamic> rawMessage = jsonDecode(data);
      Logger.d('Received raw message: $rawMessage');
      final BackendMessage message = BackendMessage.fromJson(rawMessage);

      Logger.d('Processing backend message: ${message.runtimeType}');

      switch (message) {
        case final HealthDataRequestMessage dataRequestMessage:
          await _handleDataRequestMessage(dataRequestMessage);
          break;

        case final ConnectionCodeMessage codeMessage:
          _handleConnectionCredentialsMessage(codeMessage);
          break;

        case UnknownMessage():
          Logger.w('Unknown message type received');
          break;
      }
    } catch (e) {
      Logger.e('Error processing backend message: $e', e);
      try {
        final errorResponse = HealthDataErrorResponse(
          success: false,
          errorMessage: 'Error retrieving health data: ${e.toString()}',
        );
        await sendToBackend(errorResponse.toJson());
      } catch (innerError) {
        Logger.e(
          'Error sending error message to backend: $innerError',
          innerError,
        );
      }
    }
  }

  void _handleConnectionCredentialsMessage(
    ConnectionCodeMessage message,
  ) {
    Logger.d('Received connection code: ${message.code}');
    AnalyticsManager.logMcpConnectionStarted();
    unawaited(
      McpBackgroundService.startOrUpdate(
        connectionCode: message.code,
        connectionWord: message.word,
      ),
    );
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
    AnalyticsManager.logHealthDataRequest(request);
    final responseData = await handleHealthDataRequest(request);
    final backendResponse = BackendResponse.healthDataResponse(
      id: message.id,
      data: responseData,
    );
    await sendToBackend(backendResponse.toJson());
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
