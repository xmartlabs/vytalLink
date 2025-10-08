import 'package:flutter_template/core/health/health_data_aggregator.dart';
import 'package:flutter_template/core/model/statistic_types.dart';
import 'package:flutter_template/core/model/time_group_by.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_data_factory.dart';

void main() {
  group('HealthDataAggregator Sleep Date Ranges', () {
    late HealthDataAggregator aggregator;

    setUp(() {
      aggregator = const HealthDataAggregator();
    });

    test('shows actual sleep time range for aggregated sleep data', () {
      final sleepStartTime = DateTime(2025, 10, 6, 23, 30, 0); // Oct 6 23:30
      final sleepEndTime = DateTime(2025, 10, 7, 7, 30, 0); // Oct 7 07:30

      final sleepDataPoints = [
        TestDataFactory.createRawHealthDataPoint(
          type: 'SLEEP_SESSION',
          value: 480.0,
          // 8 hours
          dateFrom: sleepStartTime,
          dateTo: sleepEndTime,
          sourceId: 'com.apple.health',
        ),
      ];

      // Segment boundaries (what the aggregation period covers)
      final segmentStart = DateTime(2025, 10, 7, 0, 0, 0); // Oct 7 00:00
      final segmentEnd = DateTime(2025, 10, 7, 12, 0, 0); // Oct 7 12:00

      final result = aggregator.aggregate(
        (
          data: sleepDataPoints,
          groupBy: TimeGroupBy.day,
          startTime: segmentStart,
          endTime: segmentEnd,
          aggregatePerSource: false,
          statisticType: StatisticType.sum,
        ),
      );

      expect(result, hasLength(1));

      final aggregatedPoint = result.first;
      expect(aggregatedPoint.type, equals('SLEEP_SESSION'));
      expect(aggregatedPoint.value, equals(480.0));

      expect(
        aggregatedPoint.dateFrom,
        equals(sleepStartTime.toIso8601String()),
      );
      expect(aggregatedPoint.dateTo, equals(sleepEndTime.toIso8601String()));
    });

    test('shows segment boundaries for non-sleep data types', () {
      final stepsDataPoints = [
        TestDataFactory.createRawHealthDataPoint(
          type: 'STEPS',
          value: 5000.0,
          dateFrom: DateTime(2025, 10, 7, 8, 0, 0),
          dateTo: DateTime(2025, 10, 7, 9, 0, 0),
          sourceId: 'com.apple.health',
        ),
      ];

      final segmentStart = DateTime(2025, 10, 7, 0, 0, 0); // Oct 7 00:00
      final segmentEnd = DateTime(2025, 10, 7, 23, 59, 59); // Oct 7 23:59

      final result = aggregator.aggregate(
        (
          data: stepsDataPoints,
          groupBy: TimeGroupBy.day,
          startTime: segmentStart,
          endTime: segmentEnd,
          aggregatePerSource: false,
          statisticType: StatisticType.sum,
        ),
      );

      expect(result, hasLength(1));

      final aggregatedPoint = result.first;
      expect(aggregatedPoint.type, equals('STEPS'));

      // For non-sleep data, should use segment boundaries
      expect(aggregatedPoint.dateFrom, equals(segmentStart.toIso8601String()));
      expect(aggregatedPoint.dateTo, equals(segmentEnd.toIso8601String()));
    });

    test('handles multiple sleep sessions correctly', () {
      final firstSleepStart = DateTime(2025, 10, 6, 23, 0, 0); // Oct 6 23:00
      final firstSleepEnd = DateTime(2025, 10, 7, 3, 0, 0); // Oct 7 03:00
      final secondSleepStart = DateTime(2025, 10, 7, 4, 0, 0); // Oct 7 04:00
      final secondSleepEnd = DateTime(2025, 10, 7, 8, 0, 0); // Oct 7 08:00

      final sleepDataPoints = [
        TestDataFactory.createRawHealthDataPoint(
          type: 'SLEEP_SESSION',
          value: 240.0,
          // 4 hours
          dateFrom: firstSleepStart,
          dateTo: firstSleepEnd,
          sourceId: 'com.apple.health',
        ),
        TestDataFactory.createRawHealthDataPoint(
          type: 'SLEEP_SESSION',
          value: 240.0,
          // 4 hours
          dateFrom: secondSleepStart,
          dateTo: secondSleepEnd,
          sourceId: 'com.apple.health',
        ),
      ];

      final segmentStart = DateTime(2025, 10, 7, 0, 0, 0); // Oct 7 00:00
      final segmentEnd = DateTime(2025, 10, 7, 12, 0, 0); // Oct 7 12:00

      final result = aggregator.aggregate(
        (
          data: sleepDataPoints,
          groupBy: TimeGroupBy.day,
          startTime: segmentStart,
          endTime: segmentEnd,
          aggregatePerSource: false,
          statisticType: StatisticType.sum,
        ),
      );

      expect(result, hasLength(1));

      final aggregatedPoint = result.first;
      expect(aggregatedPoint.type, equals('SLEEP_SESSION'));
      expect(aggregatedPoint.value, equals(480.0)); // Total: 8 hours

      // Should span from earliest start to latest end
      expect(
        aggregatedPoint.dateFrom,
        equals(firstSleepStart.toIso8601String()),
      );
      expect(aggregatedPoint.dateTo, equals(secondSleepEnd.toIso8601String()));
    });
  });
}
