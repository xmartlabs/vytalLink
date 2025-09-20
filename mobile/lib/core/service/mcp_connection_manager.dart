import 'dart:async';

import 'package:flutter_template/core/common/logger.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status_codes;
import 'package:web_socket_channel/web_socket_channel.dart';

enum McpConnectionState {
  disconnected,
  connecting,
  connected,
}

typedef McpMessageHandler = Future<void> Function(dynamic data);

class HealthMcpConnectionManager {
  HealthMcpConnectionManager({
    required this.backendUrl,
    this.pingInterval = const Duration(seconds: 25),
    this.reconnectBaseDelay = const Duration(seconds: 2),
    this.reconnectMaxDelay = const Duration(seconds: 30),
    this.maxRetries,
  });

  final Uri backendUrl;
  final Duration pingInterval;
  final Duration reconnectBaseDelay;
  final Duration reconnectMaxDelay;
  final int? maxRetries;

  final _stateController = StreamController<McpConnectionState>.broadcast();
  final _errorController = StreamController<Object>.broadcast();

  McpMessageHandler? _onMessage;
  WebSocketChannel? _channel;
  StreamSubscription? _channelSubscription;
  Timer? _reconnectTimer;
  McpConnectionState _state = McpConnectionState.disconnected;
  int _retryCount = 0;
  bool _manuallyStopped = false;

  Stream<McpConnectionState> get stateStream => _stateController.stream;
  Stream<Object> get errorStream => _errorController.stream;

  McpConnectionState get state => _state;

  bool get isConnected => _state == McpConnectionState.connected;

  void setMessageHandler(McpMessageHandler handler) {
    _onMessage = handler;
  }

  Future<void> connect() async {
    if (_state == McpConnectionState.connected ||
        _state == McpConnectionState.connecting) {
      return;
    }

    _manuallyStopped = false;
    await _establishConnection();
  }

  Future<void> disconnect() async {
    _manuallyStopped = true;
    _cancelReconnect();
    await _teardownChannel(status_codes.normalClosure, 'Client requested stop');
  }

  Future<void> send(String message) async {
    final channel = _channel;
    if (channel == null) {
      throw StateError('Cannot send message: not connected');
    }

    channel.sink.add(message);
  }

  Future<void> dispose() async {
    await disconnect();
    await _stateController.close();
    await _errorController.close();
  }

  Future<void> _establishConnection() {
    _updateState(McpConnectionState.connecting);

    try {
      final channel = IOWebSocketChannel.connect(
        backendUrl,
        pingInterval: pingInterval,
      );

      _channel = channel;
      _channelSubscription = channel.stream.listen(
        _handleIncomingData,
        onDone: _handleClosed,
        onError: (Object error) {
          _errorController.add(error);
          _handleClosed(error: error);
        },
        cancelOnError: true,
      );

      _updateState(McpConnectionState.connected);
      Logger.i('MCP WebSocket connected to $backendUrl');
    } catch (error) {
      _errorController.add(error);
      Logger.e('MCP WebSocket connection failed: $error');
      _scheduleReconnect();
    }

    return Future.value();
  }

  Future<void> _teardownChannel(int closeCode, String reason) async {
    await _channelSubscription?.cancel();
    _channelSubscription = null;

    final channel = _channel;
    if (channel != null) {
      try {
        await channel.sink.close(closeCode, reason);
      } catch (error) {
        Logger.w('Error while closing MCP WebSocket: $error');
      }
      _channel = null;
    }

    _updateState(McpConnectionState.disconnected);
  }

  void _handleClosed({Object? error}) {
    _channelSubscription = null;
    _channel = null;

    if (_manuallyStopped) {
      _updateState(McpConnectionState.disconnected);
      return;
    }

    Logger.w(
      'MCP WebSocket connection closed${error != null ? ': $error' : ''}',
    );
    _updateState(McpConnectionState.disconnected);
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_manuallyStopped) {
      return;
    }

    if (maxRetries != null && _retryCount >= maxRetries!) {
      _updateState(McpConnectionState.disconnected);
      _errorController.add(StateError('Max reconnect attempts reached'));
      return;
    }

    _cancelReconnect();
    final delay = _calculateBackoffDelay();
    Logger.i('Scheduling MCP reconnect attempt in ${delay.inSeconds}s');

    _reconnectTimer = Timer(delay, _attemptReconnect);
  }

  Duration _calculateBackoffDelay() {
    final multiplier = 1 << _retryCount;
    final delayMs = reconnectBaseDelay.inMilliseconds * multiplier;
    final maxDelayMs = reconnectMaxDelay.inMilliseconds;
    final clampedMs = delayMs > maxDelayMs ? maxDelayMs : delayMs;
    return Duration(milliseconds: clampedMs);
  }

  void _cancelReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  void _updateState(McpConnectionState newState) {
    if (_state == newState) {
      return;
    }

    _state = newState;
    _stateController.add(newState);
  }

  void _handleIncomingData(dynamic data) {
    final handler = _onMessage;
    if (handler == null) {
      return;
    }
    _retryCount = 0;
    unawaited(_safeHandleMessage(handler, data));
  }

  Future<void> _safeHandleMessage(
    McpMessageHandler handler,
    dynamic data,
  ) async {
    try {
      await handler(data);
    } catch (error, stackTrace) {
      Logger.e('Error while handling MCP message: $error', error, stackTrace);
    }
  }

  void _attemptReconnect() {
    _retryCount++;
    unawaited(_establishConnection());
  }
}
