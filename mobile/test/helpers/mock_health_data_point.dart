import 'package:health/health.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_health_client.dart';

class MockHealthDataPoint extends Mock implements HealthDataPoint {
  @override
  final String uuid;
  @override
  final HealthDataType type;
  @override
  final HealthDataUnit unit;
  @override
  final DateTime dateFrom;
  @override
  final DateTime dateTo;
  @override
  final HealthValue value;
  @override
  final String sourceId;
  @override
  final String sourceName;
  @override
  final String sourceDeviceId;
  @override
  final RecordingMethod recordingMethod;
  @override
  final HealthPlatformType sourcePlatform;

  MockHealthDataPoint({
    required this.type,
    required this.unit,
    required this.dateFrom,
    required this.dateTo,
    required this.value,
    String? uuid,
    String? sourceId,
    String? sourceName,
    String? sourceDeviceId,
    RecordingMethod? recordingMethod,
    HealthPlatformType? sourcePlatform,
  })  : uuid = uuid ?? 'test-uuid-${DateTime.now().millisecondsSinceEpoch}',
        sourceId = sourceId ?? '',
        sourceName = sourceName ?? '',
        sourceDeviceId = sourceDeviceId ?? '',
        recordingMethod = recordingMethod ?? RecordingMethod.automatic,
        sourcePlatform = sourcePlatform ?? HealthPlatformType.appleHealth;
}

class TestHealthDataFactory {
  static MockHealthDataPoint createStepsDataPoint({
    required DateTime dateFrom,
    required DateTime dateTo,
    required int steps,
    String? sourceId,
  }) =>
      MockHealthDataPoint(
        type: HealthDataType.STEPS,
        unit: HealthDataUnit.COUNT,
        dateFrom: dateFrom,
        dateTo: dateTo,
        value: MockNumericHealthValue(steps),
        sourceId: sourceId,
        sourceName: 'Test Source',
        sourceDeviceId: sourceId ?? 'test-device',
        recordingMethod: RecordingMethod.automatic,
      );

  static MockHealthDataPoint createHeartRateDataPoint({
    required DateTime dateFrom,
    required DateTime dateTo,
    required double heartRate,
    String? sourceId,
  }) =>
      MockHealthDataPoint(
        type: HealthDataType.HEART_RATE,
        unit: HealthDataUnit.BEATS_PER_MINUTE,
        dateFrom: dateFrom,
        dateTo: dateTo,
        value: MockNumericHealthValue(heartRate),
        sourceId: sourceId,
        sourceName: 'Test Source',
        sourceDeviceId: sourceId ?? 'test-device',
        recordingMethod: RecordingMethod.automatic,
      );

  static MockHealthDataPoint createSleepDataPoint({
    required DateTime dateFrom,
    required DateTime dateTo,
    String? sourceId,
  }) =>
      MockHealthDataPoint(
        type: HealthDataType.SLEEP_SESSION,
        unit: HealthDataUnit.MINUTE,
        dateFrom: dateFrom,
        dateTo: dateTo,
        value: MockNumericHealthValue(
          dateTo.difference(dateFrom).inMinutes.toDouble(),
        ),
        sourceId: sourceId,
        sourceName: 'Test Source',
        sourceDeviceId: sourceId ?? 'test-device',
        recordingMethod: RecordingMethod.automatic,
      );

  static MockHealthDataPoint createDistanceDataPoint({
    required DateTime dateFrom,
    required DateTime dateTo,
    required double distance,
    String? sourceId,
  }) =>
      MockHealthDataPoint(
        type: HealthDataType.DISTANCE_DELTA,
        unit: HealthDataUnit.METER,
        dateFrom: dateFrom,
        dateTo: dateTo,
        value: MockNumericHealthValue(distance),
        sourceId: sourceId,
        sourceName: 'Test Source',
        sourceDeviceId: sourceId ?? 'test-device',
        recordingMethod: RecordingMethod.automatic,
      );

  static MockHealthDataPoint createWorkoutDataPoint({
    required DateTime dateFrom,
    required DateTime dateTo,
    required String workoutType,
    required double value,
    String? sourceId,
  }) =>
      MockHealthDataPoint(
        type: HealthDataType.WORKOUT,
        unit: HealthDataUnit.MINUTE,
        dateFrom: dateFrom,
        dateTo: dateTo,
        value: MockNumericHealthValue(value),
        sourceId: sourceId,
        sourceName: 'Test Source',
        sourceDeviceId: sourceId ?? 'test-device',
        recordingMethod: RecordingMethod.automatic,
      );

  static MockHealthDataPoint createSleepAsleepDataPoint({
    required DateTime dateFrom,
    required DateTime dateTo,
    required double value,
    String? sourceId,
  }) =>
      MockHealthDataPoint(
        type: HealthDataType.SLEEP_ASLEEP,
        unit: HealthDataUnit.MINUTE,
        dateFrom: dateFrom,
        dateTo: dateTo,
        value: MockNumericHealthValue(value),
        sourceId: sourceId,
        sourceName: 'Test Source',
        sourceDeviceId: sourceId ?? 'test-device',
        recordingMethod: RecordingMethod.automatic,
      );
}
