import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/core/common/analytics_manager.dart';
import 'package:flutter_template/core/health_permission_manager.dart';
import 'package:flutter_template/core/source/mcp_server.dart';
import 'package:flutter_template/ui/resources.dart';
import 'package:flutter_template/ui/section/error_handler/global_event_handler_cubit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GlobalEventHandler _globalEventHandler;
  late final HealthMcpServerService healthServer;
  late final HealthPermissionManager healthPermissionManager;

  Timer? _connectionCheckTimer;
  StreamSubscription<McpConnectionState>? _connectionEventsSubscription;

  HomeCubit(this._globalEventHandler) : super(const HomeState()) {
    WakelockPlus.enable();
    _initialize();
  }

  void _initialize() {
    healthServer = HealthMcpServerService();
    _connectionEventsSubscription =
        healthServer.status.listen(_handleConnectionState);
    healthPermissionManager = HealthPermissionManager();
  }

  @override
  Future<void> close() {
    WakelockPlus.disable();
    _connectionCheckTimer?.cancel();
    _connectionEventsSubscription?.cancel();
    return super.close();
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
      emit(
        HomeState(
          status: McpServerStatus.error,
          errorMessage: Resources.localizations.connection_lost_unexpectedly,
        ),
      );
    }
  }

  void _handleConnectionState(McpConnectionState state) => state.when(
        connecting: _onConnecting,
        connected: _onConnected,
        disconnected: _onDisconnected,
      );

  void _onConnecting() {
    emit(
      state.copyWith(
        status: McpServerStatus.starting,
      ),
    );
  }

  void _onConnected(BridgeCredentials credentials, String message) {
    emit(
      state.copyWith(
        bridgeCredentials: credentials,
        status: McpServerStatus.running,
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
        bridgeCredentials: null,
        errorMessage: "",
      ),
    );
  }

  void _onDisconnected(String? errorMessage, bool lostConnection) {
    if (errorMessage != null && errorMessage.isNotEmpty) {
      _onConnectionError(errorMessage);
    } else {
      _stopConnectionMonitoring();
      emit(
        state.copyWith(
          status: McpServerStatus.idle,
          bridgeCredentials: null,
          errorMessage: null,
        ),
      );
    }
  }

  Future<bool> hasAllHealthPermissions() =>
      healthPermissionManager.hasAllHealthPermissions();

  Future<bool> requestHealthPermissions() =>
      _requestHealthPermissionsWithTracking();

  Future<bool> _requestHealthPermissionsWithTracking() async {
    AnalyticsManager.logHealthPermissionsRequested();
    final permissionsGranted =
        await healthPermissionManager.requestHealthPermissions();
    AnalyticsManager.logHealthPermissionsResult(granted: permissionsGranted);
    return permissionsGranted;
  }

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

      await healthServer.connectToBackend();

      if (!healthServer.isConnected) {
        throw CategorizedError(
          ErrorCategory.connection,
          Resources.localizations.connection_could_not_establish,
        );
      }

      emit(
        state.copyWith(
          status: McpServerStatus.running,
          errorMessage: "",
        ),
      );

      _startConnectionMonitoring();
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
    if (state.isRunning) {
      return true;
    }

    final hasPermissions = await hasAllHealthPermissions();
    if (hasPermissions) {
      await _startMCPServerWithPermissions();
      return true;
    }

    final permissionsGranted = await requestHealthPermissions();
    if (!permissionsGranted) {
      return false;
    }

    await _startMCPServerWithPermissions();
    return true;
  }

  Future<McpConnectionState> _startMCPServerWithPermissions() async {
    try {
      _globalEventHandler.clearError();
      emit(
        state.copyWith(
          status: McpServerStatus.starting,
          errorMessage: null,
        ),
      );

      await healthServer.connectToBackend();
      if (!healthServer.isConnected) {
        throw CategorizedError(
          ErrorCategory.connection,
          Resources.localizations.connection_could_not_establish,
        );
      }

      emit(
        state.copyWith(
          status: McpServerStatus.running,
          errorMessage: null,
        ),
      );

      _startConnectionMonitoring();
    } catch (error) {
      emit(
        state.copyWith(
          status: McpServerStatus.error,
          errorMessage: "",
        ),
      );
    }
    return healthServer.currentStatus;
  }

  Future<void> stopMCPServer() async {
    try {
      emit(state.copyWith(status: McpServerStatus.stopping));

      _stopConnectionMonitoring();
      await healthServer.stop();

      emit(const HomeState(status: McpServerStatus.idle));
    } catch (error, stackTrace) {
      _globalEventHandler.handleError(error, stackTrace);
      emit(const HomeState(status: McpServerStatus.idle));
    }
  }
}
