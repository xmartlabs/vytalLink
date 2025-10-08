import 'package:flutter_template/core/model/health_data_point.dart';
import 'package:flutter_template/core/model/workout_summary_data.dart';
import 'package:health/health.dart';

class HealthDataMapper {
  const HealthDataMapper();

  List<AppHealthDataPoint> map(List<HealthDataPoint> dataPoints) => dataPoints
      .map(
        (dataPoint) => AppHealthDataPoint.raw(
          type: dataPoint.type.name,
          value: _formatHealthValue(dataPoint.value, dataPoint),
          unit: dataPoint.unit.name,
          dateFrom: dataPoint.dateFrom.toIso8601String(),
          dateTo: dataPoint.dateTo.toIso8601String(),
          sourceId: _extractSourceId(dataPoint),
        ),
      )
      .toList();

  dynamic _formatHealthValue(HealthValue value, HealthDataPoint dataPoint) {
    if (dataPoint.type == HealthDataType.WORKOUT &&
        dataPoint.workoutSummary != null) {
      final summary = dataPoint.workoutSummary!;
      return WorkoutSummaryData(
        workoutType: summary.workoutType,
        totalDistance: summary.totalDistance.toDouble(),
        totalEnergyBurned: summary.totalEnergyBurned.toDouble(),
        totalSteps: summary.totalSteps.toDouble(),
      ).toJson();
    }

    if (value is NumericHealthValue) {
      return value.numericValue;
    } else if (value is WorkoutHealthValue) {
      return WorkoutSummaryData(
        workoutType: value.workoutActivityType.name,
        totalDistance: value.totalDistance?.toDouble() ?? 0.0,
        totalEnergyBurned: value.totalEnergyBurned?.toDouble() ?? 0.0,
        totalSteps: value.totalSteps?.toDouble() ?? 0.0,
      ).toJson();
    } else if (value is NutritionHealthValue) {
      return {
        'calories': value.calories,
        'protein': value.protein,
        'carbs': value.carbs,
        'fat': value.fat,
      };
    }

    return value.toString();
  }

  String? _extractSourceId(HealthDataPoint point) {
    final candidates = [
      point.sourceId,
      point.sourceName,
      point.sourceDeviceId,
    ];

    for (final candidate in candidates) {
      final trimmed = candidate.trim();
      if (trimmed.isNotEmpty) {
        return trimmed;
      }
    }

    return null;
  }
}
