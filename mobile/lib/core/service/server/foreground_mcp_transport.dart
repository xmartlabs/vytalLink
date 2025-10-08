import 'dart:async';
import 'dart:convert';

import 'package:flutter_template/core/common/logger.dart';
import 'package:flutter_template/core/service/server/mcp_background_service.dart';
import 'package:flutter_template/core/service/server/mcp_transport.dart';

class ForegroundMcpTransport implements McpTransport {
  ForegroundMcpTransport({
    required this.backendUri,
    this.connectionTimeout = const Duration(seconds: 10),
  });

  final Uri backendUri;
  final Duration connectionTimeout;

  final StreamController<McpTransportEvent> _eventController =
      StreamController<McpTransportEvent>.broadcast();
  final StreamController<String> _messageController =
      StreamController<String>.broadcast();

  StreamSubscription<Map<String, dynamic>>? _serviceSubscription;
  Completer<void>? _connectCompleter;
  bool _maintainConnection = false;
  bool _isConnected = false;

  @override
  Stream<McpTransportEvent> get events => _eventController.stream;

  @override
  Stream<String> get messages => _messageController.stream;

  @override
  bool get isConnected => _isConnected;

  @override
  Future<void> start() async {
    if (_isConnected) {
      return;
    }

    _ensureSubscription();
    _eventController.add(const McpTransportEvent.connecting());

    try {
      _maintainConnection = true;
      McpBackgroundService.initializeCommunication();
      await McpBackgroundService.ensureNotificationPermission();
      await McpBackgroundService.startOrUpdate();
      _connectCompleter = Completer<void>();
      await _sendConnectCommand();
      await _connectCompleter!.future.timeout(connectionTimeout);
    } on TimeoutException catch (error) {
      await _handleConnectionFailure(error.message ?? 'Connection timeout');
      rethrow;
    } catch (error) {
      await _handleConnectionFailure(error.toString());
      rethrow;
    }
  }

  @override
  Future<void> stop() async {
    _maintainConnection = false;
    _connectCompleter = null;
    _isConnected = false;
    await McpBackgroundService.sendCommand(<String, dynamic>{
      McpBackgroundService.commandActionKey:
          McpBackgroundService.commandDisconnect,
    });
    await McpBackgroundService.stopService();
    _eventController.add(const McpTransportEvent.disconnected());
  }

  @override
  Future<void> send(String message) async {
    await McpBackgroundService.sendCommand(<String, dynamic>{
      McpBackgroundService.commandActionKey: McpBackgroundService.commandSend,
      McpBackgroundService.commandMessageKey: message,
    });
  }

  @override
  Future<void> dispose() async {
    await stop();
    await _serviceSubscription?.cancel();
    await _eventController.close();
    await _messageController.close();
  }

  void _ensureSubscription() {
    _serviceSubscription ??=
        McpBackgroundService.events.listen(_handleServiceEvent);
  }

  Future<void> _sendConnectCommand() async {
    await McpBackgroundService.sendCommand(<String, dynamic>{
      McpBackgroundService.commandActionKey:
          McpBackgroundService.commandConnect,
      McpBackgroundService.commandUrlKey: backendUri.toString(),
    });
  }

  Future<void> _handleConnectionFailure(String message) async {
    Logger.e('Foreground transport failed to connect: $message');
    _maintainConnection = false;
    _connectCompleter = null;
    await McpBackgroundService.sendCommand(<String, dynamic>{
      McpBackgroundService.commandActionKey:
          McpBackgroundService.commandDisconnect,
    });
    await McpBackgroundService.stopService();
    _isConnected = false;
    _eventController.add(
      McpTransportEvent.disconnected(
        errorMessage: message,
        lostConnection: true,
      ),
    );
  }

  void _handleServiceEvent(Map<String, dynamic> event) {
    final eventType = event[McpBackgroundService.eventTypeKey];
    if (eventType is! String) {
      return;
    }

    switch (eventType) {
      case McpBackgroundService.eventServiceStarted:
        _onServiceStarted();
        break;
      case McpBackgroundService.eventConnected:
        _onServiceConnected();
        break;
      case McpBackgroundService.eventDisconnected:
        _onServiceDisconnected(event);
        break;
      case McpBackgroundService.eventMessage:
        _onServiceMessage(event);
        break;
      case McpBackgroundService.eventError:
        _onServiceError(event);
        break;
      case McpBackgroundService.eventIdleTimeout:
        _onServiceIdleTimeout();
        break;
    }
  }

  void _onServiceStarted() {
    if (!_maintainConnection) {
      return;
    }
    _connectCompleter ??= Completer<void>();
    unawaited(_sendConnectCommand());
  }

  void _onServiceConnected() {
    _isConnected = true;
    _eventController.add(const McpTransportEvent.connected());
    final completer = _connectCompleter;
    if (completer != null && !completer.isCompleted) {
      completer.complete();
    }
    _connectCompleter = null;
  }

  void _onServiceDisconnected(Map<String, dynamic> event) {
    _isConnected = false;
    final reason = event[McpBackgroundService.eventReasonKey]?.toString();
    _eventController.add(
      McpTransportEvent.disconnected(
        lostConnection:
            reason != McpBackgroundService.eventDisconnectedReasonUser,
      ),
    );
  }

  void _onServiceMessage(Map<String, dynamic> event) {
    final payload = event[McpBackgroundService.eventPayloadKey];
    if (payload == null) {
      return;
    }
    if (payload is String) {
      _messageController.add(payload);
      return;
    }
    _messageController.add(jsonEncode(payload));
  }

  void _onServiceError(Map<String, dynamic> event) {
    final detail = event[McpBackgroundService.eventDetailKey]?.toString();
    _handleTransportError(detail);
  }

  void _onServiceIdleTimeout() {
    _isConnected = false;
    _maintainConnection = false;
    _eventController.add(
      const McpTransportEvent.disconnected(
        errorMessage: 'Idle timeout',
        lostConnection: true,
      ),
    );
  }

  void _handleTransportError(String? detail) {
    final message = detail?.isNotEmpty ?? false ? detail! : 'Unknown error';
    Logger.e('Foreground transport error: $message');
    final completer = _connectCompleter;
    if (completer != null && !completer.isCompleted) {
      completer.completeError(Exception(message));
      _connectCompleter = null;
    }
    _isConnected = false;
    _maintainConnection = false;
    _eventController.add(
      McpTransportEvent.disconnected(
        errorMessage: message,
        lostConnection: true,
      ),
    );
  }
}
