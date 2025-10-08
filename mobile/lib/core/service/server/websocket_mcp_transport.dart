import 'dart:async';

import 'package:flutter_template/core/common/logger.dart';
import 'package:flutter_template/core/service/server/mcp_connection_manager.dart';
import 'package:flutter_template/core/service/server/mcp_transport.dart';

class WebSocketMcpTransport implements McpTransport {
  WebSocketMcpTransport({
    required this.backendUri,
    this.pingInterval,
  });

  final Uri backendUri;
  final Duration? pingInterval;

  final StreamController<McpTransportEvent> _eventController =
      StreamController<McpTransportEvent>.broadcast();
  final StreamController<String> _messageController =
      StreamController<String>.broadcast();

  late final HealthMcpConnectionManager _connectionManager =
      HealthMcpConnectionManager(
    backendUrl: backendUri,
    pingInterval: pingInterval ?? const Duration(seconds: 25),
  )..setMessageHandler(_handleIncomingData);

  StreamSubscription<McpConnectionState>? _stateSubscription;
  StreamSubscription<Object>? _errorSubscription;
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

    _stateSubscription ??=
        _connectionManager.stateStream.listen(_handleStateChange);
    _errorSubscription ??= _connectionManager.errorStream.listen(_handleError);

    try {
      await _connectionManager.connect();
    } catch (error, stackTrace) {
      Logger.e('WebSocket transport failed to connect: $error', stackTrace);
      _eventController.add(
        McpTransportEvent.disconnected(
          errorMessage: error.toString(),
          lostConnection: true,
        ),
      );
      rethrow;
    }
  }

  @override
  Future<void> stop() async {
    _isConnected = false;
    await _connectionManager.disconnect();
    _eventController.add(const McpTransportEvent.disconnected());
  }

  @override
  Future<void> send(String message) => _connectionManager.send(message);

  @override
  Future<void> dispose() async {
    await stop();
    await _stateSubscription?.cancel();
    await _errorSubscription?.cancel();
    _stateSubscription = null;
    _errorSubscription = null;
    await _connectionManager.dispose();
    await _eventController.close();
    await _messageController.close();
  }

  Future<void> _handleIncomingData(dynamic data) async {
    if (data == null) {
      return;
    }

    final message = data is String ? data : data.toString();
    _messageController.add(message);
  }

  void _handleStateChange(McpConnectionState state) {
    switch (state) {
      case McpConnectionState.connecting:
        _eventController.add(const McpTransportEvent.connecting());
        break;
      case McpConnectionState.connected:
        if (!_isConnected) {
          _isConnected = true;
          _eventController.add(const McpTransportEvent.connected());
        }
        break;
      case McpConnectionState.disconnected:
        if (_isConnected) {
          _isConnected = false;
        }
        _eventController.add(const McpTransportEvent.disconnected());
        break;
    }
  }

  void _handleError(Object error) {
    Logger.e('WebSocket transport error: $error');
    _isConnected = false;
    _eventController.add(
      McpTransportEvent.disconnected(
        errorMessage: error.toString(),
        lostConnection: true,
      ),
    );
  }
}
