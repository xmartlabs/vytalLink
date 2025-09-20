import 'dart:async';
import 'dart:convert';

import 'package:flutter_template/core/common/config.dart';
import 'package:flutter_template/core/common/logger.dart';
import 'package:flutter_template/core/model/backend_message.dart';
import 'package:flutter_template/core/model/backend_response.dart';
import 'package:flutter_template/core/model/health_data_request.dart';
import 'package:flutter_template/core/model/health_data_response.dart';
import 'package:flutter_template/core/service/health_data_manager.dart';
import 'package:flutter_template/core/service/mcp_background_service.dart';
import 'package:flutter_template/core/service/mcp_connection_manager.dart';

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
  })  : _healthDataManager = healthDataManager ?? HealthDataManager(),
        _useForegroundService =
            McpBackgroundService.isForegroundServiceAvailable {
    if (_useForegroundService) {
      McpBackgroundService.initializeCommunication();
      _serviceEventSubscription =
          McpBackgroundService.events.listen(_handleServiceEvent);
    } else {
      _connectionManager = HealthMcpConnectionManager(
        backendUrl: Uri.parse(Config.wsUrl),
        maxRetries: 2,
        reconnectMaxDelay: const Duration(seconds: 2),
      )..setMessageHandler(handleBackendMessage);
      _stateSubscription =
          _connectionManager!.stateStream.listen(_handleConnectionState);
      _errorSubscription =
          _connectionManager!.errorStream.listen(_handleConnectionError);
    }
  }

  final HealthMcpServerConfig config;
  final HealthDataManager _healthDataManager;

  final bool _useForegroundService;

  HealthMcpConnectionManager? _connectionManager;
  StreamSubscription<McpConnectionState>? _stateSubscription;
  StreamSubscription<Object>? _errorSubscription;
  StreamSubscription<Map<String, dynamic>>? _serviceEventSubscription;
  Completer<void>? _connectCompleter;
  bool _wasConnected = false;
  bool _foregroundConnected = false;
  bool _sessionEstablished = false;
  bool _maintainConnection = false;
  DateTime? _lastErrorReportedAt;
  final Duration _errorReportCooldown = const Duration(seconds: 30);

  bool get isConnected => _useForegroundService
      ? _sessionEstablished
      : _connectionManager?.state == McpConnectionState.connected;

  final Uri _backendUrl = Uri.parse(Config.wsUrl);

  void Function(String code, String word, String message)?
      _onConnectionCodeReceived;
  void Function(String error)? _onConnectionError;
  void Function()? _onConnectionLost;
  void Function()? _onConnectionEstablished;
  void Function()? _onServiceStopped;

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

  void setConnectionEstablishedCallback(
    void Function() callback,
  ) {
    _onConnectionEstablished = callback;
  }

  void setServiceStoppedCallback(
    void Function() callback,
  ) {
    _onServiceStopped = callback;
  }

  Future<void> stop() async {
    _maintainConnection = false;
    if (_useForegroundService) {
      await McpBackgroundService.sendCommand(<String, dynamic>{
        McpBackgroundService.commandActionKey:
            McpBackgroundService.commandDisconnect,
      });
    } else {
      await _connectionManager?.disconnect();
    }
  }

  Future<void> connectToBackend() async {
    if (_useForegroundService) {
      _maintainConnection = true;
      McpBackgroundService.initializeCommunication();
      await McpBackgroundService.ensureNotificationPermission();
      await McpBackgroundService.startOrUpdate();

      if (_foregroundConnected) {
        _connectCompleter?.complete();
        _connectCompleter = null;
        return;
      }

      if (_connectCompleter != null) {
        await _connectCompleter!.future;
        return;
      }

      _connectCompleter = Completer<void>();
      await McpBackgroundService.sendCommand(<String, dynamic>{
        McpBackgroundService.commandActionKey:
            McpBackgroundService.commandConnect,
        McpBackgroundService.commandUrlKey: _backendUrl.toString(),
      });

      try {
        await _connectCompleter!.future.timeout(const Duration(seconds: 10));
      } on TimeoutException catch (error) {
        _connectCompleter = null;
        _maintainConnection = false;
        await McpBackgroundService.sendCommand(<String, dynamic>{
          McpBackgroundService.commandActionKey:
              McpBackgroundService.commandDisconnect,
        });
        await McpBackgroundService.stopService();
        _onConnectionError?.call(error.message ?? 'Connection timeout');
        throw HealthMcpServerException('Failed to connect to backend', error);
      } catch (error) {
        _connectCompleter = null;
        _maintainConnection = false;
        await McpBackgroundService.sendCommand(<String, dynamic>{
          McpBackgroundService.commandActionKey:
              McpBackgroundService.commandDisconnect,
        });
        await McpBackgroundService.stopService();
        _onConnectionError?.call(error.toString());
        throw HealthMcpServerException('Failed to connect to backend', error);
      }
      return;
    }

    try {
      await _connectionManager?.connect();
    } catch (e, stackTrace) {
      Logger.e('Failed to connect to backend: $e', stackTrace);
      _onConnectionError?.call(e.toString());
      throw HealthMcpServerException('Failed to connect to backend', e);
    }
  }

  Future<void> sendToBackend(Map<String, dynamic> message) async {
    if (!isConnected) {
      throw Exception('Not connected to backend');
    }

    final jsonMessage = jsonEncode(message);
    if (_useForegroundService) {
      await McpBackgroundService.sendCommand(<String, dynamic>{
        McpBackgroundService.commandActionKey: McpBackgroundService.commandSend,
        McpBackgroundService.commandMessageKey: jsonMessage,
      });
    } else {
      await _connectionManager?.send(jsonMessage);
    }
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
          _sessionEstablished = true;
          _connectCompleter?.complete();
          _connectCompleter = null;
          _onConnectionCodeReceived?.call(code, word, message);
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
      return response.toJson();
    } catch (e) {
      final errorResponse = HealthDataErrorResponse(
        success: false,
        errorMessage: 'Error retrieving health data: ${e.toString()}',
      );
      return errorResponse.toJson();
    }
  }

  void _handleConnectionState(McpConnectionState state) {
    if (state == McpConnectionState.connected) {
      if (!_wasConnected) {
        Logger.i('Connected to backend at ${_backendUrl.toString()}');
      }
      _wasConnected = true;
      return;
    }

    if (state == McpConnectionState.disconnected && _wasConnected) {
      _onConnectionLost?.call();
      _wasConnected = false;
    }
  }

  void _handleConnectionError(Object error) {
    Logger.e('WebSocket error: $error');
    if (_connectCompleter != null) {
      return;
    }
    final now = DateTime.now();
    if (_lastErrorReportedAt != null &&
        now.difference(_lastErrorReportedAt!) < _errorReportCooldown) {
      return;
    }
    _lastErrorReportedAt = now;
    _onConnectionError?.call(error.toString());
  }

  void _handleServiceEvent(Map<String, dynamic> event) {
    final eventType = event[McpBackgroundService.eventTypeKey];
    if (eventType is! String) {
      return;
    }

    switch (eventType) {
      case McpBackgroundService.eventConnected:
        _onServiceConnected();
        break;

      case McpBackgroundService.eventDisconnected:
        _onServiceDisconnected();
        break;

      case McpBackgroundService.eventMessage:
        final payload = event[McpBackgroundService.eventPayloadKey];
        _onServiceMessage(payload);
        break;

      case McpBackgroundService.eventError:
        final detail = event[McpBackgroundService.eventDetailKey]?.toString();
        _onServiceError(detail);
        break;

      case McpBackgroundService.eventServiceStarted:
        _onServiceStarted();
        break;

      case McpBackgroundService.eventIdleTimeout:
        _onServiceStoppedByIdle();
        break;
    }
  }

  void _onServiceConnected() {
    Logger.d('Foreground service reported connection established');
    _foregroundConnected = true;
  }

  void _onServiceDisconnected() {
    Logger.w('Foreground service reported disconnection');
    final wasConnected = _sessionEstablished;
    _foregroundConnected = false;
    _sessionEstablished = false;
    if (wasConnected) {
      _onConnectionLost?.call();
    }
    if (_maintainConnection) {}
  }

  void _onServiceMessage(dynamic payload) {
    if (payload == null) {
      return;
    }

    Logger.d('Foreground service delivered payload');
    unawaited(handleBackendMessage(payload));
  }

  void _onServiceError(String? detail) {
    final message = detail ?? 'Unknown error';
    final isMaxReached = message.contains('Max reconnect attempts reached');
    if (_connectCompleter != null) {
      if (isMaxReached) {
        Logger.e('Foreground service error: $message');
        _connectCompleter!.completeError(StateError('Connection failed'));
      }
      return;
    }
    Logger.e('Foreground service error: $message');
    if (isMaxReached) {
      _maintainConnection = false;
      unawaited(McpBackgroundService.sendCommand(<String, dynamic>{
        McpBackgroundService.commandActionKey:
            McpBackgroundService.commandDisconnect,
      }));
      unawaited(McpBackgroundService.stopService());
      _onConnectionError?.call('Connection failed');
      return;
    }
    final now = DateTime.now();
    if (_lastErrorReportedAt != null &&
        now.difference(_lastErrorReportedAt!) < _errorReportCooldown) {
      return;
    }
    _lastErrorReportedAt = now;
    _onConnectionError?.call(message);
  }

  void _onServiceStarted() {
    Logger.d('Foreground service started');
    if (_maintainConnection) {
      _requestServiceReconnect();
    }
  }

  void _onServiceStoppedByIdle() {
    _foregroundConnected = false;
    _sessionEstablished = false;
    _maintainConnection = false;
    _onServiceStopped?.call();
  }

  void _requestServiceReconnect() {
    if (_foregroundConnected) {
      return;
    }

    if (_connectCompleter == null) {
      _connectCompleter = Completer<void>();
      unawaited(
        McpBackgroundService.sendCommand(<String, dynamic>{
          McpBackgroundService.commandActionKey:
              McpBackgroundService.commandConnect,
          McpBackgroundService.commandUrlKey: _backendUrl.toString(),
        }),
      );

      unawaited(() async {
        try {
          await _connectCompleter!.future
              .timeout(const Duration(seconds: 10));
        } on TimeoutException {
          _connectCompleter = null;
          final now = DateTime.now();
          if (_lastErrorReportedAt == null ||
              now.difference(_lastErrorReportedAt!) >= _errorReportCooldown) {
            _lastErrorReportedAt = now;
            _onConnectionError?.call('Connection lost, retrying…');
          }
        }
      }());
    }
  }

  Future<void> dispose() async {
    _maintainConnection = false;
    await _stateSubscription?.cancel();
    await _errorSubscription?.cancel();
    await _connectionManager?.dispose();
    await _serviceEventSubscription?.cancel();
  }
}
