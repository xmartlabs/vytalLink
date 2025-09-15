import 'dart:async';
import 'dart:convert';

import 'package:flutter_template/core/common/config.dart';
import 'package:flutter_template/core/common/logger.dart';
import 'package:flutter_template/core/model/backend_message.dart';
import 'package:flutter_template/core/model/backend_response.dart';
import 'package:flutter_template/core/model/health_data_request.dart';
import 'package:flutter_template/core/model/health_data_response.dart';
import 'package:flutter_template/core/service/health_data_manager.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HealthMcpServerConfig {
  const HealthMcpServerConfig({
    required this.serverName,
    required this.serverVersion,
    required this.host,
    required this.port,
    required this.endpoint,
    this.isJsonResponseEnabled = true,
  });

  final String serverName;
  final String serverVersion;
  final String host;
  final int port;
  final String endpoint;
  final bool isJsonResponseEnabled;
}

class HealthMcpServerException implements Exception {
  const HealthMcpServerException(this.message, [this.cause]);

  final String message;
  final dynamic cause;

  @override
  String toString() => 'HealthMcpServerException: $message'
      '${cause != null ? ' (Cause: $cause)' : ''}';
}

class HealthPermissionException extends HealthMcpServerException {
  const HealthPermissionException(super.message, [super.cause]);
}

class HealthDataUnavailableException extends HealthMcpServerException {
  const HealthDataUnavailableException(super.message, [super.cause]);
}

class HealthMcpServerService {
  HealthMcpServerService({
    required this.config,
    HealthDataManager? healthDataManager,
  }) : _healthDataManager = healthDataManager ?? HealthDataManager();

  final HealthMcpServerConfig config;
  final HealthDataManager _healthDataManager;

  late WebSocketChannel webSocketChannel;

  bool _isConnected = false;

  bool get isConnected => _isConnected;

  final Uri _backendUrl = Uri.parse(Config.wsUrl);

  void Function(String code, String word, String message)?
      _onConnectionCodeReceived;
  void Function(String error)? _onConnectionError;
  void Function()? _onConnectionLost;

  void setConnectionCodeCallback(
    void Function(String code, String word, String message) callback,
  ) {
    _onConnectionCodeReceived = callback;
  }

  void setConnectionErrorCallback(
    void Function(String error) callback,
  ) {
    _onConnectionError = callback;
  }

  void setConnectionLostCallback(
    void Function() callback,
  ) {
    _onConnectionLost = callback;
  }

  Future<void> stop() async {
    if (_isConnected) {
      await webSocketChannel.sink.close();
      _isConnected = false;
    }
  }

  Future<void> connectToBackend() async {
    try {
      webSocketChannel = IOWebSocketChannel.connect(_backendUrl);
      _isConnected = true;

      Logger.i('Connected to backend at ${_backendUrl.toString()}');

      webSocketChannel.stream.listen(
        (dynamic data) {
          handleBackendMessage(data);
        },
        onError: (dynamic error) {
          Logger.e('WebSocket error: $error');
          _onConnectionError?.call(error.toString());
          _isConnected = false;
        },
        onDone: () {
          Logger.w('WebSocket connection closed');
          _onConnectionLost?.call();
          _isConnected = false;
        },
      );
    } catch (e) {
      Logger.e('Failed to connect to backend: $e');
      _onConnectionError?.call(e.toString());
      throw HealthMcpServerException('Failed to connect to backend', e);
    }
  }

  Future<void> sendToBackend(Map<String, dynamic> message) async {
    if (!_isConnected) {
      throw Exception('Not connected to backend');
    }

    final jsonMessage = jsonEncode(message);
    webSocketChannel.sink.add(jsonMessage);
    Logger.d('Sent message to backend: $jsonMessage');
  }

  Future<void> handleBackendMessage(dynamic data) async {
    try {
      final Map<String, dynamic> rawMessage = jsonDecode(data);
      Logger.d('Received raw message: $rawMessage');
      final BackendMessage message = BackendMessage.fromJson(rawMessage);

      Logger.d('Processing backend message: ${message.runtimeType}');

      switch (message) {
        case HealthDataRequestMessage(:final id, :final payload):
          final request = HealthDataRequest.fromJson(payload);
          final responseData = await handleHealthDataRequest(request);
          final backendResponse = BackendResponse.healthDataResponse(
            id: id,
            data: responseData,
          );
          await sendToBackend(backendResponse.toJson());
          break;

        case ConnectionCodeMessage(:final code, :final word, :final message):
          Logger.i('Received connection code: $code');
          _onConnectionCodeReceived?.call(code, word, message);
          break;

        case UnknownMessage():
          Logger.w('Unknown message type received');
          break;
      }
    } catch (e) {
      Logger.e('Error processing backend message: $e', e);
      try {
        await sendToBackend(
          {'error': 'Error processing message: ${e.toString()}'},
        );
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
      return response.toJson();
    } catch (e) {
      final errorResponse = HealthDataErrorResponse(
        success: false,
        errorMessage: 'Error retrieving health data: ${e.toString()}',
      );
      return errorResponse.toJson();
    }
  }
}
