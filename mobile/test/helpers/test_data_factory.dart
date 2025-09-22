import 'package:flutter_template/core/model/aggregation_parameters.dart';
import 'package:flutter_template/core/model/health_data_point.dart';
import 'package:flutter_template/core/model/health_data_request.dart';
import 'package:flutter_template/core/model/health_data_response.dart';
import 'package:flutter_template/core/model/statistic_types.dart';
import 'package:flutter_template/core/model/time_group_by.dart';
import 'package:flutter_template/model/vytal_health_data_category.dart';

/// Factory for creating test data objects
class TestDataFactory {
  static HealthDataRequest createHealthDataRequest({
    VytalHealthDataCategory valueType = VytalHealthDataCategory.STEPS,
    DateTime? startTime,
    DateTime? endTime,
    TimeGroupBy? groupBy,
    StatisticType? statistic,
  }) {
    final now = DateTime.now();
    return HealthDataRequest(
      valueType: valueType,
      startTime: startTime ?? now.subtract(const Duration(days: 7)),
      endTime: endTime ?? now,
      groupBy: groupBy,
      statistic: statistic,
    );
  }

  static AppHealthDataPoint createRawHealthDataPoint({
    String type = 'STEPS',
    dynamic value = 1000,
    String unit = 'COUNT',
    DateTime? dateFrom,
    DateTime? dateTo,
    String? sourceId,
  }) {
    final now = DateTime.now();
    return AppHealthDataPoint.raw(
      type: type,
      value: value,
      unit: unit,
      dateFrom: (dateFrom ?? now.subtract(const Duration(hours: 1)))
          .toIso8601String(),
      dateTo: (dateTo ?? now).toIso8601String(),
      sourceId: sourceId ?? 'test-source-1',
    );
  }

  static AppHealthDataPoint createAggregatedHealthDataPoint({
    String type = 'STEPS',
    double value = 1000.0,
    String unit = 'COUNT',
    DateTime? dateFrom,
    DateTime? dateTo,
    String? sourceId,
  }) {
    final now = DateTime.now();
    return AppHealthDataPoint.aggregated(
      type: type,
      value: value,
      unit: unit,
      dateFrom: (dateFrom ?? now.subtract(const Duration(hours: 1)))
          .toIso8601String(),
      dateTo: (dateTo ?? now).toIso8601String(),
      sourceId: sourceId,
    );
  }

  static HealthDataResponse createHealthDataResponse({
    bool success = true,
    int count = 1,
    List<AppHealthDataPoint>? healthData,
    String valueType = 'STEPS',
    DateTime? startTime,
    DateTime? endTime,
    String? groupBy,
    bool? isAggregated,
    String? statisticType,
  }) {
    final now = DateTime.now();
    return HealthDataResponse(
      success: success,
      count: count,
      healthData: healthData ?? [createRawHealthDataPoint()],
      valueType: valueType,
      startTime: (startTime ?? now.subtract(const Duration(days: 1)))
          .toIso8601String(),
      endTime: (endTime ?? now).toIso8601String(),
      groupBy: groupBy,
      isAggregated: isAggregated,
      statisticType: statisticType,
    );
  }

  static HealthDataAggregationParameters createAggregationParameters({
    List<AppHealthDataPoint>? formattedData,
    List<AggregatedHealthDataPoint>? aggregatedData,
    DateTime? startTime,
    DateTime? endTime,
    TimeGroupBy groupBy = TimeGroupBy.day,
    StatisticType statisticType = StatisticType.sum,
  }) {
    final now = DateTime.now();
    return HealthDataAggregationParameters(
      formattedData: formattedData ?? [createRawHealthDataPoint()],
      aggregatedData: aggregatedData ??
          [createAggregatedHealthDataPoint() as AggregatedHealthDataPoint],
      startTime: startTime ?? now.subtract(const Duration(days: 1)),
      endTime: endTime ?? now,
      groupBy: groupBy,
      statisticType: statisticType,
    );
  }

  /// Creates a list of health data points for testing aggregation
  static List<AppHealthDataPoint> createHealthDataPointSeries({
    required int count,
    required Duration interval,
    String type = 'STEPS',
    double baseValue = 1000.0,
    DateTime? startTime,
    String? sourceId,
  }) {
    final start = startTime ?? DateTime.now().subtract(Duration(hours: count));
    final points = <AppHealthDataPoint>[];

    for (int i = 0; i < count; i++) {
      final pointStart = start.add(Duration(hours: i));
      final pointEnd = pointStart.add(interval);
      final value = baseValue + (i * 100); // Varying values for testing

      points.add(
        AppHealthDataPoint.raw(
          type: type,
          value: value,
          unit: type == 'STEPS' ? 'COUNT' : 'UNKNOWN',
          dateFrom: pointStart.toIso8601String(),
          dateTo: pointEnd.toIso8601String(),
          sourceId: sourceId ?? 'test-source-$i',
        ),
      );
    }

    return points;
  }

  /// Creates overlapping health data points for testing edge cases
  static List<AppHealthDataPoint> createOverlappingHealthDataPoints() {
    final baseTime = DateTime(2024, 1, 1, 10, 0, 0);

    return [
      AppHealthDataPoint.raw(
        type: 'STEPS',
        value: 500,
        unit: 'COUNT',
        dateFrom: baseTime.toIso8601String(),
        dateTo: baseTime.add(const Duration(hours: 2)).toIso8601String(),
        sourceId: 'source-1',
      ),
      AppHealthDataPoint.raw(
        type: 'STEPS',
        value: 300,
        unit: 'COUNT',
        dateFrom: baseTime.add(const Duration(hours: 1)).toIso8601String(),
        dateTo: baseTime.add(const Duration(hours: 3)).toIso8601String(),
        sourceId: 'source-2',
      ),
      AppHealthDataPoint.raw(
        type: 'STEPS',
        value: 200,
        unit: 'COUNT',
        dateFrom: baseTime
            .add(const Duration(hours: 2, minutes: 30))
            .toIso8601String(),
        dateTo: baseTime.add(const Duration(hours: 4)).toIso8601String(),
        sourceId: 'source-1',
      ),
    ];
  }
}
