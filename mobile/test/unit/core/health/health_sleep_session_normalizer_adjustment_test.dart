import 'package:flutter_template/core/health/health_sleep_session_normalizer.dart';
import 'package:flutter_template/model/vytal_health_data_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HealthSleepSessionNormalizer Time Range Adjustment', () {
    late HealthSleepSessionNormalizer normalizer;

    setUp(() {
      normalizer = const HealthSleepSessionNormalizer();
    });

    group('Natural time range request detection', () {
      test('adjusts time range for typical ChatGPT full-day request', () {
        final originalStartTime = DateTime.utc(2025, 10, 7, 0, 0, 0);
        final originalEndTime = DateTime.utc(2025, 10, 7, 23, 59, 59);

        final result = normalizer.adjustTimeRangeForSleepData(
          VytalHealthDataCategory.SLEEP,
          originalStartTime,
          originalEndTime,
        );

        expect(result.startTime, equals(DateTime(2025, 10, 7, 21, 0, 0)));
        expect(result.endTime, equals(DateTime(2025, 10, 7, 21, 0, 0)));
      });

      test('adjusts time range for weekly sleep request', () {
        // Week request: 2025-10-01T00:00:00.000Z to 2025-10-07T23:59:59.000Z
        final originalStartTime = DateTime.utc(2025, 10, 1, 0, 0, 0);
        final originalEndTime = DateTime.utc(2025, 10, 7, 23, 59, 59);

        final result = normalizer.adjustTimeRangeForSleepData(
          VytalHealthDataCategory.SLEEP,
          originalStartTime,
          originalEndTime,
        );

        expect(result.startTime, equals(DateTime(2025, 10, 1, 21, 0, 0)));
        expect(result.endTime, equals(DateTime(2025, 10, 7, 21, 0, 0)));
      });

      test('adjusts time range for monthly sleep request', () {
        // Month request: 2025-10-01T00:00:00.000Z to 2025-10-31T23:59:59.000Z
        final originalStartTime =
            DateTime.utc(2025, 10, 1, 0, 0, 0); // Oct 1 00:00
        final originalEndTime =
            DateTime.utc(2025, 10, 31, 23, 59, 59); // Oct 31 23:59

        final result = normalizer.adjustTimeRangeForSleepData(
          VytalHealthDataCategory.SLEEP,
          originalStartTime,
          originalEndTime,
        );

        expect(result.startTime, equals(DateTime(2025, 10, 1, 21, 0, 0)));
        expect(result.endTime, equals(DateTime(2025, 10, 31, 21, 0, 0)));
      });

      test('adjusts time range for natural range with slight variations', () {
        final originalStartTime = DateTime(2025, 10, 1, 0, 0, 30);
        final originalEndTime = DateTime(2025, 10, 7, 23, 58, 0);

        final result = normalizer.adjustTimeRangeForSleepData(
          VytalHealthDataCategory.SLEEP,
          originalStartTime,
          originalEndTime,
        );

        expect(result.startTime, equals(DateTime(2025, 10, 1, 21, 0, 0)));
        expect(result.endTime, equals(DateTime(2025, 10, 7, 21, 0, 0)));
      });

      test('does NOT adjust time range for partial day requests', () {
        // 08:00 to 18:00 - clearly not a natural range
        final originalStartTime = DateTime(2025, 10, 7, 8, 0, 0);
        final originalEndTime = DateTime(2025, 10, 7, 18, 0, 0);

        final result = normalizer.adjustTimeRangeForSleepData(
          VytalHealthDataCategory.SLEEP,
          originalStartTime,
          originalEndTime,
        );

        // Should return original times, not adjusted
        expect(result.startTime, equals(originalStartTime));
        expect(result.endTime, equals(originalEndTime));
      });

      test('does NOT adjust time range for overnight requests', () {
        // 22:00 to 08:00 next day - already an overnight request
        final originalStartTime = DateTime(2025, 10, 6, 22, 0, 0);
        final originalEndTime = DateTime(2025, 10, 7, 8, 0, 0);

        final result = normalizer.adjustTimeRangeForSleepData(
          VytalHealthDataCategory.SLEEP,
          originalStartTime,
          originalEndTime,
        );

        // Should return original times, not adjusted
        expect(result.startTime, equals(originalStartTime));
        expect(result.endTime, equals(originalEndTime));
      });

      test('does NOT adjust when start time is too late in the day', () {
        // Start at 00:10 (outside 5-minute tolerance)
        final originalStartTime = DateTime(2025, 10, 7, 0, 10, 0);
        final originalEndTime = DateTime(2025, 10, 7, 23, 59, 0);

        final result = normalizer.adjustTimeRangeForSleepData(
          VytalHealthDataCategory.SLEEP,
          originalStartTime,
          originalEndTime,
        );

        expect(result.startTime, equals(originalStartTime));
        expect(result.endTime, equals(originalEndTime));
      });

      test('does NOT adjust when end time is too early in the day', () {
        // End at 23:50 (outside 5-minute tolerance from 23:59)
        final originalStartTime = DateTime(2025, 10, 7, 0, 0, 0);
        final originalEndTime = DateTime(2025, 10, 7, 23, 50, 0);

        final result = normalizer.adjustTimeRangeForSleepData(
          VytalHealthDataCategory.SLEEP,
          originalStartTime,
          originalEndTime,
        );

        expect(result.startTime, equals(originalStartTime));
        expect(result.endTime, equals(originalEndTime));
      });

      test('adjusts multi-day ranges that span different months', () {
        // Range from end of September to early October
        final originalStartTime = DateTime(2025, 9, 28, 0, 0, 0);
        final originalEndTime = DateTime(2025, 10, 5, 23, 59, 0);

        final result = normalizer.adjustTimeRangeForSleepData(
          VytalHealthDataCategory.SLEEP,
          originalStartTime,
          originalEndTime,
        );

        expect(result.startTime, equals(DateTime(2025, 9, 28, 21, 0, 0)));
        expect(result.endTime, equals(DateTime(2025, 10, 5, 21, 0, 0)));
      });
    });

    test('does not adjust time range for non-sleep data requests', () {
      final originalStartTime = DateTime(2025, 10, 7, 0, 0, 0);
      final originalEndTime = DateTime(2025, 10, 7, 23, 59, 59);

      final result = normalizer.adjustTimeRangeForSleepData(
        VytalHealthDataCategory.STEPS,
        originalStartTime,
        originalEndTime,
      );

      expect(result.startTime, equals(originalStartTime));
      expect(result.endTime, equals(originalEndTime));
    });

    test('handles sleep data adjustment across month boundaries', () {
      final originalStartTime = DateTime(2025, 11, 1, 0, 0, 0);
      final originalEndTime = DateTime(2025, 11, 1, 23, 59, 59);

      final result = normalizer.adjustTimeRangeForSleepData(
        VytalHealthDataCategory.SLEEP,
        originalStartTime,
        originalEndTime,
      );

      expect(result.startTime, equals(DateTime(2025, 11, 1, 21, 0, 0)));
      expect(result.endTime, equals(DateTime(2025, 11, 1, 21, 0, 0)));
    });

    test('handles sleep data adjustment across year boundaries', () {
      final originalStartTime =
          DateTime(2026, 1, 1, 0, 0, 0); // Jan 1 2026 00:00
      final originalEndTime =
          DateTime(2026, 1, 1, 23, 59, 59); // Jan 1 2026 23:59

      final result = normalizer.adjustTimeRangeForSleepData(
        VytalHealthDataCategory.SLEEP,
        originalStartTime,
        originalEndTime,
      );

      expect(result.startTime, equals(DateTime(2026, 1, 1, 21, 0, 0)));
      expect(result.endTime, equals(DateTime(2026, 1, 1, 21, 0, 0)));
    });

    test('uses correct constants for sleep hours', () {
      final originalStartTime = DateTime(2025, 6, 15, 0, 0, 0);
      final originalEndTime = DateTime(2025, 6, 15, 23, 59, 59);

      final result = normalizer.adjustTimeRangeForSleepData(
        VytalHealthDataCategory.SLEEP,
        originalStartTime,
        originalEndTime,
      );

      // Verify that the constants are being used (21:00 and 12:00)
      expect(result.startTime.hour, equals(21)); // 9 PM
      expect(result.startTime.minute, equals(0));
      expect(result.startTime.second, equals(0));

      expect(result.endTime.hour, equals(21)); // 9 PM
      expect(result.endTime.minute, equals(0));
      expect(result.endTime.second, equals(0));
    });

    test('handles different health data categories correctly', () {
      final originalStartTime = DateTime(2025, 10, 7, 0, 0, 0);
      final originalEndTime = DateTime(2025, 10, 7, 23, 59, 59);

      final testCases = [
        VytalHealthDataCategory.STEPS,
        VytalHealthDataCategory.HEART_RATE,
        VytalHealthDataCategory.CALORIES,
        VytalHealthDataCategory.WORKOUT,
        VytalHealthDataCategory.DISTANCE,
      ];

      for (final category in testCases) {
        final result = normalizer.adjustTimeRangeForSleepData(
          category,
          originalStartTime,
          originalEndTime,
        );

        // All non-sleep categories should return original times
        expect(
          result.startTime,
          equals(originalStartTime),
          reason: 'Failed for category: $category',
        );
        expect(
          result.endTime,
          equals(originalEndTime),
          reason: 'Failed for category: $category',
        );
      }
    });

    group('Edge cases for natural time range detection', () {
      test('tolerance boundary - exactly at 5 minute tolerance', () {
        // Start at 00:05 (exactly at tolerance boundary)
        final originalStartTime = DateTime(2025, 10, 7, 0, 5, 0);
        // End at 23:54 (exactly at tolerance boundary)
        final originalEndTime = DateTime(2025, 10, 7, 23, 54, 0);

        final result = normalizer.adjustTimeRangeForSleepData(
          VytalHealthDataCategory.SLEEP,
          originalStartTime,
          originalEndTime,
        );

        // Should still be adjusted (within tolerance)
        expect(result.startTime, equals(DateTime(2025, 10, 7, 21, 0, 0)));
        expect(result.endTime, equals(DateTime(2025, 10, 7, 21, 0, 0)));
      });

      test('tolerance boundary - just outside tolerance', () {
        // Start at 00:06 (just outside tolerance)
        final originalStartTime = DateTime(2025, 10, 7, 0, 6, 0);
        final originalEndTime = DateTime(2025, 10, 7, 23, 59, 0);

        final result = normalizer.adjustTimeRangeForSleepData(
          VytalHealthDataCategory.SLEEP,
          originalStartTime,
          originalEndTime,
        );

        // Should NOT be adjusted (outside tolerance)
        expect(result.startTime, equals(originalStartTime));
        expect(result.endTime, equals(originalEndTime));
      });

      test('adjusts multi-week ranges', () {
        // 3-week range
        final originalStartTime = DateTime(2025, 10, 1, 0, 0, 0);
        final originalEndTime = DateTime(2025, 10, 21, 23, 59, 59);

        final result = normalizer.adjustTimeRangeForSleepData(
          VytalHealthDataCategory.SLEEP,
          originalStartTime,
          originalEndTime,
        );

        expect(result.startTime, equals(DateTime(2025, 10, 1, 21, 0, 0)));
        expect(result.endTime, equals(DateTime(2025, 10, 21, 21, 0, 0)));
      });

      test('adjusts two-day range correctly (user reported case)', () {
        // User's specific example: 2025-10-07T00:00:00Z to 2025-10-08T23:59:59Z
        final originalStartTime = DateTime(2025, 10, 7, 0, 0, 0);
        final originalEndTime = DateTime(2025, 10, 8, 23, 59, 59);

        final result = normalizer.adjustTimeRangeForSleepData(
          VytalHealthDataCategory.SLEEP,
          originalStartTime,
          originalEndTime,
        );

        // Correct behavior: captures sleep from night of Oct 7-8 only
        expect(result.startTime, equals(DateTime(2025, 10, 7, 21, 0, 0)));
        expect(result.endTime, equals(DateTime(2025, 10, 8, 21, 0, 0)));
      });
    });
  });
}
