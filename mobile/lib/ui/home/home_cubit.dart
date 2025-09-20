import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/core/common/config.dart';
import 'package:flutter_template/core/health_permission_manager.dart';
import 'package:flutter_template/core/source/mcp_server.dart';
import 'package:flutter_template/core/service/mcp_background_service.dart';
import 'package:flutter_template/ui/resources.dart';
import 'package:flutter_template/ui/section/error_handler/global_event_handler_cubit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GlobalEventHandler _globalEventHandler;
  late final HealthMcpServerService healthServer;
  late final HealthPermissionManager healthPermissionManager;
  Timer? _connectionCheckTimer;
  Timer? _reconnectTimeoutTimer;
  AppLifecycleListener? _appLifecycleListener;

  HomeCubit(this._globalEventHandler) : super(const HomeState()) {
    WakelockPlus.enable();
    _initialize();
    _appLifecycleListener = AppLifecycleListener(
      onStateChange: _onAppLifecycleStateChanged,
    );
  }

  Future<void> _initialize() async {
    final ip = await NetworkInfo().getWifiIP();

    final config = HealthMcpServerConfig(
      serverName: Config.mcpServerName,
      serverVersion: Config.mcpServerVersion,
      host: ip ?? Config.mcpHostFallback,
      port: Config.mcpPort,
      endpoint: Config.mcpEndpoint,
    );

    healthServer = HealthMcpServerService(config: config)
      ..setConnectionCodeCallback(_onConnectionCodeReceived)
      ..setConnectionErrorCallback(_onConnectionError)
      ..setConnectionLostCallback(_onConnectionLost)
      ..setConnectionEstablishedCallback(_onConnectionEstablished)
      ..setServiceStoppedCallback(_onServiceStoppedByIdle);
    healthPermissionManager = HealthPermissionManager();
  }

  @override
  Future<void> close() async {
    await WakelockPlus.disable();
    _connectionCheckTimer?.cancel();
    _appLifecycleListener?.dispose();
    await McpBackgroundService.stopService();
    await healthServer.dispose();
    await super.close();
  }

  void _startConnectionMonitoring() {
    _connectionCheckTimer?.cancel();
    _connectionCheckTimer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) => _checkConnectionStatus(),
    );
  }

  void _stopConnectionMonitoring() {
    _connectionCheckTimer?.cancel();
  }

  void _checkConnectionStatus() {
    if (state.status == McpServerStatus.running && !healthServer.isConnected) {
      _enterReconnectingState();
    }
  }

  void _onConnectionCodeReceived(String code, String word, String message) {
    emit(
      state.copyWith(
        status: McpServerStatus.running,
        ipAddress: healthServer.config.host,
        endpoint: healthServer.config.endpoint,
        connectionCode: code,
        connectionWord: word,
        errorMessage: "",
      ),
    );
    unawaited(
      McpBackgroundService.startOrUpdate(
        connectionCode: code,
        connectionWord: word,
      ),
    );
  }

  void _onConnectionError(String error) {
    _stopConnectionMonitoring();
    _globalEventHandler.handleError(
      CategorizedError(
        ErrorCategory.connection,
        Resources.localizations.connection_error_title,
      ),
      null,
      () => startMCPServer(),
    );
    emit(
      state.copyWith(
        status: McpServerStatus.error,
        ipAddress: "",
        endpoint: "",
        connectionCode: "",
        connectionWord: "",
        errorMessage: "",
      ),
    );
  }

  void _onConnectionLost() => _enterReconnectingState();

  void _onConnectionEstablished() {
    _cancelReconnectTimeout();
    
    _startConnectionMonitoring();
    if (McpBackgroundService.isForegroundServiceAvailable) {
      unawaited(
        McpBackgroundService.startOrUpdate(
          connectionCode: state.connectionCode,
          connectionWord: state.connectionWord,
        ),
      );
    }
  }

  Future<bool> hasAllHealthPermissions() =>
      healthPermissionManager.hasAllHealthPermissions();

  Future<bool> requestHealthPermissions() =>
      healthPermissionManager.requestHealthPermissions();

  Future<bool> isHealthConnectInstallationRequired() async =>
      !await healthPermissionManager.isHealthConnectAvailable();

  Future<void> installHealthConnect() =>
      healthPermissionManager.installHealthConnect();

  Future<void> startMCPServer() async {
    try {
      _globalEventHandler.clearError();
      emit(
        state.copyWith(
          status: McpServerStatus.starting,
          errorMessage: "",
        ),
      );

      final hasPermissions = await hasAllHealthPermissions();
      if (!hasPermissions) {
        emit(
          state.copyWith(
            status: McpServerStatus.idle,
            errorMessage: "",
          ),
        );
        return;
      }

      await McpBackgroundService.ensureNotificationPermission();
      await healthServer.connectToBackend();

      if (!healthServer.isConnected) {
        throw CategorizedError(
          ErrorCategory.connection,
          Resources.localizations.connection_could_not_establish,
        );
      }

      _startConnectionMonitoring();
      unawaited(McpBackgroundService.startOrUpdate());
    } catch (error) {
      emit(
        state.copyWith(
          status: McpServerStatus.error,
          errorMessage: "",
        ),
      );
    }
  }

  Future<bool> checkAndStartServer() async {
    final hasPermissions = await hasAllHealthPermissions();
    if (hasPermissions) {
      await startMCPServerWithPermissions();
      return true;
    } else {
      final permissionsGranted = await requestHealthPermissions();
      if (permissionsGranted) {
        await startMCPServerWithPermissions();
        return true;
      } else {
        return false;
      }
    }
  }

  Future<void> startMCPServerWithPermissions() async {
    try {
      _globalEventHandler.clearError();
      emit(
        state.copyWith(
          status: McpServerStatus.starting,
          errorMessage: "",
        ),
      );

      await McpBackgroundService.ensureNotificationPermission();
      await healthServer.connectToBackend();

      if (!healthServer.isConnected) {
        throw CategorizedError(
          ErrorCategory.connection,
          Resources.localizations.connection_could_not_establish,
        );
      }

      _startConnectionMonitoring();
      unawaited(McpBackgroundService.startOrUpdate());
    } catch (error) {
      emit(
        state.copyWith(
          status: McpServerStatus.error,
          errorMessage: "",
        ),
      );
    }
  }

  void _onAppLifecycleStateChanged(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_handleAppResumed());
      return;
    }

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      unawaited(_handleAppBackgrounded());
    }
  }

  Future<void> _handleAppBackgrounded() async {
    if (McpBackgroundService.isForegroundServiceAvailable) {
      await McpBackgroundService.startOrUpdate(
        connectionCode: state.connectionCode,
        connectionWord: state.connectionWord,
      );
    }
  }

  Future<void> _handleAppResumed() async {
    if (state.status != McpServerStatus.running) return;
    if (McpBackgroundService.isForegroundServiceAvailable) {
      await McpBackgroundService.startOrUpdate(
        connectionCode: state.connectionCode,
        connectionWord: state.connectionWord,
      );
      return;
    }
  }

  Future<void> stopMCPServer() async {
    try {
      emit(state.copyWith(status: McpServerStatus.stopping));

      _stopConnectionMonitoring();
      _cancelReconnectTimeout();
      await McpBackgroundService.stopService();
      await healthServer.stop();

      emit(
        state.copyWith(
          status: McpServerStatus.idle,
          ipAddress: "",
          endpoint: "",
          connectionCode: "",
          connectionWord: "",
          errorMessage: "",
        ),
      );
    } catch (error, stackTrace) {
      _globalEventHandler.handleError(error, stackTrace);
      emit(
        state.copyWith(
          status: McpServerStatus.idle,
          ipAddress: "",
          endpoint: "",
          connectionCode: "",
          connectionWord: "",
          errorMessage: "",
        ),
      );
    }
  }

  void _onServiceStoppedByIdle() {
    _stopConnectionMonitoring();
    emit(
      state.copyWith(
        status: McpServerStatus.idle,
        ipAddress: "",
        endpoint: "",
        connectionCode: "",
        connectionWord: "",
        errorMessage: "",
      ),
    );
  }

  void _enterReconnectingState() {
    if (state.status != McpServerStatus.running) return;
    emit(
      state.copyWith(
        status: McpServerStatus.reconnecting,
        ipAddress: "",
        endpoint: "",
        errorMessage: "",
      ),
    );
    _startReconnectTimeout();
  }

  void _startReconnectTimeout() {
    _cancelReconnectTimeout();
    _reconnectTimeoutTimer = Timer(const Duration(seconds: 6), () {
      emit(
        state.copyWith(
          status: McpServerStatus.error,
          ipAddress: "",
          endpoint: "",
          connectionCode: "",
          connectionWord: "",
          errorMessage: "",
        ),
      );
    });
  }

  void _cancelReconnectTimeout() {
    _reconnectTimeoutTimer?.cancel();
    _reconnectTimeoutTimer = null;
  }
}
