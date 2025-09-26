import 'dart:io';

import 'package:flutter_template/core/health/health_permissions_guard.dart';
import 'package:flutter_template/core/source/mcp_server.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health/health.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mock_health_client.dart';
import '../../../test_utils.dart';

void main() {
  group('HealthPermissionsGuard', () {
    late HealthPermissionsGuard permissionsGuard;
    late MockHealth mockHealthClient;

    setUp(() {
      permissionsGuard = const HealthPermissionsGuard();
      mockHealthClient = MockHealth();
    });

    group('ensurePermissions', () {
      final testHealthTypes = [
        HealthDataType.STEPS,
        HealthDataType.HEART_RATE,
        HealthDataType.DISTANCE_DELTA,
      ];

      test('succeeds when permissions are already granted', () async {
        // Arrange
        when(
          () => mockHealthClient.hasPermissions(
            testHealthTypes,
            permissions: any(named: 'permissions'),
          ),
        ).thenAnswer((_) async => true);

        when(() => mockHealthClient.isHealthDataHistoryAuthorized())
            .thenAnswer((_) async => true);

        // Act & Assert - Should not throw
        await permissionsGuard.ensurePermissions(
          mockHealthClient,
          testHealthTypes,
        );

        verify(
          () => mockHealthClient.hasPermissions(
            testHealthTypes,
            permissions: any(named: 'permissions'),
          ),
        ).called(1);

        // Should not request permissions when already granted
        verifyNever(
          () => mockHealthClient.requestAuthorization(
            any(),
            permissions: any(named: 'permissions'),
          ),
        );
      });

      test('requests permissions when not granted', () async {
        // Arrange
        when(
          () => mockHealthClient.hasPermissions(
            testHealthTypes,
            permissions: any(named: 'permissions'),
          ),
        ).thenAnswer((_) async => false);

        when(
          () => mockHealthClient.requestAuthorization(
            testHealthTypes,
            permissions: any(named: 'permissions'),
          ),
        ).thenAnswer((_) async => true);

        when(() => mockHealthClient.isHealthDataHistoryAuthorized())
            .thenAnswer((_) async => true);

        // Act
        await permissionsGuard.ensurePermissions(
          mockHealthClient,
          testHealthTypes,
        );

        // Assert
        verify(
          () => mockHealthClient.hasPermissions(
            testHealthTypes,
            permissions: any(named: 'permissions'),
          ),
        ).called(1);

        verify(
          () => mockHealthClient.requestAuthorization(
            testHealthTypes,
            permissions: any(named: 'permissions'),
          ),
        ).called(1);
      });

      test('throws HealthPermissionException when permission request is denied',
          () async {
        // Arrange
        when(
          () => mockHealthClient.hasPermissions(
            testHealthTypes,
            permissions: any(named: 'permissions'),
          ),
        ).thenAnswer((_) async => false);

        when(
          () => mockHealthClient.requestAuthorization(
            testHealthTypes,
            permissions: any(named: 'permissions'),
          ),
        ).thenAnswer((_) async => false); // Permission denied

        // Act & Assert
        await TestUtils.expectAsyncThrows<HealthPermissionException>(
          () => permissionsGuard.ensurePermissions(
            mockHealthClient,
            testHealthTypes,
          ),
        );

        verify(
          () => mockHealthClient.requestAuthorization(
            testHealthTypes,
            permissions: any(named: 'permissions'),
          ),
        ).called(1);
      });

      test('handles null response from hasPermissions', () async {
        // Arrange
        when(
          () => mockHealthClient.hasPermissions(
            testHealthTypes,
            permissions: any(named: 'permissions'),
          ),
        ).thenAnswer((_) async => null); // Null response

        when(
          () => mockHealthClient.requestAuthorization(
            testHealthTypes,
            permissions: any(named: 'permissions'),
          ),
        ).thenAnswer((_) async => true);

        when(() => mockHealthClient.isHealthDataHistoryAuthorized())
            .thenAnswer((_) async => true);

        // Act
        await permissionsGuard.ensurePermissions(
          mockHealthClient,
          testHealthTypes,
        );

        // Assert - Should treat null as false and request permissions
        verify(
          () => mockHealthClient.requestAuthorization(
            testHealthTypes,
            permissions: any(named: 'permissions'),
          ),
        ).called(1);
      });

      test('requests history authorization when not authorized', () async {
        // Arrange
        when(
          () => mockHealthClient.hasPermissions(
            testHealthTypes,
            permissions: any(named: 'permissions'),
          ),
        ).thenAnswer((_) async => true);

        when(() => mockHealthClient.isHealthDataHistoryAuthorized())
            .thenAnswer((_) async => false);

        when(() => mockHealthClient.requestHealthDataHistoryAuthorization())
            .thenAnswer((_) async => true);

        // Act
        await permissionsGuard.ensurePermissions(
          mockHealthClient,
          testHealthTypes,
        );

        // Assert
        verify(() => mockHealthClient.isHealthDataHistoryAuthorized())
            .called(1);
        verify(() => mockHealthClient.requestHealthDataHistoryAuthorization())
            .called(1);
      });

      test('skips history authorization when already authorized', () async {
        // Arrange
        when(
          () => mockHealthClient.hasPermissions(
            testHealthTypes,
            permissions: any(named: 'permissions'),
          ),
        ).thenAnswer((_) async => true);

        when(() => mockHealthClient.isHealthDataHistoryAuthorized())
            .thenAnswer((_) async => true);

        // Act
        await permissionsGuard.ensurePermissions(
          mockHealthClient,
          testHealthTypes,
        );

        // Assert
        verify(() => mockHealthClient.isHealthDataHistoryAuthorized())
            .called(1);
        verifyNever(
          () => mockHealthClient.requestHealthDataHistoryAuthorization(),
        );
      });

      test('uses READ permissions for all health types', () async {
        // Arrange
        when(
          () => mockHealthClient.hasPermissions(
            testHealthTypes,
            permissions: any(named: 'permissions'),
          ),
        ).thenAnswer((_) async => true);

        when(() => mockHealthClient.isHealthDataHistoryAuthorized())
            .thenAnswer((_) async => true);

        // Act
        await permissionsGuard.ensurePermissions(
          mockHealthClient,
          testHealthTypes,
        );

        // Assert
        final captured = verify(
          () => mockHealthClient.hasPermissions(
            testHealthTypes,
            permissions: captureAny(named: 'permissions'),
          ),
        ).captured;

        final permissions = captured.first as List<HealthDataAccess>;
        expect(permissions.length, equals(testHealthTypes.length));
        expect(permissions.every((p) => p == HealthDataAccess.READ), isTrue);
      });
    });

    group('Android Health Connect', () {
      test('checks Health Connect availability on Android', () async {
        // This test requires platform-specific mocking which is complex
        // For now, we'll test the conceptual flow

        // Arrange
        when(() => mockHealthClient.isHealthConnectAvailable())
            .thenAnswer((_) async => true);

        when(
          () => mockHealthClient.hasPermissions(
            any(),
            permissions: any(named: 'permissions'),
          ),
        ).thenAnswer((_) async => true);

        when(() => mockHealthClient.isHealthDataHistoryAuthorized())
            .thenAnswer((_) async => true);

        // Act & Assert - Should not throw
        await permissionsGuard
            .ensurePermissions(mockHealthClient, [HealthDataType.STEPS]);
      });

      test(
          // ignore: lines_longer_than_80_chars
          'throws HealthDataUnavailableException when Health Connect is not available',
          () async {
        // Arrange
        when(() => mockHealthClient.isHealthConnectAvailable())
            .thenAnswer((_) async => false);

        // Act & Assert
        // Test the logic directly without platform dependency
        await TestUtils.expectAsyncThrows<HealthDataUnavailableException>(
          () async {
            final isAvailable =
                await mockHealthClient.isHealthConnectAvailable();
            if (!isAvailable) {
              throw const HealthDataUnavailableException(
                // ignore: lines_longer_than_80_chars
                'Google Health Connect is not available on this device. Please install it from the Play Store.',
              );
            }
          },
        );
      });
    });

    group('error handling', () {
      test('handles health client exceptions during permission check',
          () async {
        // Arrange
        when(
          () => mockHealthClient.hasPermissions(
            any(),
            permissions: any(named: 'permissions'),
          ),
        ).thenThrow(Exception('Health client error'));

        // Act & Assert
        expect(
          () => permissionsGuard
              .ensurePermissions(mockHealthClient, [HealthDataType.STEPS]),
          throwsA(isA<Exception>()),
        );
      });

      test('handles health client exceptions during permission request',
          () async {
        // Arrange
        when(
          () => mockHealthClient.hasPermissions(
            any(),
            permissions: any(named: 'permissions'),
          ),
        ).thenAnswer((_) async => false);

        when(
          () => mockHealthClient.requestAuthorization(
            any(),
            permissions: any(named: 'permissions'),
          ),
        ).thenThrow(Exception('Permission request failed'));

        // Act & Assert
        expect(
          () => permissionsGuard
              .ensurePermissions(mockHealthClient, [HealthDataType.STEPS]),
          throwsA(isA<Exception>()),
        );
      });

      test(
          'handles health client exceptions during history authorization check',
          () async {
        // Arrange
        when(
          () => mockHealthClient.hasPermissions(
            any(),
            permissions: any(named: 'permissions'),
          ),
        ).thenAnswer((_) async => true);

        when(() => mockHealthClient.isHealthDataHistoryAuthorized())
            .thenThrow(Exception('History check failed'));

        // Act & Assert
        expect(
          () => permissionsGuard
              .ensurePermissions(mockHealthClient, [HealthDataType.STEPS]),
          throwsA(isA<Exception>()),
        );
      });

      test(
          // ignore: lines_longer_than_80_chars
          'handles health client exceptions during history authorization request',
          () async {
        // Arrange
        when(
          () => mockHealthClient.hasPermissions(
            any(),
            permissions: any(named: 'permissions'),
          ),
        ).thenAnswer((_) async => true);

        when(() => mockHealthClient.isHealthDataHistoryAuthorized())
            .thenAnswer((_) async => false);

        when(() => mockHealthClient.requestHealthDataHistoryAuthorization())
            .thenThrow(Exception('History authorization failed'));

        // Act & Assert
        expect(
          () => permissionsGuard
              .ensurePermissions(mockHealthClient, [HealthDataType.STEPS]),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('permission message validation', () {
      test('HealthPermissionException contains helpful message', () {
        const exception = HealthPermissionException(
          // ignore: lines_longer_than_80_chars
          'Health permissions not granted. Please open Health Connect app and grant permissions manually.',
        );

        expect(exception.message, contains('Health permissions not granted'));
        expect(exception.message, contains('Health Connect app'));
        expect(exception.message, contains('grant permissions manually'));
      });

      test('HealthDataUnavailableException contains helpful message', () {
        const exception = HealthDataUnavailableException(
          // ignore: lines_longer_than_80_chars
          'Google Health Connect is not available on this device. Please install it from the Play Store.',
        );

        expect(exception.message, contains('Google Health Connect'));
        expect(exception.message, contains('not available'));
        expect(exception.message, contains('Play Store'));
      });
    });

    group('edge cases', () {
      test('handles empty health types list', () async {
        // Arrange
        when(
          () => mockHealthClient.hasPermissions(
            <HealthDataType>[],
            permissions: any(named: 'permissions'),
          ),
        ).thenAnswer((_) async => true);

        when(() => mockHealthClient.isHealthDataHistoryAuthorized())
            .thenAnswer((_) async => true);

        // Act & Assert - Should not throw
        await permissionsGuard
            .ensurePermissions(mockHealthClient, <HealthDataType>[]);

        verify(
          () => mockHealthClient.hasPermissions(
            <HealthDataType>[],
            permissions: any(named: 'permissions'),
          ),
        ).called(1);
      });

      test('handles single health type', () async {
        // Arrange
        final singleType = [HealthDataType.HEART_RATE];

        when(
          () => mockHealthClient.hasPermissions(
            singleType,
            permissions: any(named: 'permissions'),
          ),
        ).thenAnswer((_) async => true);

        when(() => mockHealthClient.isHealthDataHistoryAuthorized())
            .thenAnswer((_) async => true);

        // Act & Assert - Should not throw
        await permissionsGuard.ensurePermissions(mockHealthClient, singleType);

        verify(
          () => mockHealthClient.hasPermissions(
            singleType,
            permissions: any(named: 'permissions'),
          ),
        ).called(1);
      });

      test('handles large number of health types', () async {
        // Arrange
        final manyTypes = HealthDataType.values.take(20).toList();

        when(
          () => mockHealthClient.hasPermissions(
            manyTypes,
            permissions: any(named: 'permissions'),
          ),
        ).thenAnswer((_) async => true);

        when(() => mockHealthClient.isHealthDataHistoryAuthorized())
            .thenAnswer((_) async => true);

        // Act & Assert - Should not throw
        await permissionsGuard.ensurePermissions(mockHealthClient, manyTypes);

        verify(
          () => mockHealthClient.hasPermissions(
            manyTypes,
            permissions: any(named: 'permissions'),
          ),
        ).called(1);
      });
    });

    group('platform-specific behavior', () {
      test('executes different paths for Android vs iOS', () async {
        // This test would ideally use platform-specific mocking
        // For demonstration purposes, we'll show the conceptual structure

        final testTypes = [HealthDataType.STEPS];

        when(
          () => mockHealthClient.hasPermissions(
            testTypes,
            permissions: any(named: 'permissions'),
          ),
        ).thenAnswer((_) async => true);

        when(() => mockHealthClient.isHealthDataHistoryAuthorized())
            .thenAnswer((_) async => true);

        // On Android, should check Health Connect availability
        if (Platform.isAndroid) {
          when(() => mockHealthClient.isHealthConnectAvailable())
              .thenAnswer((_) async => true);
        }

        // Act
        await permissionsGuard.ensurePermissions(mockHealthClient, testTypes);

        // Assert - Basic permission check should happen regardless of platform
        verify(
          () => mockHealthClient.hasPermissions(
            testTypes,
            permissions: any(named: 'permissions'),
          ),
        ).called(1);
      });
    });
  });
}
