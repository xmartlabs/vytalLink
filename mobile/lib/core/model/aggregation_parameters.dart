import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_template/core/model/health_data_point.dart';
import 'package:flutter_template/core/model/statistic_types.dart';
import 'package:flutter_template/core/model/time_group_by.dart';

part 'aggregation_parameters.freezed.dart';

@freezed
class HealthDataAggregationParameters with _$HealthDataAggregationParameters {
  const factory HealthDataAggregationParameters({
    required List<AppHealthDataPoint> formattedData,
    required List<AggregatedHealthDataPoint> aggregatedData,
    required DateTime startTime,
    required DateTime endTime,
    required TimeGroupBy groupBy,
    required StatisticType statisticType,
  }) = _HealthDataAggregationParameters;
}
