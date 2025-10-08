import 'package:flutter_template/core/common/config.dart';
import 'package:flutter_template/core/health/health_data_aggregator.dart';
import 'package:flutter_template/core/health/health_data_mapper.dart';
import 'package:flutter_template/core/health/health_permissions_guard.dart';
import 'package:flutter_template/core/health/health_sleep_session_normalizer.dart';
import 'package:flutter_template/core/model/health_data_point.dart';
import 'package:flutter_template/core/model/health_data_request.dart';
import 'package:flutter_template/core/model/mcp_exceptions.dart';
import 'package:flutter_template/core/model/statistic_types.dart';
import 'package:flutter_template/core/model/time_group_by.dart';
import 'package:flutter_template/core/service/health_data_manager.dart';
import 'package:flutter_template/model/vytal_health_data_category.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health/health.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mock_health_client.dart';
import '../../../helpers/mock_health_data_point.dart';
import '../../../helpers/test_data_factory.dart';
import '../../../test_utils.dart';

class MockHealthDataAggregator extends Mock implements HealthDataAggregator {}

class MockHealthDataMapper extends Mock implements HealthDataMapper {}

class MockHealthPermissionsGuard extends Mock
    implements HealthPermissionsGuard {}

class MockHealthSleepSessionNormalizer extends Mock
    implements HealthSleepSessionNormalizer {}

void main() {
  setUpAll(() {
    registerFallbackValue(MockHealth());
    registerFallbackValue(<HealthDataType>[]);
    registerFallbackValue(<HealthDataPoint>[]);
    registerFallbackValue(<AppHealthDataPoint>[]);
    registerFallbackValue(VytalHealthDataCategory.STEPS);
    registerFallbackValue(
      (
        data: <AppHealthDataPoint>[],
        groupBy: TimeGroupBy.day,
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        aggregatePerSource: false,
        statisticType: StatisticType.sum,
      ),
    );
  });

  group('HealthDataManager', () {
    late HealthDataManager healthDataManager;
    late MockHealth mockHealthClient;
    late MockHealthDataAggregator mockAggregator;
    late MockHealthDataMapper mockMapper;
    late MockHealthPermissionsGuard mockPermissionsGuard;
    late MockHealthSleepSessionNormalizer mockSleepNormalizer;

    setUp(() {
      mockHealthClient = MockHealth();
      mockAggregator = MockHealthDataAggregator();
      mockMapper = MockHealthDataMapper();
      mockPermissionsGuard = MockHealthPermissionsGuard();
      mockSleepNormalizer = MockHealthSleepSessionNormalizer();

      healthDataManager = HealthDataManager(
        healthClient: mockHealthClient,
        aggregatePerSource: true,
        healthDataAggregator: mockAggregator,
        healthDataMapper: mockMapper,
        healthPermissionsGuard: mockPermissionsGuard,
        healthSleepSessionNormalizer: mockSleepNormalizer,
      );

      when(() => mockPermissionsGuard.ensurePermissions(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockSleepNormalizer.normalize(any())).thenAnswer(
        (invocation) =>
            invocation.positionalArguments[0] as List<HealthDataPoint>,
      );
      when(
        () => mockSleepNormalizer.adjustTimeRangeForSleepData(
          any(),
          any(),
          any(),
        ),
      ).thenAnswer(
        (invocation) => (
          startTime: invocation.positionalArguments[1] as DateTime,
          endTime: invocation.positionalArguments[2] as DateTime,
        ),
      );

      when(() => mockMapper.map(any())).thenReturn(<AppHealthDataPoint>[]);
    });

    group('processHealthDataRequest', () {
      test('processes valid request successfully', () async {
        final request = TestDataFactory.createHealthDataRequest(
          valueType: VytalHealthDataCategory.STEPS,
          startTime: DateTime(2024, 1, 1),
          endTime: DateTime(2024, 1, 2),
        );

        final mockHealthData = [
          TestHealthDataFactory.createStepsDataPoint(
            dateFrom: DateTime(2024, 1, 1, 10),
            dateTo: DateTime(2024, 1, 1, 11),
            steps: 1000,
          ),
        ];

        when(
          () => mockHealthClient.getHealthDataFromTypes(
            types: any(named: 'types'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
          ),
        ).thenAnswer((_) async => mockHealthData);

        when(() => mockMapper.map(any())).thenReturn([
          TestDataFactory.createRawHealthDataPoint(type: 'STEPS', value: 1000),
        ]);

        final result =
            await healthDataManager.processHealthDataRequest(request);

        expect(result.success, isTrue);
        expect(result.valueType, equals('STEPS'));
        expect(result.count, equals(1));
        verify(
          () => mockPermissionsGuard.ensurePermissions(
            mockHealthClient,
            VytalHealthDataCategory.STEPS.platformHealthDataTypes,
          ),
        ).called(1);
      });

      test('validates time range correctly', () async {
        final request = TestDataFactory.createHealthDataRequest(
          startTime: DateTime(2024, 1, 2),
          endTime: DateTime(2024, 1, 1),
        );

        await TestUtils.expectAsyncThrows<HealthMcpServerException>(
          () => healthDataManager.processHealthDataRequest(request),
        );
      });

      test('validates start time is not in future', () async {
        final futureTime = DateTime.now().add(const Duration(days: 1));
        final request = TestDataFactory.createHealthDataRequest(
          startTime: futureTime,
          endTime: futureTime.add(const Duration(hours: 1)),
        );

        await TestUtils.expectAsyncThrows<HealthMcpServerException>(
          () => healthDataManager.processHealthDataRequest(request),
        );
      });

      test('handles permission errors correctly', () async {
        final request = TestDataFactory.createHealthDataRequest();

        when(() => mockPermissionsGuard.ensurePermissions(any(), any()))
            .thenThrow(const HealthPermissionException('Permission denied'));

        await TestUtils.expectAsyncThrows<HealthMcpServerException>(
          () => healthDataManager.processHealthDataRequest(request),
        );
      });

      test('handles health data unavailable errors', () async {
        final request = TestDataFactory.createHealthDataRequest();

        when(() => mockPermissionsGuard.ensurePermissions(any(), any()))
            .thenThrow(
          const HealthDataUnavailableException(
            'Health Connect not available',
          ),
        );

        await TestUtils.expectAsyncThrows<HealthMcpServerException>(
          () => healthDataManager.processHealthDataRequest(request),
        );
      });

      test('processes aggregated data request with statistics', () async {
        final request = TestDataFactory.createHealthDataRequest(
          groupBy: TimeGroupBy.day,
          statistic: StatisticType.sum,
        );

        final mockHealthData = [
          TestHealthDataFactory.createStepsDataPoint(
            dateFrom: DateTime(2024, 1, 1, 10),
            dateTo: DateTime(2024, 1, 1, 11),
            steps: 1000,
          ),
          TestHealthDataFactory.createStepsDataPoint(
            dateFrom: DateTime(2024, 1, 1, 14),
            dateTo: DateTime(2024, 1, 1, 15),
            steps: 2000,
          ),
        ];

        final mockMappedData = [
          TestDataFactory.createRawHealthDataPoint(type: 'STEPS', value: 1000),
          TestDataFactory.createRawHealthDataPoint(type: 'STEPS', value: 2000),
        ];

        final mockAggregatedData = [
          TestDataFactory.createAggregatedHealthDataPoint(
            type: 'STEPS',
            value: 3000.0,
          ),
        ];

        when(
          () => mockHealthClient.getHealthDataFromTypes(
            types: any(named: 'types'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
          ),
        ).thenAnswer((_) async => mockHealthData);

        when(() => mockMapper.map(any())).thenReturn(mockMappedData);

        when(() => mockAggregator.aggregate(any()))
            .thenReturn(mockAggregatedData.cast<AggregatedHealthDataPoint>());

        final result =
            await healthDataManager.processHealthDataRequest(request);

        expect(result.success, isTrue);
        expect(result.isAggregated, isTrue);
        expect(result.groupBy, equals('day'));
        expect(result.statisticType, equals('sum'));
        verify(() => mockAggregator.aggregate(any())).called(1);
      });

      test('processes average statistic correctly', () async {
        final request = TestDataFactory.createHealthDataRequest(
          groupBy: TimeGroupBy.day,
          statistic: StatisticType.average,
        );

        final mockHealthData = [
          TestHealthDataFactory.createStepsDataPoint(
            dateFrom: DateTime(2024, 1, 1, 10),
            dateTo: DateTime(2024, 1, 1, 11),
            steps: 1000,
          ),
        ];

        final mockMappedData = [
          TestDataFactory.createRawHealthDataPoint(type: 'STEPS', value: 1000),
        ];

        final mockAggregatedData = [
          TestDataFactory.createAggregatedHealthDataPoint(
            type: 'STEPS',
            value: 1500.0,
          ),
        ];

        when(
          () => mockHealthClient.getHealthDataFromTypes(
            types: any(named: 'types'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
          ),
        ).thenAnswer((_) async => mockHealthData);

        when(() => mockMapper.map(any())).thenReturn(mockMappedData);

        when(() => mockAggregator.aggregate(any()))
            .thenReturn(mockAggregatedData.cast<AggregatedHealthDataPoint>());

        final result =
            await healthDataManager.processHealthDataRequest(request);

        expect(result.success, isTrue);
        expect(result.statisticType, equals('average'));
        expect(result.healthData.length, equals(1));
        expect(
          result.healthData.first.value,
          equals(1500.0),
        ); // Overall average calculated
      });

      test('throws error when groupBy specified without statistic', () async {
        final request = TestDataFactory.createHealthDataRequest(
          groupBy: TimeGroupBy.day,
          statistic: null, // Missing statistic
        );

        final mockHealthData = [
          TestHealthDataFactory.createStepsDataPoint(
            dateFrom: DateTime(2024, 1, 1, 10),
            dateTo: DateTime(2024, 1, 1, 11),
            steps: 1000,
          ),
        ];

        when(
          () => mockHealthClient.getHealthDataFromTypes(
            types: any(named: 'types'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
          ),
        ).thenAnswer((_) async => mockHealthData);

        when(() => mockMapper.map(any())).thenReturn([
          TestDataFactory.createRawHealthDataPoint(),
        ]);

        await TestUtils.expectAsyncThrows<HealthMcpServerException>(
          () => healthDataManager.processHealthDataRequest(request),
        );
      });

      test('normalizes sleep data correctly', () async {
        final request = TestDataFactory.createHealthDataRequest(
          valueType: VytalHealthDataCategory.SLEEP,
        );

        final mockHealthData = [
          TestHealthDataFactory.createSleepDataPoint(
            dateFrom: DateTime(2024, 1, 1, 22),
            dateTo: DateTime(2024, 1, 2, 6),
          ),
        ];

        final normalizedData = [
          TestHealthDataFactory.createSleepDataPoint(
            dateFrom: DateTime(2024, 1, 1, 22),
            dateTo: DateTime(2024, 1, 2, 6),
          ),
        ];

        when(
          () => mockHealthClient.getHealthDataFromTypes(
            types: any(named: 'types'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
          ),
        ).thenAnswer((_) async => mockHealthData);

        when(() => mockSleepNormalizer.normalize(mockHealthData))
            .thenReturn(normalizedData);

        await healthDataManager.processHealthDataRequest(request);

        verify(() => mockSleepNormalizer.normalize(mockHealthData)).called(1);
      });

      test('skips normalization for non-sleep data', () async {
        final request = TestDataFactory.createHealthDataRequest(
          valueType: VytalHealthDataCategory.STEPS,
        );

        final mockHealthData = [
          TestHealthDataFactory.createStepsDataPoint(
            dateFrom: DateTime(2024, 1, 1, 10),
            dateTo: DateTime(2024, 1, 1, 11),
            steps: 1000,
          ),
        ];

        when(
          () => mockHealthClient.getHealthDataFromTypes(
            types: any(named: 'types'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
          ),
        ).thenAnswer((_) async => mockHealthData);

        await healthDataManager.processHealthDataRequest(request);

        verifyNever(() => mockSleepNormalizer.normalize(any()));
      });

      test('handles empty health data', () async {
        final request = TestDataFactory.createHealthDataRequest();

        when(
          () => mockHealthClient.getHealthDataFromTypes(
            types: any(named: 'types'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
          ),
        ).thenAnswer((_) async => <HealthDataPoint>[]);

        when(() => mockMapper.map(any())).thenReturn(<AppHealthDataPoint>[]);

        final result =
            await healthDataManager.processHealthDataRequest(request);

        expect(result.success, isTrue);
        expect(result.count, equals(0));
        expect(result.healthData, isEmpty);
      });

      test('handles multiple health data types', () async {
        final request = TestDataFactory.createHealthDataRequest(
          valueType: VytalHealthDataCategory.HEART_RATE,
        );

        final mockHealthData = [
          TestHealthDataFactory.createHeartRateDataPoint(
            dateFrom: DateTime(2024, 1, 1, 10),
            dateTo: DateTime(2024, 1, 1, 10),
            heartRate: 80.0,
          ),
          TestHealthDataFactory.createHeartRateDataPoint(
            dateFrom: DateTime(2024, 1, 1, 11),
            dateTo: DateTime(2024, 1, 1, 11),
            heartRate: 85.0,
          ),
        ];

        when(
          () => mockHealthClient.getHealthDataFromTypes(
            types: any(named: 'types'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
          ),
        ).thenAnswer((_) async => mockHealthData);

        when(() => mockMapper.map(any())).thenReturn([
          TestDataFactory.createRawHealthDataPoint(
            type: 'HEART_RATE',
            value: 80.0,
          ),
          TestDataFactory.createRawHealthDataPoint(
            type: 'HEART_RATE',
            value: 85.0,
          ),
        ]);

        final result =
            await healthDataManager.processHealthDataRequest(request);

        expect(result.success, isTrue);
        expect(result.valueType, equals('HEART_RATE'));
        expect(result.count, equals(2));
        verify(
          () => mockPermissionsGuard.ensurePermissions(
            mockHealthClient,
            VytalHealthDataCategory.HEART_RATE.platformHealthDataTypes,
          ),
        ).called(1);
      });

      test('preserves source aggregation setting', () async {
        final healthDataManagerWithoutSourceAggregation = HealthDataManager(
          healthClient: mockHealthClient,
          aggregatePerSource: false,
          healthDataAggregator: mockAggregator,
          healthDataMapper: mockMapper,
          healthPermissionsGuard: mockPermissionsGuard,
          healthSleepSessionNormalizer: mockSleepNormalizer,
        );

        final request = TestDataFactory.createHealthDataRequest(
          groupBy: TimeGroupBy.day,
          statistic: StatisticType.sum,
        );

        final mockHealthData = [
          TestHealthDataFactory.createStepsDataPoint(
            dateFrom: DateTime(2024, 1, 1, 10),
            dateTo: DateTime(2024, 1, 1, 11),
            steps: 1000,
          ),
        ];

        when(
          () => mockHealthClient.getHealthDataFromTypes(
            types: any(named: 'types'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
          ),
        ).thenAnswer((_) async => mockHealthData);

        when(() => mockMapper.map(any())).thenReturn([
          TestDataFactory.createRawHealthDataPoint(),
        ]);

        when(() => mockAggregator.aggregate(any())).thenReturn([
          TestDataFactory.createAggregatedHealthDataPoint()
              as AggregatedHealthDataPoint,
        ]);

        await healthDataManagerWithoutSourceAggregation
            .processHealthDataRequest(request);

        final captured =
            verify(() => mockAggregator.aggregate(captureAny())).captured;
        expect(captured.first.aggregatePerSource, isFalse);
      });
    });

    group('error handling', () {
      test('wraps health client exceptions in HealthMcpServerException',
          () async {
        final request = TestDataFactory.createHealthDataRequest();

        when(
          () => mockHealthClient.getHealthDataFromTypes(
            types: any(named: 'types'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
          ),
        ).thenThrow(Exception('Health client error'));

        expect(
          () => healthDataManager.processHealthDataRequest(request),
          throwsA(isA<HealthMcpServerException>()),
        );
      });

      test('preserves specific health exceptions', () async {
        final request = TestDataFactory.createHealthDataRequest();

        when(() => mockPermissionsGuard.ensurePermissions(any(), any()))
            .thenThrow(const HealthPermissionException('No permissions'));

        expect(
          () => healthDataManager.processHealthDataRequest(request),
          throwsA(isA<HealthMcpServerException>()),
        );
      });

      test('handles mapper exceptions', () async {
        final request = TestDataFactory.createHealthDataRequest();

        final mockHealthData = [
          TestHealthDataFactory.createStepsDataPoint(
            dateFrom: DateTime(2024, 1, 1, 10),
            dateTo: DateTime(2024, 1, 1, 11),
            steps: 1000,
          ),
        ];

        when(
          () => mockHealthClient.getHealthDataFromTypes(
            types: any(named: 'types'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
          ),
        ).thenAnswer((_) async => mockHealthData);

        when(() => mockMapper.map(any())).thenThrow(Exception('Mapping error'));

        expect(
          () => healthDataManager.processHealthDataRequest(request),
          throwsA(isA<HealthMcpServerException>()),
        );
      });

      test('handles aggregator exceptions', () async {
        final request = TestDataFactory.createHealthDataRequest(
          groupBy: TimeGroupBy.day,
          statistic: StatisticType.sum,
        );

        final mockHealthData = [
          TestHealthDataFactory.createStepsDataPoint(
            dateFrom: DateTime(2024, 1, 1, 10),
            dateTo: DateTime(2024, 1, 1, 11),
            steps: 1000,
          ),
        ];

        when(
          () => mockHealthClient.getHealthDataFromTypes(
            types: any(named: 'types'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
          ),
        ).thenAnswer((_) async => mockHealthData);

        when(() => mockMapper.map(any())).thenReturn([
          TestDataFactory.createRawHealthDataPoint(),
        ]);

        when(() => mockAggregator.aggregate(any()))
            .thenThrow(Exception('Aggregation error'));

        expect(
          () => healthDataManager.processHealthDataRequest(request),
          throwsA(isA<HealthMcpServerException>()),
        );
      });

      test(
        'HEART_RATE daily averages returns individual daily averages',
        () async {
          final request = HealthDataRequest(
            valueType: VytalHealthDataCategory.HEART_RATE,
            startTime: DateTime(2024, 1, 1),
            endTime: DateTime(2024, 1, 8),
            // One week
            groupBy: TimeGroupBy.day,
            statistic: StatisticType.average,
          );

          final mockHealthData = [
            TestHealthDataFactory.createHeartRateDataPoint(
              dateFrom: DateTime(2024, 1, 1, 8),
              dateTo: DateTime(2024, 1, 1, 8),
              heartRate: 70.0,
            ),
            TestHealthDataFactory.createHeartRateDataPoint(
              dateFrom: DateTime(2024, 1, 1, 12),
              dateTo: DateTime(2024, 1, 1, 12),
              heartRate: 80.0,
            ),
            TestHealthDataFactory.createHeartRateDataPoint(
              dateFrom: DateTime(2024, 1, 1, 18),
              dateTo: DateTime(2024, 1, 1, 18),
              heartRate: 90.0,
            ),
            TestHealthDataFactory.createHeartRateDataPoint(
              dateFrom: DateTime(2024, 1, 2, 9),
              dateTo: DateTime(2024, 1, 2, 9),
              heartRate: 75.0,
            ),
            TestHealthDataFactory.createHeartRateDataPoint(
              dateFrom: DateTime(2024, 1, 2, 15),
              dateTo: DateTime(2024, 1, 2, 15),
              heartRate: 85.0,
            ),
            TestHealthDataFactory.createHeartRateDataPoint(
              dateFrom: DateTime(2024, 1, 3, 14),
              dateTo: DateTime(2024, 1, 3, 14),
              heartRate: 65.0,
            ),
          ];

          when(
            () => mockHealthClient.getHealthDataFromTypes(
              types: any(named: 'types'),
              startTime: any(named: 'startTime'),
              endTime: any(named: 'endTime'),
            ),
          ).thenAnswer((_) async => mockHealthData);

          when(() => mockMapper.map(any())).thenReturn([
            TestDataFactory.createRawHealthDataPoint(
              type: 'HEART_RATE',
              value: 80.0,
              dateFrom: DateTime(2024, 1, 1),
              dateTo: DateTime(2024, 1, 2),
            ),
            TestDataFactory.createRawHealthDataPoint(
              type: 'HEART_RATE',
              value: 80.0,
              dateFrom: DateTime(2024, 1, 2),
              dateTo: DateTime(2024, 1, 3),
            ),
            TestDataFactory.createRawHealthDataPoint(
              type: 'HEART_RATE',
              value: 65.0,
              dateFrom: DateTime(2024, 1, 3),
              dateTo: DateTime(2024, 1, 4),
            ),
          ]);

          when(() => mockAggregator.aggregate(any())).thenReturn([
            const AggregatedHealthDataPoint(
              type: 'HEART_RATE',
              value: 80.0,
              unit: 'BEATS_PER_MINUTE',
              dateFrom: '2024-01-01T00:00:00.000',
              dateTo: '2024-01-02T00:00:00.000',
              sourceId: null,
            ),
            const AggregatedHealthDataPoint(
              type: 'HEART_RATE',
              value: 80.0,
              unit: 'BEATS_PER_MINUTE',
              dateFrom: '2024-01-02T00:00:00.000',
              dateTo: '2024-01-03T00:00:00.000',
              sourceId: null,
            ),
            const AggregatedHealthDataPoint(
              type: 'HEART_RATE',
              value: 65.0,
              unit: 'BEATS_PER_MINUTE',
              dateFrom: '2024-01-03T00:00:00.000',
              dateTo: '2024-01-04T00:00:00.000',
              sourceId: null,
            ),
          ]);

          final result =
              await healthDataManager.processHealthDataRequest(request);

          expect(result.success, isTrue);

          expect(
            result.count,
            equals(3),
            reason: 'Should return individual daily averages',
          );

          final healthData = result.healthData;
          expect(
            healthData.length,
            equals(3),
            reason: 'Should have separate data points for each day',
          );

          final aggregatedData = healthData.cast<AggregatedHealthDataPoint>();

          final day1Data = aggregatedData.firstWhere(
            (point) => point.dateFrom == '2024-01-01T00:00:00.000',
          );
          expect(
            day1Data.value,
            equals(80.0),
            reason: 'Day 1 should have average of 80',
          );

          final day2Data = aggregatedData.firstWhere(
            (point) => point.dateFrom == '2024-01-02T00:00:00.000',
          );
          expect(
            day2Data.value,
            equals(80.0),
            reason: 'Day 2 should have average of 80',
          );

          final day3Data = aggregatedData.firstWhere(
            (point) => point.dateFrom == '2024-01-03T00:00:00.000',
          );
          expect(
            day3Data.value,
            equals(65.0),
            reason: 'Day 3 should have average of 65',
          );
        },
      );

      test(
        'STEPS cumulative data aggregation with sum and average statistics',
        () async {
          final sumRequest = HealthDataRequest(
            valueType: VytalHealthDataCategory.STEPS,
            startTime: DateTime(2024, 1, 1),
            endTime: DateTime(2024, 1, 4),
            groupBy: TimeGroupBy.day,
            statistic: StatisticType.sum,
          );

          final mockStepsData = [
            TestHealthDataFactory.createStepsDataPoint(
              dateFrom: DateTime(2024, 1, 1, 8),
              dateTo: DateTime(2024, 1, 1, 10),
              steps: 1000,
            ),
            TestHealthDataFactory.createStepsDataPoint(
              dateFrom: DateTime(2024, 1, 1, 14),
              dateTo: DateTime(2024, 1, 1, 16),
              steps: 2000,
            ),
            TestHealthDataFactory.createStepsDataPoint(
              dateFrom: DateTime(2024, 1, 2, 9),
              dateTo: DateTime(2024, 1, 2, 11),
              steps: 1500,
            ),
            TestHealthDataFactory.createStepsDataPoint(
              dateFrom: DateTime(2024, 1, 2, 15),
              dateTo: DateTime(2024, 1, 2, 17),
              steps: 1000,
            ),
            TestHealthDataFactory.createStepsDataPoint(
              dateFrom: DateTime(2024, 1, 3, 10),
              dateTo: DateTime(2024, 1, 3, 12),
              steps: 2200,
            ),
          ];

          when(
            () => mockHealthClient.getHealthDataFromTypes(
              types: any(named: 'types'),
              startTime: any(named: 'startTime'),
              endTime: any(named: 'endTime'),
            ),
          ).thenAnswer((_) async => mockStepsData);

          when(() => mockMapper.map(any())).thenReturn([
            TestDataFactory.createRawHealthDataPoint(
              type: 'STEPS',
              value: 3000,
              dateFrom: DateTime(2024, 1, 1),
              dateTo: DateTime(2024, 1, 2),
            ),
            TestDataFactory.createRawHealthDataPoint(
              type: 'STEPS',
              value: 2500,
              dateFrom: DateTime(2024, 1, 2),
              dateTo: DateTime(2024, 1, 3),
            ),
            TestDataFactory.createRawHealthDataPoint(
              type: 'STEPS',
              value: 2200,
              dateFrom: DateTime(2024, 1, 3),
              dateTo: DateTime(2024, 1, 4),
            ),
          ]);

          when(() => mockAggregator.aggregate(any())).thenReturn([
            const AggregatedHealthDataPoint(
              type: 'STEPS',
              value: 3000.0,
              unit: 'COUNT',
              dateFrom: '2024-01-01T00:00:00.000',
              dateTo: '2024-01-02T00:00:00.000',
              sourceId: null,
            ),
            const AggregatedHealthDataPoint(
              type: 'STEPS',
              value: 2500.0,
              unit: 'COUNT',
              dateFrom: '2024-01-02T00:00:00.000',
              dateTo: '2024-01-03T00:00:00.000',
              sourceId: null,
            ),
            const AggregatedHealthDataPoint(
              type: 'STEPS',
              value: 2200.0,
              unit: 'COUNT',
              dateFrom: '2024-01-03T00:00:00.000',
              dateTo: '2024-01-04T00:00:00.000',
              sourceId: null,
            ),
          ]);

          final sumResult =
              await healthDataManager.processHealthDataRequest(sumRequest);

          expect(sumResult.success, isTrue);
          expect(
            sumResult.count,
            equals(3),
            reason: 'Should return individual daily sums',
          );

          final sumHealthData =
              sumResult.healthData.cast<AggregatedHealthDataPoint>();

          expect(
            sumHealthData[0].value,
            equals(3000.0),
            reason: 'Day 1 should have sum of 3000 steps',
          );
          expect(
            sumHealthData[1].value,
            equals(2500.0),
            reason: 'Day 2 should have sum of 2500 steps',
          );
          expect(
            sumHealthData[2].value,
            equals(2200.0),
            reason: 'Day 3 should have sum of 2200 steps',
          );

          // Test AVERAGE statistic
          final avgRequest = HealthDataRequest(
            valueType: VytalHealthDataCategory.STEPS,
            startTime: DateTime(2024, 1, 1),
            endTime: DateTime(2024, 1, 4),
            groupBy: TimeGroupBy.day,
            statistic: StatisticType.average,
          );

          // Mock aggregator to return averages
          //(2 data points for day 1&2, 1 for day 3)
          when(() => mockAggregator.aggregate(any())).thenReturn([
            const AggregatedHealthDataPoint(
              type: 'STEPS',
              value: 1500.0,
              unit: 'COUNT',
              dateFrom: '2024-01-01T00:00:00.000',
              dateTo: '2024-01-02T00:00:00.000',
              sourceId: null,
            ),
            const AggregatedHealthDataPoint(
              type: 'STEPS',
              value: 1250.0,
              unit: 'COUNT',
              dateFrom: '2024-01-02T00:00:00.000',
              dateTo: '2024-01-03T00:00:00.000',
              sourceId: null,
            ),
            const AggregatedHealthDataPoint(
              type: 'STEPS',
              value: 2200.0,
              unit: 'COUNT',
              dateFrom: '2024-01-03T00:00:00.000',
              dateTo: '2024-01-04T00:00:00.000',
              sourceId: null,
            ),
          ]);

          final avgResult =
              await healthDataManager.processHealthDataRequest(avgRequest);

          expect(avgResult.success, isTrue);
          expect(
            avgResult.count,
            equals(3),
            reason: 'Should return individual daily averages',
          );

          final avgHealthData =
              avgResult.healthData.cast<AggregatedHealthDataPoint>();

          expect(
            avgHealthData[0].value,
            equals(1500.0),
            reason: 'Day 1 should have average of 1500 steps per data point',
          );
          expect(
            avgHealthData[1].value,
            equals(1250.0),
            reason: 'Day 2 should have average of 1250 steps per data point',
          );
          expect(
            avgHealthData[2].value,
            equals(2200.0),
            reason: 'Day 3 should have average of 2200 steps per data point',
          );
        },
      );

      test(
        'WORKOUT sessional data aggregation with sum and average statistics',
        () async {
          final sumRequest = HealthDataRequest(
            valueType: VytalHealthDataCategory.WORKOUT,
            startTime: DateTime(2024, 1, 1),
            endTime: DateTime(2024, 1, 4),
            groupBy: TimeGroupBy.day,
            statistic: StatisticType.sum,
          );

          final mockWorkoutData = [
            TestHealthDataFactory.createWorkoutDataPoint(
              dateFrom: DateTime(2024, 1, 1, 7),
              dateTo: DateTime(2024, 1, 1, 8, 30),
              workoutType: 'Running',
              value: 90,
            ),
            TestHealthDataFactory.createWorkoutDataPoint(
              dateFrom: DateTime(2024, 1, 1, 18),
              dateTo: DateTime(2024, 1, 1, 19),
              workoutType: 'Cycling',
              value: 60,
            ),
            TestHealthDataFactory.createWorkoutDataPoint(
              dateFrom: DateTime(2024, 1, 2, 9),
              dateTo: DateTime(2024, 1, 2, 10, 30),
              workoutType: 'Swimming',
              value: 90,
            ),
            TestHealthDataFactory.createWorkoutDataPoint(
              dateFrom: DateTime(2024, 1, 3, 23),
              dateTo: DateTime(2024, 1, 4, 1),
              workoutType: 'Yoga',
              value: 120,
            ),
          ];

          when(
            () => mockHealthClient.getHealthDataFromTypes(
              types: any(named: 'types'),
              startTime: any(named: 'startTime'),
              endTime: any(named: 'endTime'),
            ),
          ).thenAnswer((_) async => mockWorkoutData);

          when(() => mockMapper.map(any())).thenReturn([
            TestDataFactory.createRawHealthDataPoint(
              type: 'WORKOUT',
              value: 2,
              dateFrom: DateTime(2024, 1, 1),
              dateTo: DateTime(2024, 1, 2),
            ),
            TestDataFactory.createRawHealthDataPoint(
              type: 'WORKOUT',
              value: 1,
              dateFrom: DateTime(2024, 1, 2),
              dateTo: DateTime(2024, 1, 3),
            ),
          ]);

          when(() => mockAggregator.aggregate(any())).thenReturn([
            const AggregatedHealthDataPoint(
              type: 'WORKOUT',
              value: 2.0,
              unit: 'COUNT',
              dateFrom: '2024-01-01T00:00:00.000',
              dateTo: '2024-01-02T00:00:00.000',
              sourceId: null,
            ),
            const AggregatedHealthDataPoint(
              type: 'WORKOUT',
              value: 1.0,
              unit: 'COUNT',
              dateFrom: '2024-01-02T00:00:00.000',
              dateTo: '2024-01-03T00:00:00.000',
              sourceId: null,
            ),
          ]);

          final sumResult =
              await healthDataManager.processHealthDataRequest(sumRequest);

          expect(sumResult.success, isTrue);
          expect(
            sumResult.count,
            equals(2),
            reason: 'Should return individual daily session counts',
          );

          final sumHealthData =
              sumResult.healthData.cast<AggregatedHealthDataPoint>();

          expect(
            sumHealthData[0].value,
            equals(2.0),
            reason: 'Day 1 should have 2 workout sessions',
          );
          expect(
            sumHealthData[1].value,
            equals(1.0),
            reason: 'Day 2 should have 1 workout session',
          );

          final avgRequest = HealthDataRequest(
            valueType: VytalHealthDataCategory.WORKOUT,
            startTime: DateTime(2024, 1, 1),
            endTime: DateTime(2024, 1, 4),
            groupBy: TimeGroupBy.day,
            statistic: StatisticType.average,
          );

          when(() => mockAggregator.aggregate(any())).thenReturn([
            const AggregatedHealthDataPoint(
              type: 'WORKOUT',
              value: 75.0,
              unit: 'MINUTE',
              dateFrom: '2024-01-01T00:00:00.000',
              dateTo: '2024-01-02T00:00:00.000',
              sourceId: null,
            ),
            const AggregatedHealthDataPoint(
              type: 'WORKOUT',
              value: 90.0,
              unit: 'MINUTE',
              dateFrom: '2024-01-02T00:00:00.000',
              dateTo: '2024-01-03T00:00:00.000',
              sourceId: null,
            ),
          ]);

          final avgResult =
              await healthDataManager.processHealthDataRequest(avgRequest);

          expect(avgResult.success, isTrue);
          expect(
            avgResult.count,
            equals(2),
            reason: 'Should return individual daily workout averages',
          );

          final avgHealthData =
              avgResult.healthData.cast<AggregatedHealthDataPoint>();

          expect(
            avgHealthData[0].value,
            equals(75.0),
            reason: 'Day 1 should have average workout duration of 75 minutes',
          );
          expect(
            avgHealthData[1].value,
            equals(90.0),
            reason: 'Day 2 should have average workout duration of 90 minutes',
          );
        },
      );

      test(
        // ignore: lines_longer_than_80_chars
        'SLEEP_ASLEEP durational data aggregation with sum and average statistics',
        () async {
          final sumRequest = HealthDataRequest(
            valueType: VytalHealthDataCategory.SLEEP,
            startTime: DateTime(2024, 1, 1),
            endTime: DateTime(2024, 1, 4),
            groupBy: TimeGroupBy.day,
            statistic: StatisticType.sum,
          );

          final mockSleepData = [
            TestHealthDataFactory.createSleepAsleepDataPoint(
              dateFrom: DateTime(2024, 1, 1, 22),
              dateTo: DateTime(2024, 1, 2, 6),
              value: 480,
            ),
            TestHealthDataFactory.createSleepAsleepDataPoint(
              dateFrom: DateTime(2024, 1, 1, 14),
              dateTo: DateTime(2024, 1, 1, 15, 30),
              value: 90,
            ),
            TestHealthDataFactory.createSleepAsleepDataPoint(
              dateFrom: DateTime(2024, 1, 2, 23),
              dateTo: DateTime(2024, 1, 3, 7),
              value: 480,
            ),
            TestHealthDataFactory.createSleepAsleepDataPoint(
              dateFrom: DateTime(2024, 1, 3, 13),
              dateTo: DateTime(2024, 1, 3, 14),
              value: 60,
            ),
            TestHealthDataFactory.createSleepAsleepDataPoint(
              dateFrom: DateTime(
                2024,
                1,
                3,
                22,
                30,
              ),
              dateTo: DateTime(2024, 1, 4, 6, 30),
              value: 480,
            ),
          ];

          when(
            () => mockHealthClient.getHealthDataFromTypes(
              types: any(named: 'types'),
              startTime: any(named: 'startTime'),
              endTime: any(named: 'endTime'),
            ),
          ).thenAnswer((_) async => mockSleepData);

          when(() => mockMapper.map(any())).thenReturn([
            TestDataFactory.createRawHealthDataPoint(
              type: 'SLEEP_ASLEEP',
              value: 570,
              dateFrom: DateTime(2024, 1, 1),
              dateTo: DateTime(2024, 1, 2),
            ),
            TestDataFactory.createRawHealthDataPoint(
              type: 'SLEEP_ASLEEP',
              value: 480,
              dateFrom: DateTime(2024, 1, 2),
              dateTo: DateTime(2024, 1, 3),
            ),
            TestDataFactory.createRawHealthDataPoint(
              type: 'SLEEP_ASLEEP',
              value: 540,
              dateFrom: DateTime(2024, 1, 3),
              dateTo: DateTime(2024, 1, 4),
            ),
          ]);

          when(() => mockAggregator.aggregate(any())).thenReturn([
            const AggregatedHealthDataPoint(
              type: 'SLEEP_ASLEEP',
              value: 570.0,
              unit: 'MINUTE',
              dateFrom: '2024-01-01T00:00:00.000',
              dateTo: '2024-01-02T00:00:00.000',
              sourceId: null,
            ),
            const AggregatedHealthDataPoint(
              type: 'SLEEP_ASLEEP',
              value: 480.0,
              unit: 'MINUTE',
              dateFrom: '2024-01-02T00:00:00.000',
              dateTo: '2024-01-03T00:00:00.000',
              sourceId: null,
            ),
            const AggregatedHealthDataPoint(
              type: 'SLEEP_ASLEEP',
              value: 540.0,
              unit: 'MINUTE',
              dateFrom: '2024-01-03T00:00:00.000',
              dateTo: '2024-01-04T00:00:00.000',
              sourceId: null,
            ),
          ]);

          final sumResult =
              await healthDataManager.processHealthDataRequest(sumRequest);

          expect(sumResult.success, isTrue);
          expect(
            sumResult.count,
            equals(3),
            reason: 'Should return individual daily sleep totals',
          );

          final sumHealthData =
              sumResult.healthData.cast<AggregatedHealthDataPoint>();

          expect(
            sumHealthData[0].value,
            equals(570.0),
            reason: 'Day 1 should have total sleep of 570 minutes (8h + 1.5h)',
          );
          expect(
            sumHealthData[1].value,
            equals(480.0),
            reason: 'Day 2 should have total sleep of 480 minutes (8h)',
          );
          expect(
            sumHealthData[2].value,
            equals(540.0),
            reason: 'Day 3 should have total sleep of 540 minutes (1h + 8h)',
          );

          final avgRequest = HealthDataRequest(
            valueType: VytalHealthDataCategory.SLEEP,
            startTime: DateTime(2024, 1, 1),
            endTime: DateTime(2024, 1, 4),
            groupBy: TimeGroupBy.day,
            statistic: StatisticType.average,
          );

          when(() => mockAggregator.aggregate(any())).thenReturn([
            const AggregatedHealthDataPoint(
              type: 'SLEEP_ASLEEP',
              value: 285.0,
              unit: 'MINUTE',
              dateFrom: '2024-01-01T00:00:00.000',
              dateTo: '2024-01-02T00:00:00.000',
              sourceId: null,
            ),
            const AggregatedHealthDataPoint(
              type: 'SLEEP_ASLEEP',
              value: 480.0,
              unit: 'MINUTE',
              dateFrom: '2024-01-02T00:00:00.000',
              dateTo: '2024-01-03T00:00:00.000',
              sourceId: null,
            ),
            const AggregatedHealthDataPoint(
              type: 'SLEEP_ASLEEP',
              value: 270.0,
              unit: 'MINUTE',
              dateFrom: '2024-01-03T00:00:00.000',
              dateTo: '2024-01-04T00:00:00.000',
              sourceId: null,
            ),
          ]);

          final avgResult =
              await healthDataManager.processHealthDataRequest(avgRequest);

          expect(avgResult.success, isTrue);
          expect(
            avgResult.count,
            equals(3),
            reason: 'Should return individual daily sleep averages',
          );

          final avgHealthData =
              avgResult.healthData.cast<AggregatedHealthDataPoint>();

          expect(
            avgHealthData[0].value,
            equals(285.0),
            reason: 'Day 1 should have average sleep period of 285 minutes',
          );
          expect(
            avgHealthData[1].value,
            equals(480.0),
            reason: 'Day 2 should have average sleep period of 480 minutes',
          );
          expect(
            avgHealthData[2].value,
            equals(270.0),
            reason: 'Day 3 should have average sleep period of 270 minutes',
          );
        },
      );

      test('returns cached response for repeated request within ttl', () async {
        final baseTime = DateTime(2024, 1, 1, 12);
        final currentTime = baseTime;
        healthDataManager = HealthDataManager(
          healthClient: mockHealthClient,
          aggregatePerSource: true,
          healthDataAggregator: mockAggregator,
          healthDataMapper: mockMapper,
          healthPermissionsGuard: mockPermissionsGuard,
          healthSleepSessionNormalizer: mockSleepNormalizer,
          nowProvider: () => currentTime,
        );

        final request = TestDataFactory.createHealthDataRequest(
          startTime: DateTime(2024, 1, 1),
          endTime: DateTime(2024, 1, 2),
        );

        final mockHealthData = [
          TestHealthDataFactory.createStepsDataPoint(
            dateFrom: DateTime(2024, 1, 1, 8),
            dateTo: DateTime(2024, 1, 1, 9),
            steps: 750,
          ),
        ];

        when(
          () => mockHealthClient.getHealthDataFromTypes(
            types: any(named: 'types'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
          ),
        ).thenAnswer((_) async => mockHealthData);

        when(() => mockMapper.map(any())).thenReturn([
          TestDataFactory.createRawHealthDataPoint(type: 'STEPS', value: 750),
        ]);

        final firstResponse =
            await healthDataManager.processHealthDataRequest(request);

        clearInteractions(mockHealthClient);
        clearInteractions(mockMapper);

        final secondResponse =
            await healthDataManager.processHealthDataRequest(request);

        expect(identical(firstResponse, secondResponse), isTrue);
        verifyNever(
          () => mockHealthClient.getHealthDataFromTypes(
            types: any(named: 'types'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
          ),
        );
        verifyNever(() => mockMapper.map(any()));
      });

      test('evicts cache after ttl expires', () async {
        final baseTime = DateTime(2024, 1, 1, 12);
        var currentTime = baseTime;
        var fetchCallCount = 0;
        var mapCallCount = 0;

        healthDataManager = HealthDataManager(
          healthClient: mockHealthClient,
          aggregatePerSource: true,
          healthDataAggregator: mockAggregator,
          healthDataMapper: mockMapper,
          healthPermissionsGuard: mockPermissionsGuard,
          healthSleepSessionNormalizer: mockSleepNormalizer,
          nowProvider: () => currentTime,
        );

        final request = TestDataFactory.createHealthDataRequest(
          startTime: DateTime(2024, 1, 1),
          endTime: DateTime(2024, 1, 2),
        );

        when(
          () => mockHealthClient.getHealthDataFromTypes(
            types: any(named: 'types'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
          ),
        ).thenAnswer((_) async {
          fetchCallCount++;
          final steps = fetchCallCount == 1 ? 900 : 1200;
          return [
            TestHealthDataFactory.createStepsDataPoint(
              dateFrom: DateTime(2024, 1, 1, 8),
              dateTo: DateTime(2024, 1, 1, 9),
              steps: steps,
            ),
          ];
        });

        when(() => mockMapper.map(any())).thenAnswer((_) {
          mapCallCount++;
          final value = mapCallCount == 1 ? 900 : 1200;
          return [
            TestDataFactory.createRawHealthDataPoint(
              type: 'STEPS',
              value: value,
            ),
          ];
        });

        final firstResponse =
            await healthDataManager.processHealthDataRequest(request);
        expect(firstResponse.healthData.first.value, equals(900));

        currentTime = currentTime
            .add(Config.healthDataCacheTtl)
            .add(const Duration(minutes: 1));

        final secondResponse =
            await healthDataManager.processHealthDataRequest(request);

        expect(secondResponse.healthData.first.value, equals(1200));
        expect(fetchCallCount, equals(2));
        expect(mapCallCount, equals(2));
      });

      test('does not cache failed request', () async {
        final request = TestDataFactory.createHealthDataRequest(
          startTime: DateTime(2024, 1, 1),
          endTime: DateTime(2024, 1, 2),
        );

        var fetchCallCount = 0;

        when(
          () => mockHealthClient.getHealthDataFromTypes(
            types: any(named: 'types'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
          ),
        ).thenAnswer((_) async {
          fetchCallCount++;
          if (fetchCallCount == 1) {
            throw Exception('temporary failure');
          }
          return [
            TestHealthDataFactory.createStepsDataPoint(
              dateFrom: DateTime(2024, 1, 1, 8),
              dateTo: DateTime(2024, 1, 1, 9),
              steps: 1500,
            ),
          ];
        });

        when(() => mockMapper.map(any())).thenReturn([
          TestDataFactory.createRawHealthDataPoint(type: 'STEPS', value: 1500),
        ]);

        await TestUtils.expectAsyncThrows<HealthMcpServerException>(
          () => healthDataManager.processHealthDataRequest(request),
        );

        final response =
            await healthDataManager.processHealthDataRequest(request);

        expect(response.success, isTrue);
        expect(response.count, equals(1));
        expect(fetchCallCount, equals(2));
      });
    });

    group('Sleep Time Range Adjustment', () {
      test('adjusts time range for sleep data requests', () async {
        final originalStartTime = DateTime(2025, 10, 7, 0, 0, 0); // Oct 7 00:00
        final originalEndTime =
            DateTime(2025, 10, 7, 23, 59, 59); // Oct 7 23:59
        final request = TestDataFactory.createHealthDataRequest(
          valueType: VytalHealthDataCategory.SLEEP,
          startTime: originalStartTime,
          endTime: originalEndTime,
        );

        DateTime? capturedStartTime;
        DateTime? capturedEndTime;

        // Mock the sleep normalizer to return adjusted times for sleep data
        when(
          () => mockSleepNormalizer.adjustTimeRangeForSleepData(
            VytalHealthDataCategory.SLEEP,
            originalStartTime,
            originalEndTime,
          ),
        ).thenReturn(
          (
            startTime: DateTime(2025, 10, 6, 21, 0, 0), // Oct 6 21:00
            endTime: DateTime(2025, 10, 7, 12, 0, 0), // Oct 7 12:00
          ),
        );

        when(
          () => mockHealthClient.getHealthDataFromTypes(
            types: any(named: 'types'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
          ),
        ).thenAnswer((invocation) async {
          capturedStartTime = invocation.namedArguments[#startTime] as DateTime;
          capturedEndTime = invocation.namedArguments[#endTime] as DateTime;
          return [
            TestHealthDataFactory.createSleepDataPoint(
              dateFrom: DateTime(2025, 10, 6, 23, 0, 0), // Oct 6 23:00
              dateTo: DateTime(2025, 10, 7, 7, 0, 0), // Oct 7 07:00
            ),
          ];
        });

        when(() => mockMapper.map(any())).thenReturn([
          TestDataFactory.createRawHealthDataPoint(
            type: 'SLEEP_SESSION',
            value: 8.0,
          ),
        ]);

        await healthDataManager.processHealthDataRequest(request);

        // Verify that the time range was adjusted
        expect(capturedStartTime, equals(DateTime(2025, 10, 6, 21, 0, 0)));
        expect(capturedEndTime, equals(DateTime(2025, 10, 7, 12, 0, 0)));
      });

      test('does not adjust time range for non-sleep data requests', () async {
        final originalStartTime = DateTime(2025, 10, 7, 0, 0, 0);
        final originalEndTime = DateTime(2025, 10, 7, 23, 59, 59);
        final request = TestDataFactory.createHealthDataRequest(
          valueType: VytalHealthDataCategory.STEPS,
          startTime: originalStartTime,
          endTime: originalEndTime,
        );

        DateTime? capturedStartTime;
        DateTime? capturedEndTime;

        // Mock the sleep normalizer to return original times for non-sleep data
        when(
          () => mockSleepNormalizer.adjustTimeRangeForSleepData(
            VytalHealthDataCategory.STEPS,
            originalStartTime,
            originalEndTime,
          ),
        ).thenReturn(
          (
            startTime: originalStartTime,
            endTime: originalEndTime,
          ),
        );

        when(
          () => mockHealthClient.getHealthDataFromTypes(
            types: any(named: 'types'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
          ),
        ).thenAnswer((invocation) async {
          capturedStartTime = invocation.namedArguments[#startTime] as DateTime;
          capturedEndTime = invocation.namedArguments[#endTime] as DateTime;
          return [
            TestHealthDataFactory.createStepsDataPoint(
              dateFrom: DateTime(2025, 10, 7, 8, 0, 0),
              dateTo: DateTime(2025, 10, 7, 9, 0, 0),
              steps: 1000,
            ),
          ];
        });

        when(() => mockMapper.map(any())).thenReturn([
          TestDataFactory.createRawHealthDataPoint(type: 'STEPS', value: 1000),
        ]);

        await healthDataManager.processHealthDataRequest(request);

        // Verify that the time range was NOT adjusted
        expect(capturedStartTime, equals(originalStartTime));
        expect(capturedEndTime, equals(originalEndTime));
      });

      test('handles sleep data adjustment across month boundaries', () async {
        final originalStartTime =
            DateTime(2024, 11, 1, 0, 0, 0); // Nov 1 2024 00:00
        final originalEndTime =
            DateTime(2024, 11, 1, 23, 59, 59); // Nov 1 2024 23:59
        final request = TestDataFactory.createHealthDataRequest(
          valueType: VytalHealthDataCategory.SLEEP,
          startTime: originalStartTime,
          endTime: originalEndTime,
        );

        DateTime? capturedStartTime;
        DateTime? capturedEndTime;

        // Return adjusted times across month boundary
        when(
          () => mockSleepNormalizer.adjustTimeRangeForSleepData(
            VytalHealthDataCategory.SLEEP,
            originalStartTime,
            originalEndTime,
          ),
        ).thenReturn(
          (
            startTime: DateTime(2024, 10, 31, 21, 0, 0),
            endTime: DateTime(2024, 11, 1, 12, 0, 0),
          ),
        );

        when(
          () => mockHealthClient.getHealthDataFromTypes(
            types: any(named: 'types'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
          ),
        ).thenAnswer((invocation) async {
          capturedStartTime = invocation.namedArguments[#startTime] as DateTime;
          capturedEndTime = invocation.namedArguments[#endTime] as DateTime;
          return [];
        });

        when(() => mockMapper.map(any())).thenReturn([]);

        await healthDataManager.processHealthDataRequest(request);

        // Verify adjustment across month boundary
        expect(capturedStartTime, equals(DateTime(2024, 10, 31, 21, 0, 0)));
        expect(capturedEndTime, equals(DateTime(2024, 11, 1, 12, 0, 0)));
      });

      test('sleep data adjustment works with aggregation', () async {
        final originalStartTime = DateTime(2024, 10, 7, 0, 0, 0);
        final originalEndTime = DateTime(2024, 10, 7, 23, 59, 59);
        final request = TestDataFactory.createHealthDataRequest(
          valueType: VytalHealthDataCategory.SLEEP,
          startTime: originalStartTime,
          endTime: originalEndTime,
          groupBy: TimeGroupBy.day,
          statistic: StatisticType.sum,
        );

        DateTime? capturedStartTime;
        DateTime? capturedEndTime;

        // Return adjusted times for sleep data with aggregation
        when(
          () => mockSleepNormalizer.adjustTimeRangeForSleepData(
            VytalHealthDataCategory.SLEEP,
            originalStartTime,
            originalEndTime,
          ),
        ).thenReturn(
          (
            startTime: DateTime(2024, 10, 6, 21, 0, 0),
            endTime: DateTime(2024, 10, 7, 12, 0, 0),
          ),
        );

        when(
          () => mockHealthClient.getHealthDataFromTypes(
            types: any(named: 'types'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
          ),
        ).thenAnswer((invocation) async {
          capturedStartTime = invocation.namedArguments[#startTime] as DateTime;
          capturedEndTime = invocation.namedArguments[#endTime] as DateTime;
          return [
            TestHealthDataFactory.createSleepDataPoint(
              dateFrom: DateTime(2024, 10, 6, 23, 0, 0),
              dateTo: DateTime(2024, 10, 7, 7, 0, 0),
            ),
          ];
        });

        when(() => mockMapper.map(any())).thenReturn([
          TestDataFactory.createRawHealthDataPoint(
            type: 'SLEEP_SESSION',
            value: 8.0,
          ),
        ]);

        when(() => mockAggregator.aggregate(any())).thenReturn([
          TestDataFactory.createAggregatedHealthDataPoint(
            type: 'SLEEP_SESSION',
            value: 8.0,
          ) as AggregatedHealthDataPoint,
        ]);

        await healthDataManager.processHealthDataRequest(request);

        // Verify time adjustment also works with aggregation
        expect(capturedStartTime, equals(DateTime(2024, 10, 6, 21, 0, 0)));
        expect(capturedEndTime, equals(DateTime(2024, 10, 7, 12, 0, 0)));
      });
    });
  });
}
