import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_data_point.freezed.dart';
part 'health_data_point.g.dart';

@freezed
class AppHealthDataPoint with _$AppHealthDataPoint {
  const factory AppHealthDataPoint.raw({
    required String type,
    required dynamic value,
    required String unit,
    required String dateFrom,
    required String dateTo,
    required String? sourceId,
  }) = SimpleHealthDataPoint;

  const factory AppHealthDataPoint.aggregated({
    required String type,
    required dynamic value,
    required String unit,
    required String dateFrom,
    required String dateTo,
    required String? sourceId,
  }) = AggregatedHealthDataPoint;

  factory AppHealthDataPoint.fromJson(Map<String, dynamic> json) =>
      _$AppHealthDataPointFromJson(json);
}
