import 'package:flutter_template/core/model/health_data_point.dart';
import 'package:health/health.dart';

class HealthDataMapper {
  const HealthDataMapper();

  List<AppHealthDataPoint> map(List<HealthDataPoint> dataPoints) => dataPoints
      .map(
        (dataPoint) => AppHealthDataPoint.raw(
          type: dataPoint.type.name,
          value: _formatHealthValue(dataPoint.value),
          unit: dataPoint.unit.name,
          dateFrom: dataPoint.dateFrom.toIso8601String(),
          dateTo: dataPoint.dateTo.toIso8601String(),
          sourceId: _extractSourceId(dataPoint),
        ),
      )
      .toList();

  dynamic _formatHealthValue(HealthValue value) {
    if (value is NumericHealthValue) {
      return value.numericValue;
    } else if (value is WorkoutHealthValue) {
      return {
        'workoutActivityType': value.workoutActivityType.name,
        'totalEnergyBurned': value.totalEnergyBurned,
        'totalDistance': value.totalDistance,
      };
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
