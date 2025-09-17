import 'package:flutter_template/core/common/config.dart';
import 'package:flutter_template/core/health/health_data_aggregator.dart';
import 'package:flutter_template/core/health/health_data_mapper.dart';
import 'package:flutter_template/core/health/health_permissions_guard.dart';
import 'package:flutter_template/core/model/health_data_request.dart';
import 'package:flutter_template/core/model/statistic_types.dart';
import 'package:flutter_template/core/model/time_group_by.dart';
import 'package:flutter_template/core/service/health_data_manager.dart';
import 'package:flutter_template/core/source/mcp_server.dart';
import 'package:flutter_template/model/vytal_health_data_category.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health/health.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/mock_health_client.dart';
import '../test_utils.dart';

/// Integration tests for the complete health data processing flow
/// These tests verify that all components work together correctly
void main() {
  group('Health Data Flow Integration Tests', () {
    late MockHealth mockHealthClient;
    late HealthDataManager healthDataManager;
    late HealthMcpServerService mcpServer;

    setUpAll(() {
      // Initialize Config values for integration tests
      Config.wsUrl = 'ws://test-server:8080/ws';
      Config.gptIntegrationUrl = 'https://test-gpt-api.com';
      Config.appDirectoryPath = '/test/path';
      Config.landingUrl = 'https://test-landing.com';
      Config.testingMode = true;
    });

    setUp(() {
      mockHealthClient = MockHealth();

      // Create real instances of components to test integration
      const healthDataAggregator = HealthDataAggregator();
      const healthDataMapper = HealthDataMapper();
      const healthPermissionsGuard = HealthPermissionsGuard();

      healthDataManager = HealthDataManager(
        healthClient: mockHealthClient,
        healthDataAggregator: healthDataAggregator,
        healthDataMapper: healthDataMapper,
        healthPermissionsGuard: healthPermissionsGuard,
      );

      const config = HealthMcpServerConfig(
        serverName: 'Test Server',
        serverVersion: '1.0.0',
        host: '127.0.0.1',
        port: 8080,
        endpoint: '/test',
      );

      mcpServer = HealthMcpServerService(
        config: config,
        healthDataManager: healthDataManager,
      );

      when(
        () => mockHealthClient.hasPermissions(
          any(),
          permissions: any(named: 'permissions'),
        ),
      ).thenAnswer((_) async => true);

      when(() => mockHealthClient.isHealthDataHistoryAuthorized())
          .thenAnswer((_) async => true);
    });

    group('End-to-End Data Processing', () {
      test('processes steps data request successfully', () async {
        final request = HealthDataRequest(
          valueType: VytalHealthDataCategory.STEPS,
          startTime: DateTime(2024, 1, 1),
          endTime: DateTime(2024, 1, 2),
        );

        final mockHealthData = [
          TestHealthDataFactory.createStepsDataPoint(
            dateFrom: DateTime(2024, 1, 1, 10),
            dateTo: DateTime(2024, 1, 1, 11),
            steps: 1000,
            sourceId: 'phone',
          ),
          TestHealthDataFactory.createStepsDataPoint(
            dateFrom: DateTime(2024, 1, 1, 14),
            dateTo: DateTime(2024, 1, 1, 15),
            steps: 1500,
            sourceId: 'watch',
          ),
        ];

        when(
          () => mockHealthClient.getHealthDataFromTypes(
            types: any(named: 'types'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
          ),
        ).thenAnswer((_) async => mockHealthData);

        final response =
            await healthDataManager.processHealthDataRequest(request);

        expect(response.success, isTrue);
        expect(response.count, equals(2));
        expect(response.valueType, equals('STEPS'));
        expect(response.healthData.length, equals(2));
        expect(response.healthData[0].value, equals(1000));
        expect(response.healthData[1].value, equals(1500));
      });

      test('processes aggregated steps data with daily grouping', () async {
        final request = HealthDataRequest(
          valueType: VytalHealthDataCategory.STEPS,
          startTime: DateTime(2024, 1, 1),
          endTime: DateTime(2024, 1, 3),
          groupBy: TimeGroupBy.day,
          statistic: StatisticType.sum,
        );

        final mockHealthData = [
          // Day 1 data
          TestHealthDataFactory.createStepsDataPoint(
            dateFrom: DateTime(2024, 1, 1, 10),
            dateTo: DateTime(2024, 1, 1, 11),
            steps: 1000,
            sourceId: 'phone',
          ),
          TestHealthDataFactory.createStepsDataPoint(
            dateFrom: DateTime(2024, 1, 1, 14),
            dateTo: DateTime(2024, 1, 1, 15),
            steps: 1500,
            sourceId: 'phone',
          ),
          // Day 2 data
          TestHealthDataFactory.createStepsDataPoint(
            dateFrom: DateTime(2024, 1, 2, 9),
            dateTo: DateTime(2024, 1, 2, 10),
            steps: 2000,
            sourceId: 'phone',
          ),
        ];

        when(
          () => mockHealthClient.getHealthDataFromTypes(
            types: any(named: 'types'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
          ),
        ).thenAnswer((_) async => mockHealthData);

        final response =
            await healthDataManager.processHealthDataRequest(request);

        expect(response.success, isTrue);
        expect(response.isAggregated, isTrue);
        expect(response.groupBy, equals('day'));
        expect(response.statisticType, equals('sum'));
        expect(response.healthData.length, equals(2)); // 2 days with data

        // Verify aggregated values
        final day1Data = response.healthData.firstWhere(
          (data) => data.dateFrom.startsWith('2024-01-01'),
        );
        final day2Data = response.healthData.firstWhere(
          (data) => data.dateFrom.startsWith('2024-01-02'),
        );

        expect(day1Data.value, equals(2500.0)); // 1000 + 1500
        expect(day2Data.value, equals(2000.0));
      });

      test('processes heart rate data with hourly average', () async {
        final request = HealthDataRequest(
          valueType: VytalHealthDataCategory.HEART_RATE,
          startTime: DateTime(2024, 1, 1, 10),
          endTime: DateTime(2024, 1, 1, 12),
          groupBy: TimeGroupBy.hour,
          statistic: StatisticType.average,
        );

        final mockHealthData = [
          TestHealthDataFactory.createHeartRateDataPoint(
            dateFrom: DateTime(2024, 1, 1, 10, 15),
            dateTo: DateTime(2024, 1, 1, 10, 15),
            heartRate: 80.0,
          ),
          TestHealthDataFactory.createHeartRateDataPoint(
            dateFrom: DateTime(2024, 1, 1, 10, 45),
            dateTo: DateTime(2024, 1, 1, 10, 45),
            heartRate: 90.0,
          ),
          TestHealthDataFactory.createHeartRateDataPoint(
            dateFrom: DateTime(2024, 1, 1, 11, 30),
            dateTo: DateTime(2024, 1, 1, 11, 30),
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

        final response =
            await healthDataManager.processHealthDataRequest(request);

        expect(response.success, isTrue);
        expect(response.isAggregated, isTrue);
        expect(response.groupBy, equals('hour'));
        expect(response.statisticType, equals('average'));
        expect(response.healthData.length, equals(1)); // Aggregated data points

        // Find the aggregated data (might be combined or filtered)
        final aggregatedData = response.healthData.first;

        expect(aggregatedData.value, isA<double>());
        expect(aggregatedData.value, greaterThan(0));
      });

      test('handles permission denial gracefully', () async {
        final request = HealthDataRequest(
          valueType: VytalHealthDataCategory.STEPS,
          startTime: DateTime(2024, 1, 1),
          endTime: DateTime(2024, 1, 2),
        );

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
        ).thenAnswer((_) async => false);

        await TestUtils.expectAsyncThrows<HealthMcpServerException>(
          () => healthDataManager.processHealthDataRequest(request),
        );
      });

      test('handles empty health data gracefully', () async {
        final request = HealthDataRequest(
          valueType: VytalHealthDataCategory.STEPS,
          startTime: DateTime(2024, 1, 1),
          endTime: DateTime(2024, 1, 2),
        );

        when(
          () => mockHealthClient.getHealthDataFromTypes(
            types: any(named: 'types'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
          ),
        ).thenAnswer((_) async => <HealthDataPoint>[]);

        final response =
            await healthDataManager.processHealthDataRequest(request);

        expect(response.success, isTrue);
        expect(response.count, equals(0));
        expect(response.healthData, isEmpty);
      });
    });

    group('MCP Server Integration', () {
      test('handles health data request message end-to-end', () async {
        final requestMessage = {
          'type': 'health_data_request',
          'id': 'test-123',
          'payload': {
            'value_type': 'STEPS',
            'start_time': '2024-01-01T00:00:00Z',
            'end_time': '2024-01-02T00:00:00Z',
          },
        };

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

        final responseJson = await mcpServer.handleHealthDataRequest(
          HealthDataRequest.fromJson(
            requestMessage['payload']! as Map<String, dynamic>,
          ),
        );

        expect(responseJson['success'], isTrue);
        expect(responseJson['count'], equals(1));
        expect(responseJson['value_type'], equals('STEPS'));
        expect(responseJson['health_data'], isA<List>());
        expect(responseJson['health_data'].length, equals(1));
      });

      test('handles invalid health data request gracefully', () async {
        final invalidRequest = HealthDataRequest(
          valueType: VytalHealthDataCategory.STEPS,
          startTime: DateTime(2024, 1, 2), // End before start
          endTime: DateTime(2024, 1, 1),
        );

        final responseJson =
            await mcpServer.handleHealthDataRequest(invalidRequest);

        expect(responseJson['success'], isFalse);
        expect(responseJson['error_message'], isA<String>());
        expect(responseJson['error_message'], isNotEmpty);
      });

      test('handles health client exceptions in MCP context', () async {
        final request = HealthDataRequest(
          valueType: VytalHealthDataCategory.STEPS,
          startTime: DateTime(2024, 1, 1),
          endTime: DateTime(2024, 1, 2),
        );

        when(
          () => mockHealthClient.getHealthDataFromTypes(
            types: any(named: 'types'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
          ),
        ).thenThrow(Exception('Health client error'));

        final responseJson = await mcpServer.handleHealthDataRequest(request);

        expect(responseJson['success'], isFalse);
        expect(responseJson['error_message'], contains('Health client error'));
      });
    });

    group('Complex Scenarios', () {
      test('processes multi-source aggregated data correctly', () async {
        final request = HealthDataRequest(
          valueType: VytalHealthDataCategory.STEPS,
          startTime: DateTime(2024, 1, 1),
          endTime: DateTime(2024, 1, 2),
          groupBy: TimeGroupBy.day,
          statistic: StatisticType.sum,
        );

        final mockHealthData = [
          TestHealthDataFactory.createStepsDataPoint(
            dateFrom: DateTime(2024, 1, 1, 10),
            dateTo: DateTime(2024, 1, 1, 11),
            steps: 1000,
            sourceId: 'phone',
          ),
          TestHealthDataFactory.createStepsDataPoint(
            dateFrom: DateTime(2024, 1, 1, 10),
            dateTo: DateTime(2024, 1, 1, 11),
            steps: 500,
            sourceId: 'watch',
          ),
          TestHealthDataFactory.createStepsDataPoint(
            dateFrom: DateTime(2024, 1, 1, 14),
            dateTo: DateTime(2024, 1, 1, 15),
            steps: 2000,
            sourceId: 'phone',
          ),
        ];

        when(
          () => mockHealthClient.getHealthDataFromTypes(
            types: any(named: 'types'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
          ),
        ).thenAnswer((_) async => mockHealthData);

        final response =
            await healthDataManager.processHealthDataRequest(request);

        expect(response.success, isTrue);
        expect(response.isAggregated, isTrue);
        expect(response.healthData.length, equals(2));

        final totalValue = response.healthData
            .map((data) => data.value as double)
            .reduce((a, b) => a + b);
        expect(totalValue, equals(3500.0));
      });

      test('handles cross-day data aggregation correctly', () async {
        final request = HealthDataRequest(
          valueType: VytalHealthDataCategory.STEPS,
          startTime: DateTime(2024, 1, 1, 22), // Start late in day 1
          endTime: DateTime(2024, 1, 2, 2), // End early in day 2
          groupBy: TimeGroupBy.hour,
          statistic: StatisticType.sum,
        );

        final mockHealthData = [
          TestHealthDataFactory.createStepsDataPoint(
            dateFrom: DateTime(2024, 1, 1, 22, 30),
            dateTo: DateTime(2024, 1, 1, 22, 45),
            steps: 500,
          ),
          TestHealthDataFactory.createStepsDataPoint(
            dateFrom: DateTime(2024, 1, 1, 23, 15),
            dateTo: DateTime(2024, 1, 1, 23, 30),
            steps: 300,
          ),
          TestHealthDataFactory.createStepsDataPoint(
            dateFrom: DateTime(2024, 1, 2, 1, 15),
            dateTo: DateTime(2024, 1, 2, 1, 30),
            steps: 200,
          ),
        ];

        when(
          () => mockHealthClient.getHealthDataFromTypes(
            types: any(named: 'types'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
          ),
        ).thenAnswer((_) async => mockHealthData);

        final response =
            await healthDataManager.processHealthDataRequest(request);

        expect(response.success, isTrue);
        expect(response.isAggregated, isTrue);
        expect(response.healthData.length, equals(3)); // 3 hours with data

        // Verify data is properly distributed across hour boundaries
        final totalSteps = response.healthData
            .map((data) => data.value as double)
            .reduce((a, b) => a + b);
        expect(totalSteps, equals(1000.0)); // 500 + 300 + 200
      });

      test('handles overlapping time ranges in aggregation', () async {
        final request = HealthDataRequest(
          valueType: VytalHealthDataCategory.DISTANCE,
          startTime: DateTime(2024, 1, 1, 10),
          endTime: DateTime(2024, 1, 1, 12),
          groupBy: TimeGroupBy.hour,
          statistic: StatisticType.sum,
        );

        final mockHealthData = [
          TestHealthDataFactory.createDistanceDataPoint(
            dateFrom: DateTime(2024, 1, 1, 10, 30),
            dateTo: DateTime(2024, 1, 1, 11, 30), // Spans two hours
            distance: 1000.0, // 1km
          ),
        ];

        when(
          () => mockHealthClient.getHealthDataFromTypes(
            types: any(named: 'types'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
          ),
        ).thenAnswer((_) async => mockHealthData);

        final response =
            await healthDataManager.processHealthDataRequest(request);

        expect(response.success, isTrue);
        expect(response.isAggregated, isTrue);

        // Should properly handle proportional allocation across hours
        expect(response.healthData.length, greaterThan(0));

        final totalDistance = response.healthData
            .map((data) => data.value as double)
            .reduce((a, b) => a + b);
        expect(
          totalDistance,
          closeTo(1000.0, 1.0),
        ); // Allow small floating point variance
      });
    });

    group('Error Recovery', () {
      test('recovers from transient health client errors', () async {
        final request = HealthDataRequest(
          valueType: VytalHealthDataCategory.STEPS,
          startTime: DateTime(2024, 1, 1),
          endTime: DateTime(2024, 1, 2),
        );

        var callCount = 0;
        when(
          () => mockHealthClient.getHealthDataFromTypes(
            types: any(named: 'types'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
          ),
        ).thenAnswer((_) async {
          callCount++;
          if (callCount == 1) {
            throw Exception('Transient error');
          }
          return [
            TestHealthDataFactory.createStepsDataPoint(
              dateFrom: DateTime(2024, 1, 1, 10),
              dateTo: DateTime(2024, 1, 1, 11),
              steps: 1000,
            ),
          ];
        });

        await TestUtils.expectAsyncThrows<HealthMcpServerException>(
          () => healthDataManager.processHealthDataRequest(request),
        );

        final response =
            await healthDataManager.processHealthDataRequest(request);

        expect(response.success, isTrue);
        expect(response.count, equals(1));
        expect(callCount, equals(2));
      });

      test('handles malformed health data gracefully', () async {
        final request = HealthDataRequest(
          valueType: VytalHealthDataCategory.STEPS,
          startTime: DateTime(2024, 1, 1),
          endTime: DateTime(2024, 1, 2),
        );

        final mockHealthData = [
          TestHealthDataFactory.createStepsDataPoint(
            dateFrom: DateTime(2024, 1, 1, 10),
            dateTo: DateTime(2024, 1, 1, 9), // End before start (unusual)
            steps: -500, // Negative steps (unusual)
          ),
        ];

        when(
          () => mockHealthClient.getHealthDataFromTypes(
            types: any(named: 'types'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
          ),
        ).thenAnswer((_) async => mockHealthData);

        final response =
            await healthDataManager.processHealthDataRequest(request);

        expect(response.success, isTrue);
        expect(response.count, equals(1));
        expect(response.healthData.first.value, equals(-500));
      });
    });
  });
}
