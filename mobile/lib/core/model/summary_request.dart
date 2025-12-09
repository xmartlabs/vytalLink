import 'package:flutter_template/core/model/statistic_types.dart';
import 'package:flutter_template/core/model/time_group_by.dart';
import 'package:flutter_template/model/vytal_health_data_category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'summary_request.freezed.dart';
part 'summary_request.g.dart';

@freezed
class SummaryMetricRequest with _$SummaryMetricRequest {
  const factory SummaryMetricRequest({
    required VytalHealthDataCategory valueType,
    TimeGroupBy? groupBy,
    StatisticType? statistic,
  }) = _SummaryMetricRequest;

  factory SummaryMetricRequest.fromJson(Map<String, dynamic> json) =>
      _$SummaryMetricRequestFromJson(json);
}

@freezed
class SummaryRequest with _$SummaryRequest {
  const factory SummaryRequest({
    required DateTime startTime,
    required DateTime endTime,
    List<SummaryMetricRequest>? metrics,
  }) = _SummaryRequest;

  factory SummaryRequest.fromJson(Map<String, dynamic> json) =>
      _$SummaryRequestFromJson(json);
}
