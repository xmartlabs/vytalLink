import 'package:flutter_template/core/model/statistic_types.dart';
import 'package:flutter_template/core/model/time_group_by.dart';
import 'package:flutter_template/model/vytal_health_data_category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_data_request.freezed.dart';
part 'health_data_request.g.dart';

@freezed
class HealthDataRequest with _$HealthDataRequest {
  const factory HealthDataRequest({
    required VytalHealthDataCategory valueType,
    @JsonKey(name: 'startTime') required DateTime startTime,
    @JsonKey(name: 'endTime') required DateTime endTime,
    TimeGroupBy? groupBy,
    StatisticType? statistic,
  }) = _HealthDataRequest;

  factory HealthDataRequest.fromJson(Map<String, dynamic> json) =>
      _$HealthDataRequestFromJson(json);
}
