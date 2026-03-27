import 'dart:async';

import 'package:flutter_template/core/service/server/mcp_transport.dart';

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
