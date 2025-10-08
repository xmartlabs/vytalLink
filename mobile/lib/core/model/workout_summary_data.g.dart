// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_summary_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkoutSummaryDataImpl _$$WorkoutSummaryDataImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkoutSummaryDataImpl(
      workoutType: json['workout_type'] as String? ?? 'other',
      totalDistance: (json['total_distance'] as num?)?.toDouble() ?? 0,
      totalEnergyBurned: (json['total_energy_burned'] as num?)?.toDouble() ?? 0,
      totalSteps: (json['total_steps'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$$WorkoutSummaryDataImplToJson(
        _$WorkoutSummaryDataImpl instance) =>
    <String, dynamic>{
      'workout_type': instance.workoutType,
      'total_distance': instance.totalDistance,
      'total_energy_burned': instance.totalEnergyBurned,
      'total_steps': instance.totalSteps,
    };
