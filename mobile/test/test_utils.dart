import 'package:flutter_test/flutter_test.dart';

/// Utility functions for testing
class TestUtils {
  /// Creates a DateTime for consistent testing
  static DateTime createTestDateTime({
    int year = 2024,
    int month = 1,
    int day = 1,
    int hour = 12,
    int minute = 0,
    int second = 0,
  }) =>
      DateTime(year, month, day, hour, minute, second);

  /// Creates a range of test dates
  static List<DateTime> createDateRange({
    required DateTime start,
    required DateTime end,
    required Duration interval,
  }) {
    final dates = <DateTime>[];
    var current = start;

    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      dates.add(current);
      current = current.add(interval);
    }

    return dates;
  }

  /// Asserts that two DateTime objects are equal within a tolerance
  static void expectDateTimeEquals(
    DateTime actual,
    DateTime expected, {
    Duration tolerance = const Duration(milliseconds: 1),
  }) {
    final difference = actual.difference(expected).abs();
    expect(
      difference.inMilliseconds,
      lessThanOrEqualTo(tolerance.inMilliseconds),
      reason: 'Expected $actual to be within $tolerance of $expected, '
          'but difference was ${difference.inMilliseconds}ms',
    );
  }

  /// Asserts that a list contains all expected elements
  static void expectListContainsAll<T>(List<T> actual, List<T> expected) {
    for (final item in expected) {
      expect(actual, contains(item));
    }
  }

  /// Creates a timeout for async tests
  static Timeout createTimeout({int seconds = 10}) => Timeout(
        Duration(
          seconds: seconds,
        ),
      );

  /// Expects an async function to throw a specific exception type
  static Future<void> expectAsyncThrows<T extends Exception>(
    Future<void> Function() asyncFunction,
  ) async {
    try {
      await asyncFunction();
      fail('Expected $T to be thrown, but no exception was thrown');
    } catch (e) {
      expect(e, isA<T>());
    }
  }

  /// Waits for a condition to be true with timeout
  static Future<void> waitForCondition(
    bool Function() condition, {
    Duration timeout = const Duration(seconds: 5),
    Duration interval = const Duration(milliseconds: 100),
  }) async {
    final stopwatch = Stopwatch()..start();

    while (!condition() && stopwatch.elapsed < timeout) {
      await Future.delayed(interval);
    }

    if (!condition()) {
      throw TimeoutException(
        'Condition was not met within ${timeout.inMilliseconds}ms',
        timeout,
      );
    }
  }
}

/// Custom matchers for health data testing
class HealthDataMatchers {
  /// Matcher for AppHealthDataPoint
  static Matcher hasHealthDataPoint({
    String? type,
    dynamic value,
    String? unit,
    String? sourceId,
  }) =>
      predicate<dynamic>(
        (dynamic item) {
          if (type != null && item.type != type) return false;
          if (value != null && item.value != value) return false;
          if (unit != null && item.unit != unit) return false;
          if (sourceId != null && item.sourceId != sourceId) return false;
          return true;
        },
        'has health data point with specified properties',
      );

  /// Matcher for date range validation
  static Matcher isWithinDateRange(DateTime start, DateTime end) =>
      predicate<DateTime>(
        (DateTime date) =>
            (date.isAfter(start) || date.isAtSameMomentAs(start)) &&
            (date.isBefore(end) || date.isAtSameMomentAs(end)),
        'is within date range $start to $end',
      );

  /// Matcher for aggregated values
  static Matcher hasAggregatedValue(
    double expectedValue, {
    double tolerance = 0.01,
  }) =>
      predicate<double>(
        (double actualValue) =>
            (actualValue - expectedValue).abs() <= tolerance,
        'has aggregated value close to $expectedValue',
      );
}

/// Exception for timeout scenarios
class TimeoutException implements Exception {
  final String message;
  final Duration timeout;

  const TimeoutException(this.message, this.timeout);

  @override
  String toString() => 'TimeoutException: $message';
}
