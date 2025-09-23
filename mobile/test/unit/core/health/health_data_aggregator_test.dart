import 'package:flutter_template/core/health/health_data_aggregator.dart';
import 'package:flutter_template/core/model/health_data_point.dart';
import 'package:flutter_template/core/model/statistic_types.dart';
import 'package:flutter_template/core/model/time_group_by.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../helpers/test_data_factory.dart';
import '../../../test_utils.dart';

void main() {
  group('HealthDataAggregator', () {
    late HealthDataAggregator aggregator;

    setUp(() {
      aggregator = const HealthDataAggregator();
    });

    group('aggregate', () {
      test('returns empty list when no data provided', () {
        final request = (
          data: <AppHealthDataPoint>[],
          groupBy: TimeGroupBy.day,
          startTime: DateTime(2024, 1, 1),
          endTime: DateTime(2024, 1, 2),
          aggregatePerSource: false,
          statisticType: StatisticType.sum,
        );

        final result = aggregator.aggregate(request);

        expect(result, isEmpty);
      });

      test('aggregates data by day correctly', () {
        final startTime = DateTime(2024, 1, 1);
        final endTime = DateTime(2024, 1, 3);

        final data = [
          TestDataFactory.createRawHealthDataPoint(
            type: 'STEPS',
            value: 1000,
            dateFrom: DateTime(2024, 1, 1, 10),
            dateTo: DateTime(2024, 1, 1, 11),
            sourceId: 'source-1',
          ),
          TestDataFactory.createRawHealthDataPoint(
            type: 'STEPS',
            value: 2000,
            dateFrom: DateTime(2024, 1, 1, 14),
            dateTo: DateTime(2024, 1, 1, 15),
            sourceId: 'source-1',
          ),
          TestDataFactory.createRawHealthDataPoint(
            type: 'STEPS',
            value: 1500,
            dateFrom: DateTime(2024, 1, 2, 10),
            dateTo: DateTime(2024, 1, 2, 11),
            sourceId: 'source-1',
          ),
        ];

        final request = (
          data: data,
          groupBy: TimeGroupBy.day,
          startTime: startTime,
          endTime: endTime,
          aggregatePerSource: false,
          statisticType: StatisticType.sum,
        );

        final result = aggregator.aggregate(request);

        expect(result.length, equals(2)); // 2 days

        // Check first day aggregation
        final day1Result = result.firstWhere(
          (point) => point.dateFrom == '2024-01-01T00:00:00.000',
        );
        expect(day1Result.value, equals(3000.0)); // 1000 + 2000
        expect(day1Result.type, equals('STEPS'));

        // Check second day aggregation
        final day2Result = result.firstWhere(
          (point) => point.dateFrom == '2024-01-02T00:00:00.000',
        );
        expect(day2Result.value, equals(1500.0));
      });

      test('aggregates data by hour correctly', () {
        final startTime = DateTime(2024, 1, 1, 10);
        final endTime = DateTime(2024, 1, 1, 13);

        final data = [
          TestDataFactory.createRawHealthDataPoint(
            type: 'STEPS',
            value: 500,
            dateFrom: DateTime(2024, 1, 1, 10, 15),
            dateTo: DateTime(2024, 1, 1, 10, 30),
            sourceId: 'source-1',
          ),
          TestDataFactory.createRawHealthDataPoint(
            type: 'STEPS',
            value: 300,
            dateFrom: DateTime(2024, 1, 1, 10, 45),
            dateTo: DateTime(2024, 1, 1, 11, 0),
            sourceId: 'source-1',
          ),
          TestDataFactory.createRawHealthDataPoint(
            type: 'STEPS',
            value: 700,
            dateFrom: DateTime(2024, 1, 1, 11, 30),
            dateTo: DateTime(2024, 1, 1, 11, 45),
            sourceId: 'source-1',
          ),
        ];

        final request = (
          data: data,
          groupBy: TimeGroupBy.hour,
          startTime: startTime,
          endTime: endTime,
          aggregatePerSource: false,
          statisticType: StatisticType.sum,
        );

        final result = aggregator.aggregate(request);

        expect(result.length, equals(2));

        // Check 10:00-11:00 hour
        final hour10Result = result.firstWhere(
          (point) => point.dateFrom == '2024-01-01T10:00:00.000',
        );
        expect(hour10Result.value, equals(800.0));

        // Check 11:00-12:00 hour
        final hour11Result = result.firstWhere(
          (point) => point.dateFrom == '2024-01-01T11:00:00.000',
        );
        expect(hour11Result.value, equals(700.0));
      });

      test('aggregates per source when enabled', () {
        final startTime = DateTime(2024, 1, 1);
        final endTime = DateTime(2024, 1, 2);

        final data = [
          TestDataFactory.createRawHealthDataPoint(
            type: 'STEPS',
            value: 1000,
            dateFrom: DateTime(2024, 1, 1, 10),
            dateTo: DateTime(2024, 1, 1, 11),
            sourceId: 'source-1',
          ),
          TestDataFactory.createRawHealthDataPoint(
            type: 'STEPS',
            value: 500,
            dateFrom: DateTime(2024, 1, 1, 10),
            dateTo: DateTime(2024, 1, 1, 11),
            sourceId: 'source-2',
          ),
        ];

        final request = (
          data: data,
          groupBy: TimeGroupBy.day,
          startTime: startTime,
          endTime: endTime,
          aggregatePerSource: true,
          statisticType: StatisticType.sum,
        );

        final result = aggregator.aggregate(request);

        expect(result.length, equals(2)); // 2 sources

        final source1Result = result.firstWhere(
          (point) => point.sourceId == 'source-1',
        );
        expect(source1Result.value, equals(1000.0));

        final source2Result = result.firstWhere(
          (point) => point.sourceId == 'source-2',
        );
        expect(source2Result.value, equals(500.0));
      });

      test('combines sources when aggregatePerSource is false', () {
        final startTime = DateTime(2024, 1, 1);
        final endTime = DateTime(2024, 1, 2);

        final data = [
          TestDataFactory.createRawHealthDataPoint(
            type: 'STEPS',
            value: 1000,
            dateFrom: DateTime(2024, 1, 1, 10),
            dateTo: DateTime(2024, 1, 1, 11),
            sourceId: 'source-1',
          ),
          TestDataFactory.createRawHealthDataPoint(
            type: 'STEPS',
            value: 500,
            dateFrom: DateTime(2024, 1, 1, 10),
            dateTo: DateTime(2024, 1, 1, 11),
            sourceId: 'source-2',
          ),
        ];

        final request = (
          data: data,
          groupBy: TimeGroupBy.day,
          startTime: startTime,
          endTime: endTime,
          aggregatePerSource: false,
          statisticType: StatisticType.sum,
        );

        final result = aggregator.aggregate(request);

        expect(result.length, equals(1)); // Combined result
        expect(result.first.value, equals(1500.0)); // 1000 + 500
        expect(result.first.sourceId, isNull);
      });

      test('handles weekly aggregation correctly', () {
        final startTime = DateTime(2024, 1, 1); // Monday
        final endTime = DateTime(2024, 1, 15);

        final data = [
          TestDataFactory.createRawHealthDataPoint(
            type: 'STEPS',
            value: 1000,
            dateFrom: DateTime(2024, 1, 2), // Tuesday of first week
            dateTo: DateTime(2024, 1, 2, 1),
            sourceId: 'source-1',
          ),
          TestDataFactory.createRawHealthDataPoint(
            type: 'STEPS',
            value: 2000,
            dateFrom: DateTime(2024, 1, 8), // Monday of second week
            dateTo: DateTime(2024, 1, 8, 1),
            sourceId: 'source-1',
          ),
        ];

        final request = (
          data: data,
          groupBy: TimeGroupBy.week,
          startTime: startTime,
          endTime: endTime,
          aggregatePerSource: false,
          statisticType: StatisticType.sum,
        );

        final result = aggregator.aggregate(request);

        expect(result.length, equals(2)); // 2 weeks

        // Check first week
        final week1Result = result.firstWhere(
          (point) => point.dateFrom == '2024-01-01T00:00:00.000',
        );
        expect(week1Result.value, equals(1000.0));

        // Check second week
        final week2Result = result.firstWhere(
          (point) => point.dateFrom == '2024-01-08T00:00:00.000',
        );
        expect(week2Result.value, equals(2000.0));
      });

      test('handles monthly aggregation correctly', () {
        final startTime = DateTime(2024, 1, 1);
        final endTime = DateTime(2024, 3, 1);

        final data = [
          TestDataFactory.createRawHealthDataPoint(
            type: 'STEPS',
            value: 1000,
            dateFrom: DateTime(2024, 1, 15),
            dateTo: DateTime(2024, 1, 15, 1),
            sourceId: 'source-1',
          ),
          TestDataFactory.createRawHealthDataPoint(
            type: 'STEPS',
            value: 2000,
            dateFrom: DateTime(2024, 2, 15),
            dateTo: DateTime(2024, 2, 15, 1),
            sourceId: 'source-1',
          ),
        ];

        final request = (
          data: data,
          groupBy: TimeGroupBy.month,
          startTime: startTime,
          endTime: endTime,
          aggregatePerSource: false,
          statisticType: StatisticType.sum,
        );

        final result = aggregator.aggregate(request);

        expect(result.length, equals(2)); // 2 months

        // Check January
        final janResult = result.firstWhere(
          (point) => point.dateFrom == '2024-01-01T00:00:00.000',
        );
        expect(janResult.value, equals(1000.0));

        // Check February
        final febResult = result.firstWhere(
          (point) => point.dateFrom == '2024-02-01T00:00:00.000',
        );
        expect(febResult.value, equals(2000.0));
      });
    });

    group('cumulative data aggregation', () {
      test('handles overlapping cumulative data correctly', () {
        final startTime = DateTime(2024, 1, 1, 10);
        final endTime = DateTime(2024, 1, 1, 14);

        final data = [
          TestDataFactory.createRawHealthDataPoint(
            type: 'DISTANCE_DELTA',
            value: 1000.0, // 1000m over 2 hours
            dateFrom: DateTime(2024, 1, 1, 10),
            dateTo: DateTime(2024, 1, 1, 12),
            sourceId: 'source-1',
          ),
          TestDataFactory.createRawHealthDataPoint(
            type: 'DISTANCE_DELTA',
            value: 500.0, // 500m over 1 hour, overlapping
            dateFrom: DateTime(2024, 1, 1, 11),
            dateTo: DateTime(2024, 1, 1, 12),
            sourceId: 'source-2',
          ),
        ];

        final request = (
          data: data,
          groupBy: TimeGroupBy.hour,
          startTime: startTime,
          endTime: endTime,
          aggregatePerSource: false,
          statisticType: StatisticType.sum,
        );

        final result = aggregator.aggregate(request);

        // Should have proper proportional allocation
        expect(result.length, greaterThan(0));

        // Verify that overlapping periods are handled proportionally
        final hour11Result = result.firstWhere(
          (point) => point.dateFrom == '2024-01-01T11:00:00.000',
          orElse: () => throw StateError('Hour 11 result not found'),
        );

        // Hour 11-12 should have: 500m (half of first data point) + 500m
        // (full second data point)
        expect(
          hour11Result.value,
          HealthDataMatchers.hasAggregatedValue(1000.0),
        );
      });

      test('handles partial overlap correctly', () {
        final startTime = DateTime(2024, 1, 1, 10);
        final endTime = DateTime(2024, 1, 1, 12);

        final data = [
          TestDataFactory.createRawHealthDataPoint(
            type: 'DISTANCE_DELTA',
            value: 600.0, // 600m over 3 hours (9-12), but we only query 10-12
            dateFrom: DateTime(2024, 1, 1, 9),
            dateTo: DateTime(2024, 1, 1, 12),
            sourceId: 'source-1',
          ),
        ];

        final request = (
          data: data,
          groupBy: TimeGroupBy.hour,
          startTime: startTime,
          endTime: endTime,
          aggregatePerSource: false,
          statisticType: StatisticType.sum,
        );

        final result = aggregator.aggregate(request);

        // Should only get 2/3 of the total value (2 hours out of 3)
        final totalValue =
            result.fold<double>(0.0, (sum, point) => sum + point.value);
        expect(
          totalValue,
          HealthDataMatchers.hasAggregatedValue(400.0),
        ); // 2/3 * 600
      });
    });

    group('instantaneous data aggregation', () {
      test('averages instantaneous data within time segments', () {
        final startTime = DateTime(2024, 1, 1, 10);
        final endTime = DateTime(2024, 1, 1, 12);

        final data = [
          TestDataFactory.createRawHealthDataPoint(
            type: 'HEART_RATE',
            value: 80.0,
            dateFrom: DateTime(2024, 1, 1, 10, 15),
            dateTo: DateTime(2024, 1, 1, 10, 15),
            sourceId: 'source-1',
          ),
          TestDataFactory.createRawHealthDataPoint(
            type: 'HEART_RATE',
            value: 90.0,
            dateFrom: DateTime(2024, 1, 1, 10, 45),
            dateTo: DateTime(2024, 1, 1, 10, 45),
            sourceId: 'source-1',
          ),
          TestDataFactory.createRawHealthDataPoint(
            type: 'HEART_RATE',
            value: 85.0,
            dateFrom: DateTime(2024, 1, 1, 11, 30),
            dateTo: DateTime(2024, 1, 1, 11, 30),
            sourceId: 'source-1',
          ),
        ];

        final request = (
          data: data,
          groupBy: TimeGroupBy.hour,
          startTime: startTime,
          endTime: endTime,
          aggregatePerSource: false,
          statisticType: StatisticType.average,
        );

        final result = aggregator.aggregate(request);

        expect(result.length, equals(2));

        // Hour 10-11 should average 80 and 90
        final hour10Result = result.firstWhere(
          (point) => point.dateFrom == '2024-01-01T10:00:00.000',
        );
        expect(
          hour10Result.value,
          HealthDataMatchers.hasAggregatedValue(85.0),
        ); // (80+90)/2

        // Hour 11-12 should just be 85
        final hour11Result = result.firstWhere(
          (point) => point.dateFrom == '2024-01-01T11:00:00.000',
        );
        expect(hour11Result.value, HealthDataMatchers.hasAggregatedValue(85.0));
      });

      test('aggregates HEART_RATE data by day correctly', () {
        final startTime = DateTime(2024, 1, 1);
        final endTime = DateTime(2024, 1, 8); // One week

        final data = [
          // Day 1: Heart rates 70, 80, 90 -> Average = 80
          TestDataFactory.createRawHealthDataPoint(
            type: 'HEART_RATE',
            value: 70.0,
            dateFrom: DateTime(2024, 1, 1, 8),
            dateTo: DateTime(2024, 1, 1, 8),
            sourceId: 'source-1',
          ),
          TestDataFactory.createRawHealthDataPoint(
            type: 'HEART_RATE',
            value: 80.0,
            dateFrom: DateTime(2024, 1, 1, 12),
            dateTo: DateTime(2024, 1, 1, 12),
            sourceId: 'source-1',
          ),
          TestDataFactory.createRawHealthDataPoint(
            type: 'HEART_RATE',
            value: 90.0,
            dateFrom: DateTime(2024, 1, 1, 18),
            dateTo: DateTime(2024, 1, 1, 18),
            sourceId: 'source-1',
          ),

          // Day 2: Heart rates 75, 85 -> Average = 80
          TestDataFactory.createRawHealthDataPoint(
            type: 'HEART_RATE',
            value: 75.0,
            dateFrom: DateTime(2024, 1, 2, 9),
            dateTo: DateTime(2024, 1, 2, 9),
            sourceId: 'source-1',
          ),
          TestDataFactory.createRawHealthDataPoint(
            type: 'HEART_RATE',
            value: 85.0,
            dateFrom: DateTime(2024, 1, 2, 15),
            dateTo: DateTime(2024, 1, 2, 15),
            sourceId: 'source-1',
          ),

          // Day 3: Heart rate 65 -> Average = 65
          TestDataFactory.createRawHealthDataPoint(
            type: 'HEART_RATE',
            value: 65.0,
            dateFrom: DateTime(2024, 1, 3, 14),
            dateTo: DateTime(2024, 1, 3, 14),
            sourceId: 'source-1',
          ),

          // Day 5: Heart rates 95, 100 -> Average = 97.5
          // (skip day 4 to test gaps)
          TestDataFactory.createRawHealthDataPoint(
            type: 'HEART_RATE',
            value: 95.0,
            dateFrom: DateTime(2024, 1, 5, 10),
            dateTo: DateTime(2024, 1, 5, 10),
            sourceId: 'source-1',
          ),
          TestDataFactory.createRawHealthDataPoint(
            type: 'HEART_RATE',
            value: 100.0,
            dateFrom: DateTime(2024, 1, 5, 16),
            dateTo: DateTime(2024, 1, 5, 16),
            sourceId: 'source-1',
          ),
        ];

        final request = (
          data: data,
          groupBy: TimeGroupBy.day,
          startTime: startTime,
          endTime: endTime,
          aggregatePerSource: false,
          statisticType: StatisticType.average,
        );

        final result = aggregator.aggregate(request);

        expect(result.length, equals(4)); // Only days with data

        // Day 1: Average of 70, 80, 90 = 80.0
        final day1Result = result.firstWhere(
          (point) => point.dateFrom == '2024-01-01T00:00:00.000',
        );
        expect(day1Result.value, HealthDataMatchers.hasAggregatedValue(80.0));

        // Day 2: Average of 75, 85 = 80.0
        final day2Result = result.firstWhere(
          (point) => point.dateFrom == '2024-01-02T00:00:00.000',
        );
        expect(day2Result.value, HealthDataMatchers.hasAggregatedValue(80.0));

        // Day 3: Average of 65 = 65.0
        final day3Result = result.firstWhere(
          (point) => point.dateFrom == '2024-01-03T00:00:00.000',
        );
        expect(day3Result.value, HealthDataMatchers.hasAggregatedValue(65.0));

        // Day 5: Average of 95, 100 = 97.5
        final day5Result = result.firstWhere(
          (point) => point.dateFrom == '2024-01-05T00:00:00.000',
        );
        expect(day5Result.value, HealthDataMatchers.hasAggregatedValue(97.5));
      });
    });

    group('sessional data aggregation', () {
      test('includes sessions with majority overlap', () {
        final startTime = DateTime(2024, 1, 1, 10);
        final endTime = DateTime(2024, 1, 1, 12);

        final data = [
          TestDataFactory.createRawHealthDataPoint(
            type: 'SLEEP_SESSION',
            value: 'SLEEP',
            dateFrom:
                DateTime(2024, 1, 1, 9, 30), // 30 min before, 90 min during
            dateTo: DateTime(2024, 1, 1, 11),
            sourceId: 'source-1',
          ),
          TestDataFactory.createRawHealthDataPoint(
            type: 'SLEEP_SESSION',
            value: 'SLEEP',
            dateFrom:
                DateTime(2024, 1, 1, 10, 45), // 15 min overlap (not majority)
            dateTo: DateTime(2024, 1, 1, 12, 30),
            sourceId: 'source-2',
          ),
        ];

        final request = (
          data: data,
          groupBy: TimeGroupBy.hour,
          startTime: startTime,
          endTime: endTime,
          aggregatePerSource: false,
          statisticType: StatisticType.sum,
        );

        final result = aggregator.aggregate(request);

        // Only the first session should be counted (majority overlap)
        expect(result.length, equals(1));
        expect(result.first.value, equals(90.0)); // Count of 1 session
      });
    });

    group('durational data aggregation', () {
      test('sums duration for sessions ending within segment', () {
        final startTime = DateTime(2024, 1, 1, 10);
        final endTime = DateTime(2024, 1, 1, 12);

        final data = [
          TestDataFactory.createRawHealthDataPoint(
            type: 'SLEEP_ASLEEP',
            value: 'ASLEEP',
            dateFrom: DateTime(2024, 1, 1, 8), // 2 hours before start
            dateTo: DateTime(2024, 1, 1, 10, 30), // Ends within first hour
            sourceId: 'source-1',
          ),
          TestDataFactory.createRawHealthDataPoint(
            type: 'SLEEP_ASLEEP',
            value: 'ASLEEP',
            dateFrom: DateTime(2024, 1, 1, 10, 45),
            dateTo: DateTime(2024, 1, 1, 11, 15), // 30 minute duration
            sourceId: 'source-2',
          ),
        ];

        final request = (
          data: data,
          groupBy: TimeGroupBy.hour,
          startTime: startTime,
          endTime: endTime,
          aggregatePerSource: false,
          statisticType: StatisticType.sum,
        );

        final result = aggregator.aggregate(request);

        expect(result.length, equals(2));

        // Hour 10-11: 150 minutes (2.5 hours) + 30 minutes = 180 minutes
        final hour10Result = result.firstWhere(
          (point) => point.dateFrom == '2024-01-01T10:00:00.000',
        );
        expect(
          hour10Result.value,
          HealthDataMatchers.hasAggregatedValue(150.0),
        );

        // Hour 11-12: 30 minutes
        final hour11Result = result.firstWhere(
          (point) => point.dateFrom == '2024-01-01T11:00:00.000',
        );
        expect(
          hour11Result.value,
          HealthDataMatchers.hasAggregatedValue(30.0),
        );
      });
    });

    group('edge cases', () {
      test('handles data points exactly on segment boundaries', () {
        final startTime = DateTime(2024, 1, 1, 10);
        final endTime = DateTime(2024, 1, 1, 12);

        final data = [
          TestDataFactory.createRawHealthDataPoint(
            type: 'STEPS',
            value: 1000,
            dateFrom: DateTime(2024, 1, 1, 10), // Exactly on start boundary
            dateTo: DateTime(2024, 1, 1, 10, 30),
            sourceId: 'source-1',
          ),
          TestDataFactory.createRawHealthDataPoint(
            type: 'STEPS',
            value: 500,
            dateFrom: DateTime(2024, 1, 1, 11, 30),
            dateTo: DateTime(2024, 1, 1, 12), // Exactly on end boundary
            sourceId: 'source-1',
          ),
        ];

        final request = (
          data: data,
          groupBy: TimeGroupBy.hour,
          startTime: startTime,
          endTime: endTime,
          aggregatePerSource: false,
          statisticType: StatisticType.sum,
        );

        final result = aggregator.aggregate(request);

        expect(result.length, equals(2));
        expect(
          result.map((p) => p.value).reduce((a, b) => a + b),
          equals(1500.0),
        );
      });

      test('handles empty time segments', () {
        final startTime = DateTime(2024, 1, 1, 10);
        final endTime = DateTime(2024, 1, 1, 14);

        final data = [
          TestDataFactory.createRawHealthDataPoint(
            type: 'STEPS',
            value: 1000,
            dateFrom: DateTime(2024, 1, 1, 10, 30),
            dateTo: DateTime(2024, 1, 1, 10, 45),
            sourceId: 'source-1',
          ),
          // Gap: no data for hour 11-12 and 12-13
          TestDataFactory.createRawHealthDataPoint(
            type: 'STEPS',
            value: 500,
            dateFrom: DateTime(2024, 1, 1, 13, 30),
            dateTo: DateTime(2024, 1, 1, 13, 45),
            sourceId: 'source-1',
          ),
        ];

        final request = (
          data: data,
          groupBy: TimeGroupBy.hour,
          startTime: startTime,
          endTime: endTime,
          aggregatePerSource: false,
          statisticType: StatisticType.sum,
        );

        final result = aggregator.aggregate(request);

        // Should only have 2 results (for hours with data)
        expect(result.length, equals(2));

        final values = result.map((p) => p.value).toList();
        expect(values, containsAll([1000.0, 500.0]));
      });

      test('handles data outside query range', () {
        final startTime = DateTime(2024, 1, 1, 10);
        final endTime = DateTime(2024, 1, 1, 12);

        final data = [
          TestDataFactory.createRawHealthDataPoint(
            type: 'STEPS',
            value: 1000,
            dateFrom: DateTime(2024, 1, 1, 9), // Before range
            dateTo: DateTime(2024, 1, 1, 9, 30),
            sourceId: 'source-1',
          ),
          TestDataFactory.createRawHealthDataPoint(
            type: 'STEPS',
            value: 500,
            dateFrom: DateTime(2024, 1, 1, 10, 30), // Within range
            dateTo: DateTime(2024, 1, 1, 10, 45),
            sourceId: 'source-1',
          ),
          TestDataFactory.createRawHealthDataPoint(
            type: 'STEPS',
            value: 750,
            dateFrom: DateTime(2024, 1, 1, 13), // After range
            dateTo: DateTime(2024, 1, 1, 13, 30),
            sourceId: 'source-1',
          ),
        ];

        final request = (
          data: data,
          groupBy: TimeGroupBy.hour,
          startTime: startTime,
          endTime: endTime,
          aggregatePerSource: false,
          statisticType: StatisticType.sum,
        );

        final result = aggregator.aggregate(request);

        // Should only include data within range
        expect(result.length, equals(1));
        expect(result.first.value, equals(500.0));
      });
    });
  });
}
