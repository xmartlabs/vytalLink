import 'dart:async';

import 'package:flutter_template/core/service/server/mcp_transport_event.dart';

export 'mcp_transport_event.dart';

abstract interface class McpTransport {
  Stream<McpTransportEvent> get events;

  Stream<String> get messages;

  bool get isConnected;

  Future<void> start();

  Future<void> stop();

  Future<void> send(String message);

  Future<void> dispose();
}
