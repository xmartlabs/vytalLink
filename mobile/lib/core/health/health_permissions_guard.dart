import 'dart:io';

import 'package:flutter_template/core/source/mcp_server.dart';
import 'package:health/health.dart';

class HealthPermissionsGuard {
  const HealthPermissionsGuard();

  Future<void> ensurePermissions(
    Health healthClient,
    List<HealthDataType> healthTypes,
  ) async {
    if (Platform.isAndroid) {
      await _checkHealthConnectAvailability(healthClient);
    }

    final hasPermissions = await healthClient.hasPermissions(
          healthTypes,
          permissions: healthTypes.map((_) => HealthDataAccess.READ).toList(),
        ) ??
        false;

    if (!hasPermissions) {
      await _requestHealthPermissions(healthClient, healthTypes);
    }

    await _ensureHistoryAuthorizationIfNeeded(healthClient);
  }

  Future<void> _checkHealthConnectAvailability(Health healthClient) async {
    final isAvailable = await healthClient.isHealthConnectAvailable();

    if (!isAvailable) {
      throw const HealthDataUnavailableException(
        'Google Health Connect is not available on this device. '
        'Please install it from the Play Store.',
      );
    }
  }

  Future<void> _requestHealthPermissions(
    Health healthClient,
    List<HealthDataType> healthTypes,
  ) async {
    final permissionsGranted = await healthClient.requestAuthorization(
      healthTypes,
      permissions: healthTypes.map((_) => HealthDataAccess.READ).toList(),
    );

    if (!permissionsGranted) {
      throw const HealthPermissionException(
        'Health permissions not granted. '
        'Please open Health Connect app and grant permissions manually.',
      );
    }
  }

  Future<void> _ensureHistoryAuthorizationIfNeeded(Health healthClient) async {
    final isAuthorized = await healthClient.isHealthDataHistoryAuthorized();

    if (!isAuthorized) {
      await healthClient.requestHealthDataHistoryAuthorization();
    }
  }
}
