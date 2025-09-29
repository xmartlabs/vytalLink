import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_template/core/common/config.dart';
import 'package:flutter_template/core/common/logger.dart';
import 'package:flutter_template/core/model/health_data_request.dart';
import 'package:flutter_template/core/model/health_data_response.dart';

abstract interface class AnalyticsManager {
  static final AnalyticsService _service = _FirebaseAnalyticsService();

  static Future<void> setCollectionEnabled(bool enabled) async {
    try {
      await _service.setCollectionEnabled(enabled);
    } catch (error, stackTrace) {
      Logger.w(
        'Failed to update analytics collection state: $error',
        error,
        stackTrace,
      );
    }
  }

  static Future<void> logScreenView(String screenName) async {
    if (!_shouldLogEvents) {
      return;
    }

    try {
      await _service.logScreenView(screenName);
    } catch (error, stackTrace) {
      Logger.w(
        'Failed to log screen view for $screenName: $error',
        error,
        stackTrace,
      );
    }
  }

  static void logHealthDataRequest(HealthDataRequest request) => _logEvent(
        _AnalyticsEvent.healthDataRequest,
        {
          'value_type': request.valueType,
          'start_time': request.startTime.toIso8601String(),
          'end_time': request.endTime.toIso8601String(),
          'group_by': request.groupBy,
          'statistic': request.statistic,
        },
      ).ignore();

  static void logHealthDataResponse(
    HealthDataResponse response,
  ) =>
      _logEvent(
        _AnalyticsEvent.healthDataResponse,
        {
          'value_type': response.valueType,
          'count': response.count,
          'is_aggregated': response.isAggregated,
          'group_by': response.groupBy,
          'statistic': response.statisticType,
        },
      ).ignore();

  static void logHealthDataError({
    required String valueType,
    required String errorType,
    required String errorMessage,
  }) =>
      _logEvent(
        _AnalyticsEvent.healthDataError,
        {
          'value_type': valueType,
          'error_type': errorType,
          'error_message': errorMessage,
        },
      ).ignore();

  static void logMcpConnectionStarted() =>
      _logEvent(_AnalyticsEvent.mcpConnectionStarted).ignore();

  static void logMcpConnectionError({required String errorMessage}) =>
      _logEvent(
        _AnalyticsEvent.mcpConnectionError,
        {
          'error_message': errorMessage,
        },
      ).ignore();

  static void logMcpConnectionLost() =>
      _logEvent(_AnalyticsEvent.mcpConnectionLost).ignore();

  static void logHealthPermissionsRequested() =>
      _logEvent(_AnalyticsEvent.healthPermissionsRequested).ignore();

  static void logHealthPermissionsResult({
    required bool granted,
  }) =>
      _logEvent(
        _AnalyticsEvent.healthPermissionsResult,
        {
          'granted': granted,
        },
      ).ignore();

  static bool get _shouldLogEvents => !Config.testingMode;

  static Future<void> _logEvent(
    _AnalyticsEvent event, [
    Map<String, Object?> parameters = const {},
  ]) async {
    if (!_shouldLogEvents) {
      return;
    }

    final sanitizedParameters = Map.fromEntries(
      parameters.entries.where((e) => e.value != null)
          as Iterable<MapEntry<String, Object>>,
    );
    try {
      await _service.logEvent(event.analyticsName, sanitizedParameters);
    } catch (error, stackTrace) {
      Logger.w(
        'Failed to log ${event.analyticsName} analytics event: $error',
        error,
        stackTrace,
      );
    }
  }
}

abstract interface class AnalyticsService {
  Future<void> setCollectionEnabled(bool enabled);

  Future<void> logScreenView(String screenName);

  Future<void> logEvent(String name, Map<String, Object> parameters);
}

enum _AnalyticsEvent {
  healthDataRequest('health_data_request'),
  healthDataResponse('health_data_response'),
  healthDataError('health_data_error'),
  mcpConnectionStarted('mcp_connection_started'),
  mcpConnectionError('mcp_connection_error'),
  mcpConnectionLost('mcp_connection_lost'),
  healthPermissionsRequested('health_permissions_requested'),
  healthPermissionsResult('health_permissions_result');

  const _AnalyticsEvent(this.analyticsName);

  final String analyticsName;
}

class _FirebaseAnalyticsService implements AnalyticsService {
  _FirebaseAnalyticsService() : _analytics = FirebaseAnalytics.instance;

  final FirebaseAnalytics _analytics;

  @override
  Future<void> setCollectionEnabled(bool enabled) =>
      _analytics.setAnalyticsCollectionEnabled(enabled);

  @override
  Future<void> logScreenView(String screenName) =>
      _analytics.logScreenView(screenName: screenName);

  @override
  Future<void> logEvent(String name, Map<String, Object> parameters) =>
      _analytics.logEvent(
        name: name,
        parameters: parameters,
      );
}
