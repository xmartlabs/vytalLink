import 'package:flutter_template/core/health/health_data_aggregator.dart';
import 'package:flutter_template/core/health/health_data_mapper.dart';
import 'package:flutter_template/core/health/health_permissions_guard.dart';
import 'package:flutter_template/core/health/health_sleep_session_normalizer.dart';
import 'package:flutter_template/core/model/health_data_point.dart';
import 'package:flutter_template/core/model/statistic_types.dart';
import 'package:flutter_template/core/model/time_group_by.dart';
import 'package:flutter_template/core/service/health_data_manager.dart';
import 'package:flutter_template/core/source/mcp_server.dart';
import 'package:flutter_template/model/vytal_health_data_category.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health/health.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mock_health_client.dart';
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
        startTime: DateTime(2024, 1, 1),
        endTime: DateTime(2024, 1, 2),
        aggregatePerSource: false,
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
    });
  });
}
