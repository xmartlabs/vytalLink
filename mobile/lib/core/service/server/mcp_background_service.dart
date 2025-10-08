import 'dart:async';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_template/core/common/config.dart';
import 'package:flutter_template/core/common/logger.dart';
import 'package:flutter_template/core/service/server/mcp_connection_manager.dart';
import 'package:flutter_template/ui/resources.dart';

const _notificationChannelId = 'vytal_mcp_background_channel';
const _notificationIconMetaData =
    'com.pravera.flutter_foreground_task.notification_icon';
const _closeButtonId = 'close_button';

const Duration _serviceCommandTimeout = Duration(seconds: 5);

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
  static const String eventIdleTimeout = 'idle_timeout';

  static const String eventDisconnectedReasonUser = 'user';
  static const String eventDisconnectedReasonLost = 'lost';

  static bool _initialized = false;
  static bool _permissionsRequested = false;
  static String? _currentCode;
  static String? _currentWord;
  static bool _communicationInitialized = false;
  static final StreamController<Map<String, dynamic>> _eventController =
      StreamController<Map<String, dynamic>>.broadcast();

  static Future<void> ensureServiceStoppedIfStale({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    if (!_isForegroundServiceAvailable()) {
      return;
    }

    try {
      final isRunning = await FlutterForegroundTask.isRunningService;
      if (!isRunning) {
        return;
      }

      Logger.w(
        'Detected stale MCP foreground service on startup; requesting stop',
      );

      try {
        final result = await FlutterForegroundTask.stopService().timeout(
          timeout,
        );
        if (result is ServiceRequestFailure) {
          Logger.w(
            'Foreground service stop request failed',
            result.error,
          );
        }
      } on TimeoutException catch (error, stackTrace) {
        Logger.w(
          'Timed out while stopping stale MCP foreground service',
          error,
          stackTrace,
        );
        return;
      } catch (error, stackTrace) {
        Logger.w(
          'Error while stopping stale MCP foreground service',
          error,
          stackTrace,
        );
      }

      final stillRunning = await FlutterForegroundTask.isRunningService;
      if (stillRunning) {
        Logger.w(
          'Foreground service still reports as running after stop request',
        );
      }
    } catch (error, stackTrace) {
      Logger.w(
        'Unable to verify MCP foreground service state on startup',
        error,
        stackTrace,
      );
    }
  }

  static Future<void> initialize() async {
    if (!_isForegroundServiceAvailable()) {
      return;
    }

    if (_initialized) {
      return;
    }

    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: _notificationChannelId,
        channelName: Resources.localizations.mcp_foreground_channel_name,
        channelDescription:
            Resources.localizations.mcp_foreground_channel_description,
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
    Logger.i('MCP background service initialized');
  }

  static void initializeCommunication() {
    if (!_isForegroundServiceAvailable()) {
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
    if (!_isForegroundServiceAvailable() || _permissionsRequested) {
      return;
    }

    try {
      final status = await FlutterForegroundTask.checkNotificationPermission();
      if (status == NotificationPermission.denied) {
        await FlutterForegroundTask.requestNotificationPermission();
      }
      _permissionsRequested = true;
    } catch (error, stackTrace) {
      Logger.w('Unable to request notification permission', error, stackTrace);
    }
  }

  static Future<void> startOrUpdate({
    String? connectionCode,
    String? connectionWord,
  }) async {
    if (!_isForegroundServiceAvailable()) {
      return;
    }

    await _ensureInitialized();
    _currentCode = connectionCode;
    _currentWord = connectionWord;

    final notificationText = _buildNotificationText(
      code: _currentCode,
      word: _currentWord,
    );

    final isRunning = await FlutterForegroundTask.isRunningService;
    if (isRunning) {
      await _updateRunningService(notificationText);
    } else {
      await _startNewService(notificationText);
    }
  }

  static Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await initialize();
    }
    initializeCommunication();
  }

  static Future<void> _updateRunningService(String notificationText) async {
    final result = await FlutterForegroundTask.updateService(
      notificationTitle:
          Resources.localizations.mcp_foreground_notification_title,
      notificationText: notificationText,
      notificationIcon: const NotificationIcon(
        metaDataName: _notificationIconMetaData,
      ),
      notificationButtons: _buildNotificationButtons(),
    );

    if (result is ServiceRequestFailure) {
      Logger.w(
        'Failed to update MCP foreground service',
        result.error,
      );
    }
  }

  static Future<void> _startNewService(String notificationText) async {
    final result = await FlutterForegroundTask.startService(
      notificationTitle:
          Resources.localizations.mcp_foreground_notification_title,
      notificationText: notificationText,
      notificationIcon: const NotificationIcon(
        metaDataName: _notificationIconMetaData,
      ),
      notificationButtons: _buildNotificationButtons(),
      callback: mcpBackgroundServiceStartCallback,
    );

    if (result is ServiceRequestFailure) {
      Logger.w('Failed to start MCP foreground service', result.error);
    } else {
      Logger.i('MCP foreground service started');
    }
  }

  static List<NotificationButton> _buildNotificationButtons() => [
        NotificationButton(
          id: _closeButtonId,
          text:
              Resources.localizations.mcp_foreground_notification_button_close,
        ),
      ];

  static Future<void> stopService() async {
    if (!_isForegroundServiceAvailable()) {
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

      dynamic result;
      try {
        result = await FlutterForegroundTask.stopService().timeout(
          _serviceCommandTimeout,
        );
      } on TimeoutException catch (error, stackTrace) {
        Logger.w(
          'Timed out while waiting for MCP foreground service to stop',
          error,
          stackTrace,
        );
        return;
      }

      if (result is ServiceRequestFailure) {
        Logger.w('Failed to stop MCP foreground service', result.error);
      } else {
        Logger.i('MCP foreground service stopped');
        _currentCode = null;
        _currentWord = null;
      }

      final stillRunning = await FlutterForegroundTask.isRunningService;
      if (stillRunning) {
        Logger.w(
          'Foreground service still reports as running after stop request',
        );
      }
    } catch (error, stackTrace) {
      Logger.w(
        'Error stopping MCP foreground service',
        error,
        stackTrace,
      );
    }
  }

  static String _buildNotificationText({String? code, String? word}) {
    final resolvedCode = (code?.isNotEmpty ?? false)
        ? code!
        : Resources.localizations.mcp_foreground_status_pending;
    final resolvedWord = (word?.isNotEmpty ?? false)
        ? word!
        : Resources.localizations.mcp_foreground_status_pending;
    return Resources.localizations.mcp_foreground_notification_text(
      resolvedWord,
      resolvedCode,
    );
  }

  static void _onTaskDataReceived(Object data) {
    if (data is! Map) {
      return;
    }

    try {
      final typedData = data.map((key, value) => MapEntry('$key', value));
      _eventController.add(typedData);
    } catch (error, stackTrace) {
      Logger.w('Failed to process foreground task event', error, stackTrace);
    }
  }

  static Future<void> sendCommand(Map<String, dynamic> command) async {
    if (!_isForegroundServiceAvailable()) {
      return;
    }

    try {
      FlutterForegroundTask.sendDataToTask(command);
    } catch (error, stackTrace) {
      Logger.w(
        'Failed to send command to foreground task',
        error,
        stackTrace,
      );
    }
  }
}

@pragma('vm:entry-point')
void mcpBackgroundServiceStartCallback() {
  if (!_isForegroundServiceAvailable()) {
    return;
  }

  FlutterForegroundTask.setTaskHandler(_McpForegroundTaskHandler());
}

class _McpForegroundTaskHandler extends TaskHandler {
  HealthMcpConnectionManager? _connectionManager;
  StreamSubscription<McpConnectionState>? _stateSubscription;
  StreamSubscription<Object>? _errorSubscription;
  String? _webSocketUrl;
  Timer? _idleTimer;
  final Duration _idleTimeout = const Duration(minutes: 15);
  bool _userRequestedClose = false;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    Logger.i('MCP foreground task started by $starter at $timestamp');
    FlutterForegroundTask.sendDataToMain(<String, dynamic>{
      McpBackgroundService.eventTypeKey:
          McpBackgroundService.eventServiceStarted,
    });
  }

  @override
  void onReceiveData(Object data) {
    if (data is! Map) {
      Logger.w('Received unsupported data type from main isolate: $data');
      return;
    }

    final action = data[McpBackgroundService.commandActionKey];
    if (action is! String) {
      Logger.w('Missing action in foreground service command: $data');
      return;
    }

    switch (action) {
      case McpBackgroundService.commandConnect:
        final url = data[McpBackgroundService.commandUrlKey] as String?;
        if (url == null || url.isEmpty) {
          Logger.w('Connect command missing url: $data');
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
          Logger.w('Send command missing message payload');
          return;
        }
        unawaited(_send(message));
        break;

      default:
        Logger.w('Unknown foreground service command: $action');
        break;
    }
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    // No periodic work required; connection retries run in main isolate.
    return;
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    Logger.i(
      'MCP foreground task destroyed at $timestamp (isTimeout=$isTimeout)',
    );
    await _disposeConnection();
  }

  @override
  void onNotificationButtonPressed(String id) {
    if (id == _closeButtonId) {
      Logger.i('User requested to close foreground service from notification');
      _userRequestedClose = true;
      // Notify the main app that the service is being closed
      FlutterForegroundTask.sendDataToMain(<String, dynamic>{
        McpBackgroundService.eventTypeKey:
            McpBackgroundService.eventDisconnected,
        McpBackgroundService.eventReasonKey:
            McpBackgroundService.eventDisconnectedReasonUser,
      });
      unawaited(_disconnect());
      FlutterForegroundTask.stopService();
    }
  }

  Future<void> _connect(String url) async {
    try {
      if (_connectionManager == null || _webSocketUrl != url) {
        await _disposeConnection();
        _connectionManager = HealthMcpConnectionManager(
          backendUrl: Uri.parse(url),
          maxRetries: 2,
          reconnectMaxDelay: const Duration(seconds: 2),
        )..setMessageHandler(_onBackendMessage);
        _webSocketUrl = url;
        _stateSubscription = _connectionManager!.stateStream.listen(
          _handleConnectionState,
        );
        _errorSubscription = _connectionManager!.errorStream.listen(
          _handleConnectionError,
        );
      }

      await _connectionManager!.connect();
    } catch (error, stackTrace) {
      Logger.e(
        'Failed to connect to backend from foreground task',
        error,
        stackTrace,
      );
      FlutterForegroundTask.sendDataToMain(<String, dynamic>{
        McpBackgroundService.eventTypeKey: McpBackgroundService.eventError,
        McpBackgroundService.eventDetailKey: error.toString(),
      });
    }
  }

  Future<void> _disconnect() async {
    try {
      await _connectionManager?.disconnect();
    } catch (error, stackTrace) {
      Logger.w(
        'Error while disconnecting MCP WebSocket from foreground task',
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
      Logger.w(
        'Failed to send message to backend from foreground task',
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
    _cancelIdleTimer();
    await _stateSubscription?.cancel();
    await _errorSubscription?.cancel();
    _stateSubscription = null;
    _errorSubscription = null;
    await _connectionManager?.dispose();
    _connectionManager = null;
    _webSocketUrl = null;
  }

  Future<void> _onBackendMessage(dynamic data) {
    _resetIdleTimer();
    FlutterForegroundTask.sendDataToMain(<String, dynamic>{
      McpBackgroundService.eventTypeKey: McpBackgroundService.eventMessage,
      McpBackgroundService.eventPayloadKey: data,
    });
    return Future.value();
  }

  void _handleConnectionState(McpConnectionState state) {
    switch (state) {
      case McpConnectionState.connected:
        _resetIdleTimer();
        FlutterForegroundTask.sendDataToMain(<String, dynamic>{
          McpBackgroundService.eventTypeKey:
              McpBackgroundService.eventConnected,
        });
        break;
      case McpConnectionState.disconnected:
        _cancelIdleTimer();
        if (!_userRequestedClose) {
          FlutterForegroundTask.sendDataToMain(<String, dynamic>{
            McpBackgroundService.eventTypeKey:
                McpBackgroundService.eventDisconnected,
            McpBackgroundService.eventReasonKey:
                McpBackgroundService.eventDisconnectedReasonLost,
          });
        }
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

  void _resetIdleTimer() {
    _cancelIdleTimer();
    _idleTimer = Timer(_idleTimeout, _onIdleTimeout);
  }

  void _cancelIdleTimer() {
    _idleTimer?.cancel();
    _idleTimer = null;
  }

  void _onIdleTimeout() {
    FlutterForegroundTask.sendDataToMain(<String, dynamic>{
      McpBackgroundService.eventTypeKey: McpBackgroundService.eventIdleTimeout,
    });
    unawaited(_disposeConnection());
    FlutterForegroundTask.stopService();
  }
}

bool _isForegroundServiceAvailable() => Config.useForegroundService;
