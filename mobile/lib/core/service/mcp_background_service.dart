import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_template/core/service/mcp_connection_manager.dart';

const _notificationChannelId = 'vytal_mcp_background_channel';
const _notificationChannelName = 'MCP Background Service';
const _notificationChannelDescription =
    'Keeps the MCP connection active while the app is in background';
const _notificationTitle = 'VytalLink MCP Connected';
const _notificationIconMetaData =
    'com.pravera.flutter_foreground_task.notification_icon';

bool _shouldUseForegroundService() => !kIsWeb && Platform.isAndroid;

class McpBackgroundService {
  McpBackgroundService._();

  static const String commandActionKey = 'action';
  static const String commandConnect = 'connect';
  static const String commandDisconnect = 'disconnect';
  static const String commandSend = 'send';

  static const String commandUrlKey = 'url';
  static const String commandMessageKey = 'message';

  static const String eventTypeKey = 'type';
  static const String eventConnected = 'connected';
  static const String eventDisconnected = 'disconnected';
  static const String eventMessage = 'message';
  static const String eventError = 'error';
  static const String eventDetailKey = 'detail';
  static const String eventPayloadKey = 'payload';
  static const String eventReasonKey = 'reason';
  static const String eventServiceStarted = 'service_started';

  static bool _initialized = false;
  static bool _permissionsRequested = false;
  static String? _currentCode;
  static String? _currentWord;
  static bool _communicationInitialized = false;
  static final StreamController<Map<String, dynamic>> _eventController =
      StreamController<Map<String, dynamic>>.broadcast();

  static Future<void> initialize() async {
    if (!_shouldUseForegroundService()) {
      return;
    }

    if (_initialized) {
      return;
    }

    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: _notificationChannelId,
        channelName: _notificationChannelName,
        channelDescription: _notificationChannelDescription,
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        playSound: false,
        showWhen: false,
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );

    _initialized = true;
    _logInfo('MCP background service initialized');
  }

  static bool get isForegroundServiceAvailable => _shouldUseForegroundService();

  static void initializeCommunication() {
    if (!_shouldUseForegroundService()) {
      return;
    }

    if (_communicationInitialized) {
      return;
    }

    FlutterForegroundTask.initCommunicationPort();
    FlutterForegroundTask.addTaskDataCallback(_onTaskDataReceived);
    _communicationInitialized = true;
  }

  static Stream<Map<String, dynamic>> get events => _eventController.stream;

  static Future<void> ensureNotificationPermission() async {
    if (!_shouldUseForegroundService() || _permissionsRequested) {
      return;
    }

    try {
      final status = await FlutterForegroundTask.checkNotificationPermission();
      if (status == NotificationPermission.denied) {
        await FlutterForegroundTask.requestNotificationPermission();
      }
      _permissionsRequested = true;
    } catch (error, stackTrace) {
      _logWarning(
        'Unable to request notification permission: $error',
        error,
        stackTrace,
      );
    }
  }

  static Future<void> startOrUpdate({
    String? connectionCode,
    String? connectionWord,
  }) async {
    if (!_shouldUseForegroundService()) {
      return;
    }

    if (!_initialized) {
      await initialize();
    }

    initializeCommunication();
    _currentCode = connectionCode ?? _currentCode;
    _currentWord = connectionWord ?? _currentWord;

    final notificationText = _buildNotificationText(
      code: _currentCode,
      word: _currentWord,
    );

    final isRunning = await FlutterForegroundTask.isRunningService;
    if (isRunning) {
      final result = await FlutterForegroundTask.updateService(
        notificationTitle: _notificationTitle,
        notificationText: notificationText,
        notificationIcon: const NotificationIcon(
          metaDataName: _notificationIconMetaData,
        ),
      );

      if (result is ServiceRequestFailure) {
        _logWarning(
          'Failed to update MCP foreground service: ${result.error}',
          result.error,
          null,
        );
      }
      return;
    }

    final result = await FlutterForegroundTask.startService(
      notificationTitle: _notificationTitle,
      notificationText: notificationText,
      notificationIcon: const NotificationIcon(
        metaDataName: _notificationIconMetaData,
      ),
      callback: mcpBackgroundServiceStartCallback,
    );

    if (result is ServiceRequestFailure) {
      _logWarning(
        'Failed to start MCP foreground service: ${result.error}',
        result.error,
        null,
      );
    } else {
      _logInfo('MCP foreground service started');
    }
  }

  static Future<void> stopService() async {
    if (!_shouldUseForegroundService()) {
      return;
    }

    try {
      if (!_initialized) {
        await initialize();
      }
      final isRunning = await FlutterForegroundTask.isRunningService;
      if (!isRunning) {
        return;
      }

      final result = await FlutterForegroundTask.stopService();
      if (result is ServiceRequestFailure) {
        _logWarning(
          'Failed to stop MCP foreground service: ${result.error}',
          result.error,
          null,
        );
      } else {
        _logInfo('MCP foreground service stopped');
        _currentCode = null;
        _currentWord = null;
      }
    } catch (error, stackTrace) {
      _logWarning(
        'Error stopping MCP foreground service: $error',
        error,
        stackTrace,
      );
    }
  }

  static String _buildNotificationText({String? code, String? word}) {
    final resolvedCode = (code?.isNotEmpty ?? false) ? code : 'Pending';
    final resolvedWord = (word?.isNotEmpty ?? false) ? word : 'Pending';
    return 'Connect using word $resolvedWord • PIN $resolvedCode';
  }

  static void _onTaskDataReceived(Object data) {
    if (data is! Map) {
      return;
    }

    try {
      final typedData = data.map((key, value) => MapEntry('$key', value));
      _eventController.add(typedData);
    } catch (error, stackTrace) {
      _logWarning(
        'Failed to process foreground task event: $error',
        error,
        stackTrace,
      );
    }
  }

  static Future<void> sendCommand(Map<String, dynamic> command) async {
    if (!_shouldUseForegroundService()) {
      return;
    }

    try {
      FlutterForegroundTask.sendDataToTask(command);
    } catch (error, stackTrace) {
      _logWarning(
        'Failed to send command to foreground task: $error',
        error,
        stackTrace,
      );
    }
  }
}

@pragma('vm:entry-point')
void mcpBackgroundServiceStartCallback() {
  if (!_shouldUseForegroundService()) {
    return;
  }

  FlutterForegroundTask.setTaskHandler(_McpForegroundTaskHandler());
}

class _McpForegroundTaskHandler extends TaskHandler {
  HealthMcpConnectionManager? _connectionManager;
  StreamSubscription<McpConnectionState>? _stateSubscription;
  StreamSubscription<Object>? _errorSubscription;
  String? _webSocketUrl;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    _logInfo('MCP foreground task started by $starter at $timestamp');
    FlutterForegroundTask.sendDataToMain(<String, dynamic>{
      McpBackgroundService.eventTypeKey:
          McpBackgroundService.eventServiceStarted,
    });
  }

  @override
  void onReceiveData(Object data) {
    if (data is! Map) {
      _logWarning('Received unsupported data type from main isolate: $data');
      return;
    }

    final action = data[McpBackgroundService.commandActionKey];
    if (action is! String) {
      _logWarning('Missing action in foreground service command: $data');
      return;
    }

    switch (action) {
      case McpBackgroundService.commandConnect:
        final url = data[McpBackgroundService.commandUrlKey] as String?;
        if (url == null) {
          _logWarning('Connect command missing url: $data');
          return;
        }
        unawaited(_connect(url));
        break;

      case McpBackgroundService.commandDisconnect:
        unawaited(_disconnect());
        break;

      case McpBackgroundService.commandSend:
        final message = data[McpBackgroundService.commandMessageKey] as String?;
        if (message == null) {
          _logWarning('Send command missing message payload');
          return;
        }
        unawaited(_send(message));
        break;

      default:
        _logWarning('Unknown foreground service command: $action');
        break;
    }
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    // No periodic work required; connection retries run in main isolate.
    return;
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    _logInfo('MCP foreground task destroyed at $timestamp');
    await _disposeConnection();
  }

  Future<void> _connect(String url) async {
    try {
      if (_connectionManager == null || _webSocketUrl != url) {
        await _disposeConnection();
        _webSocketUrl = url;
        _connectionManager = HealthMcpConnectionManager(
          backendUrl: Uri.parse(url),
          maxRetries: 2,
          reconnectMaxDelay: const Duration(seconds: 2),
        )..setMessageHandler(_onBackendMessage);
        _stateSubscription = _connectionManager!.stateStream.listen(
          _handleConnectionState,
        );
        _errorSubscription = _connectionManager!.errorStream.listen(
          _handleConnectionError,
        );
      }

      await _connectionManager!.connect();
    } catch (error, stackTrace) {
      _logError('Failed to connect to backend from foreground task: $error');
      FlutterForegroundTask.sendDataToMain(<String, dynamic>{
        McpBackgroundService.eventTypeKey: McpBackgroundService.eventError,
        McpBackgroundService.eventDetailKey: error.toString(),
      });
      _logError(error, stackTrace: stackTrace);
    }
  }

  Future<void> _disconnect() async {
    try {
      await _connectionManager?.disconnect();
    } catch (error, stackTrace) {
      _logWarning(
        'Error while disconnecting MCP WebSocket from foreground task: $error',
        error,
        stackTrace,
      );
    }
  }

  Future<void> _send(String message) async {
    try {
      final connection = _connectionManager;
      if (connection == null || !connection.isConnected) {
        FlutterForegroundTask.sendDataToMain(<String, dynamic>{
          McpBackgroundService.eventTypeKey: McpBackgroundService.eventError,
          McpBackgroundService.eventDetailKey:
              'Cannot send message: WebSocket not connected',
        });
        return;
      }

      await connection.send(message);
    } catch (error, stackTrace) {
      _logWarning(
        'Failed to send message to backend: $error',
        error,
        stackTrace,
      );
      FlutterForegroundTask.sendDataToMain(<String, dynamic>{
        McpBackgroundService.eventTypeKey: McpBackgroundService.eventError,
        McpBackgroundService.eventDetailKey: error.toString(),
      });
    }
  }

  Future<void> _disposeConnection() async {
    await _stateSubscription?.cancel();
    await _errorSubscription?.cancel();
    _stateSubscription = null;
    _errorSubscription = null;
    await _connectionManager?.dispose();
    _connectionManager = null;
    _webSocketUrl = null;
  }

  Future<void> _onBackendMessage(dynamic data) {
    FlutterForegroundTask.sendDataToMain(<String, dynamic>{
      McpBackgroundService.eventTypeKey: McpBackgroundService.eventMessage,
      McpBackgroundService.eventPayloadKey: data,
    });
    return Future.value();
  }

  void _handleConnectionState(McpConnectionState state) {
    switch (state) {
      case McpConnectionState.connected:
        FlutterForegroundTask.sendDataToMain(<String, dynamic>{
          McpBackgroundService.eventTypeKey:
              McpBackgroundService.eventConnected,
        });
        break;
      case McpConnectionState.disconnected:
        FlutterForegroundTask.sendDataToMain(<String, dynamic>{
          McpBackgroundService.eventTypeKey:
              McpBackgroundService.eventDisconnected,
          McpBackgroundService.eventReasonKey: 'Disconnected',
        });
        break;
      case McpConnectionState.connecting:
        break;
    }
  }

  void _handleConnectionError(Object error) {
    final message = error.toString();
    if (message.contains('Max reconnect attempts reached')) {
      unawaited(_disposeConnection());
    }
    FlutterForegroundTask.sendDataToMain(<String, dynamic>{
      McpBackgroundService.eventTypeKey: McpBackgroundService.eventError,
      McpBackgroundService.eventDetailKey: message,
    });
  }
}

void _logInfo(String message) {
  debugPrint('[MCP Service] $message');
}

void _logWarning(String message, [Object? error, StackTrace? stackTrace]) {
  debugPrint('[MCP Service][WARN] $message');
  if (error != null) {
    debugPrint('  error: $error');
  }
  if (stackTrace != null) {
    debugPrint('  stack: $stackTrace');
  }
}

void _logError(Object error, {StackTrace? stackTrace}) {
  debugPrint('[MCP Service][ERROR] $error');
  if (stackTrace != null) {
    debugPrint('  stack: $stackTrace');
  }
}
