import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_summary_data.freezed.dart';
part 'workout_summary_data.g.dart';

@freezed
class WorkoutSummaryData with _$WorkoutSummaryData {
  const factory WorkoutSummaryData({
    required String workoutType,
    @Default(0) double totalDistance,
    @Default(0) double totalEnergyBurned,
    @Default(0) double totalSteps,
  }) = _WorkoutSummaryData;

  factory WorkoutSummaryData.fromJson(Map<String, dynamic> json) =>
      _$WorkoutSummaryDataFromJson(json);
}
