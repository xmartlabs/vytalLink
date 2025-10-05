import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
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
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

export 'package:flutter_template/core/model/mcp_connection_state.dart';

class HealthMcpServerService {
  HealthMcpServerService({
    HealthDataManager? healthDataManager,
  }) : _healthDataManager = healthDataManager ?? HealthDataManager();
  final BehaviorSubject<McpConnectionState> _connectionState =
      BehaviorSubject<McpConnectionState>.seeded(
    const McpConnectionState.disconnected(),
  );

  final HealthDataManager _healthDataManager;

  @visibleForTesting
  late WebSocketChannel webSocketChannel;

  Stream<McpConnectionState> get status => _connectionState.stream;

  McpConnectionState get currentStatus =>
      _connectionState.valueOrNull ??
      const McpConnectionState.disconnected(lostConnection: false);

  bool get isConnected => currentStatus is McpConnectionStateConnected;

  bool get isConnecting => currentStatus is McpConnectionStateConnecting;

  bool get isDisconnected => currentStatus is McpConnectionStateDisconnected;

  Future<void> stop() async {
    if (!isDisconnected) {
      await webSocketChannel.sink.close();
      _connectionState.add(
        const McpConnectionState.disconnected(),
      );
    }
  }

  Future<McpConnectionState> connectToBackend() async {
    try {
      _connectionState.add(const McpConnectionState.connecting());
      webSocketChannel = IOWebSocketChannel.connect(Uri.parse(Config.wsUrl));

      Logger.d('Connected to backend at ${Config.wsUrl}');
      AnalyticsManager.logMcpConnectionStarted();
      webSocketChannel.stream.listen(
        (data) {
          handleBackendMessage(data);
        },
        onError: (dynamic error) {
          Logger.e('WebSocket error: $error');
          AnalyticsManager.logMcpConnectionError(
            errorMessage: error.toString(),
          );
          _connectionState.add(
            McpConnectionState.disconnected(
              errorMessage: error.toString(),
              lostConnection: true,
            ),
          );
        },
        onDone: () {
          Logger.w('WebSocket connection closed');
          AnalyticsManager.logMcpConnectionLost();
          _connectionState.add(
            const McpConnectionState.disconnected(lostConnection: true),
          );
        },
      );
    } catch (error) {
      Logger.e('Failed to connect to backend: $error');
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
    webSocketChannel.sink.add(jsonMessage);
    Logger.d('Sent message to backend: $jsonMessage');
  }

  Future<void> handleBackendMessage(String data) async {
    try {
      final Map<String, dynamic> rawMessage = jsonDecode(data);
      Logger.d('Received raw message: $rawMessage');
      final BackendMessage message = BackendMessage.fromJson(rawMessage);

      Logger.d('Processing backend message: ${message.runtimeType}');

      switch (message) {
        case HealthDataRequestMessage(:final id, :final payload):
          final request = HealthDataRequest.fromJson(payload);
          AnalyticsManager.logHealthDataRequest(request);
          final responseData = await handleHealthDataRequest(request);
          final backendResponse = BackendResponse.healthDataResponse(
            id: id,
            data: responseData,
          );
          await sendToBackend(backendResponse.toJson());
          break;

        case ConnectionCodeMessage(:final code, :final word, :final message):
          Logger.d('Received connection code: $code');
          _connectionState.add(
            McpConnectionState.connected(
              credentials: (
                connectionWord: word,
                connectionPin: code,
              ),
              message: message,
            ),
          );
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
      } catch (e) {
        Logger.e('Error sending error message to backend: $e', e);
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
}
