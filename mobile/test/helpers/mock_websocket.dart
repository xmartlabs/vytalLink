import 'dart:async';
import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MockWebSocketChannel extends Mock implements WebSocketChannel {}

class MockWebSocketSink extends Mock implements WebSocketSink {}

class MockStreamController<T> extends Mock implements StreamController<T> {}

/// Test WebSocket channel that simulates real WebSocket behavior
class TestWebSocketChannel extends Mock implements WebSocketChannel {
  final StreamController<dynamic> _streamController =
      StreamController<dynamic>.broadcast();
  final List<dynamic> sentMessages = [];
  bool _isClosed = false;

  @override
  Stream<dynamic> get stream => _streamController.stream;

  @override
  WebSocketSink get sink => TestWebSocketSink(this);

  @override
  int? get closeCode => _isClosed ? 1000 : null;

  @override
  String? get closeReason => _isClosed ? 'Normal closure' : null;

  @override
  String? get protocol => null;

  @override
  Future<dynamic> get ready => Future.value();

  void simulateMessage(Map<String, dynamic> message) {
    if (!_isClosed) {
      _streamController.add(jsonEncode(message));
    }
  }

  void simulateError(dynamic error) {
    if (!_isClosed) {
      _streamController.addError(error);
    }
  }

  void simulateClose() {
    _isClosed = true;
    _streamController.close();
  }

  void _addMessage(dynamic message) {
    sentMessages.add(message);
  }

  void dispose() {
    _streamController.close();
  }
}

class TestWebSocketSink implements WebSocketSink {
  final TestWebSocketChannel _channel;

  TestWebSocketSink(this._channel);

  @override
  void add(dynamic data) {
    _channel._addMessage(data);
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    _channel.simulateError(error);
  }

  @override
  Future addStream(Stream stream) async {
    await for (final data in stream) {
      add(data);
    }
  }

  @override
  Future close([int? closeCode, String? closeReason]) async {
    _channel.simulateClose();
  }

  @override
  Future get done => _channel._streamController.done;
}

/// Factory for creating WebSocket test messages
class WebSocketTestMessageFactory {
  static Map<String, dynamic> createHealthDataRequestMessage({
    String id = 'test-id-123',
    String valueType = 'STEPS',
    String? startTime,
    String? endTime,
    String? groupBy,
    String? statistic,
  }) {
    final now = DateTime.now();
    return {
      'type': 'health_data_request',
      'request_id': id,
      'payload': {
        'value_type': valueType,
        'start_time': startTime ??
            now.subtract(const Duration(days: 1)).toIso8601String(),
        'end_time': endTime ?? now.toIso8601String(),
        if (groupBy != null) 'group_by': groupBy,
        if (statistic != null) 'statistic': statistic,
      },
    };
  }

  static Map<String, dynamic> createConnectionCodeMessage({
    String code = 'ABC123',
    String word = 'elephant',
    String message = 'Connection established',
  }) => {
      'type': 'connection_code',
      'code': code,
      'word': word,
      'message': message,
    };

  static Map<String, dynamic> createUnknownMessage() => {
      'type': 'unknown_message_type',
      'data': 'some random data',
    };

  static Map<String, dynamic> createMalformedMessage() => {
      'invalid': 'json structure',
      'missing': 'required fields',
    };
}
