import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:flutter_template/core/common/logger.dart';
import 'package:flutter_template/model/vytal_health_data_category.dart';
import 'package:health/health.dart';

class HealthPermissionManager {
  final Health _healthClient;
  late List<HealthDataType> _requiredHealthDataTypes;
  bool _isInitialized = false;

  HealthPermissionManager({Health? healthClient})
      : _healthClient = healthClient ?? Health() {
    _requiredHealthDataTypes = VytalHealthDataCategory.values
        .flatMap((category) => category.platformHealthDataTypes)
        .distinct()
        .toList();
  }

  Future<void> _ensureInitialized() async {
    if (_isInitialized) return;

    try {
      await _healthClient.configure();
      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
    }
  }

  Future<bool> hasAllHealthPermissions() async {
    try {
      await _ensureInitialized();
      final hasPermissions =
          await _healthClient.hasPermissions(_requiredHealthDataTypes);
      final hasHistoryPermissions =
          await _healthClient.isHealthDataHistoryAuthorized();
      return (hasPermissions ?? false) && hasHistoryPermissions;
    } catch (error) {
      return false;
    }
  }

  Future<bool> requestHealthPermissions() async {
    try {
      await _ensureInitialized();
      final permissions = List.generate(
        _requiredHealthDataTypes.length,
        (_) => HealthDataAccess.READ,
      );
      final permissionsGranted = await _healthClient.requestAuthorization(
        _requiredHealthDataTypes,
        permissions: permissions,
      );
      if (!permissionsGranted) {
        return false;
      }
      try {
        await _healthClient.requestHealthDataHistoryAuthorization();
        final hasHistoryPermissions = Platform.isIOS ||
            await _healthClient.isHealthDataHistoryAuthorized();
        if (!hasHistoryPermissions) {
          return false;
        }
      } catch (historyError) {
        return false;
      }
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> isHealthConnectAvailable() async {
    try {
      await _ensureInitialized();
      return await _healthClient.isHealthConnectAvailable();
    } catch (error, stackTrace) {
      Logger.w(
        'Failed to determine Health Connect availability',
        error,
        stackTrace,
      );
      return false;
    }
  }

  Future<void> installHealthConnect() async {
    try {
      await _healthClient.installHealthConnect();
    } catch (error, stackTrace) {
      Logger.w(
        'Failed to launch Health Connect installation flow',
        error,
        stackTrace,
      );
    }
  }
}
