import 'package:flutter_template/core/model/health_data_response.dart';
import 'package:flutter_template/model/vytal_health_data_category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'summary_response.freezed.dart';
part 'summary_response.g.dart';

@freezed
class SummaryMetricResult with _$SummaryMetricResult {
  const factory SummaryMetricResult({
    required VytalHealthDataCategory valueType,
    required bool success,
    HealthDataResponse? data,
    @JsonKey(name: 'error_message') String? errorMessage,
  }) = _SummaryMetricResult;

  factory SummaryMetricResult.fromJson(Map<String, dynamic> json) =>
      _$SummaryMetricResultFromJson(json);
}

@freezed
class SummaryResponse with _$SummaryResponse {
  const factory SummaryResponse({
    required bool success,
    required String startTime,
    required String endTime,
    required List<SummaryMetricResult> results,
    @JsonKey(name: 'error_message') String? errorMessage,
  }) = _SummaryResponse;

  factory SummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$SummaryResponseFromJson(json);
}
