// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:health/health.dart';

enum VytalHealthDataCategory {
  STEPS,
  HEART_RATE,
  CALORIES,
  BLOOD_OXYGEN,
  BLOOD_PRESSURE,
  BODY_TEMPERATURE,
  BODY_METRICS,
  GLUCOSE,
  EXERCISE_TIME,
  RESPIRATORY_RATE,
  WALKING_SPEED,
  SLEEP,
  MINDFULNESS,
  WORKOUT,
  DISTANCE,
}

// Exclude TOTAL_CALORIES_BURNED on iOS as it available only on Health Connect.
final _finalDataTypes = (Platform.isIOS
        ? dataTypeKeysIOS
            .filter((it) => it != HealthDataType.TOTAL_CALORIES_BURNED)
        : dataTypeKeysAndroid)
    .toSet();

extension VytalHealthDataCategoryTypes on VytalHealthDataCategory {
  List<HealthDataType> get platformHealthDataTypes => _healthDataTypes
      .filter((dataType) => _finalDataTypes.contains(dataType))
      .toList();

  // ignore: long-method
  List<HealthDataType> get _healthDataTypes {
    switch (this) {
      case VytalHealthDataCategory.STEPS:
        return [HealthDataType.STEPS];
      case VytalHealthDataCategory.HEART_RATE:
        return [
          HealthDataType.HEART_RATE,
          HealthDataType.RESTING_HEART_RATE,
        ];
      case VytalHealthDataCategory.CALORIES:
        return [
          HealthDataType.TOTAL_CALORIES_BURNED,
          HealthDataType.ACTIVE_ENERGY_BURNED,
        ];
      case VytalHealthDataCategory.BLOOD_OXYGEN:
        return [HealthDataType.BLOOD_OXYGEN];
      case VytalHealthDataCategory.BLOOD_PRESSURE:
        return [
          HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
          HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
        ];
      case VytalHealthDataCategory.BODY_TEMPERATURE:
        return [HealthDataType.BODY_TEMPERATURE];
      case VytalHealthDataCategory.BODY_METRICS:
        return [
          HealthDataType.WEIGHT,
          HealthDataType.HEIGHT,
          HealthDataType.BODY_FAT_PERCENTAGE,
          HealthDataType.WATER,
          HealthDataType.NUTRITION,
        ];
      case VytalHealthDataCategory.GLUCOSE:
        return [HealthDataType.BLOOD_GLUCOSE];
      case VytalHealthDataCategory.EXERCISE_TIME:
        return [HealthDataType.EXERCISE_TIME];
      case VytalHealthDataCategory.RESPIRATORY_RATE:
        return [HealthDataType.RESPIRATORY_RATE];
      case VytalHealthDataCategory.WALKING_SPEED:
        return [HealthDataType.WALKING_SPEED];
      case VytalHealthDataCategory.SLEEP:
        return [
          HealthDataType.SLEEP_SESSION,
          HealthDataType.SLEEP_ASLEEP,
          HealthDataType.SLEEP_AWAKE,
          HealthDataType.SLEEP_AWAKE_IN_BED,
          HealthDataType.SLEEP_DEEP,
          HealthDataType.SLEEP_IN_BED,
          HealthDataType.SLEEP_LIGHT,
          HealthDataType.SLEEP_OUT_OF_BED,
          HealthDataType.SLEEP_REM,
          HealthDataType.SLEEP_UNKNOWN,
        ];
      case VytalHealthDataCategory.MINDFULNESS:
        return [HealthDataType.MINDFULNESS];
      case VytalHealthDataCategory.WORKOUT:
        return [HealthDataType.WORKOUT];
      case VytalHealthDataCategory.DISTANCE:
        return [
          HealthDataType.DISTANCE_WALKING_RUNNING,
          HealthDataType.DISTANCE_DELTA,
        ];
    }
  }

  // ignore: unused
  String get description {
    switch (this) {
      case VytalHealthDataCategory.STEPS:
        return 'Number of steps taken';
      case VytalHealthDataCategory.HEART_RATE:
        return 'Heart rate (beats per minute), including resting heart rate';
      case VytalHealthDataCategory.CALORIES:
        return 'Calories burned (total and active)';
      case VytalHealthDataCategory.BLOOD_OXYGEN:
        return 'Blood oxygen saturation percentage';
      case VytalHealthDataCategory.BLOOD_PRESSURE:
        return 'Blood pressure (systolic and diastolic)';
      case VytalHealthDataCategory.BODY_TEMPERATURE:
        return 'Body temperature';
      case VytalHealthDataCategory.BODY_METRICS:
        return 'Body metrics: weight, height, body fat, water, and nutrition';
      case VytalHealthDataCategory.GLUCOSE:
        return 'Blood glucose level';
      case VytalHealthDataCategory.EXERCISE_TIME:
        return 'Minutes of exercise performed';
      case VytalHealthDataCategory.RESPIRATORY_RATE:
        return 'Respiratory rate (breaths per minute)';
      case VytalHealthDataCategory.WALKING_SPEED:
        return 'Walking speed';
      case VytalHealthDataCategory.SLEEP:
        return 'Sleep phases and quality (deep, REM, light, etc.)';
      case VytalHealthDataCategory.MINDFULNESS:
        return 'Minutes of mindfulness or meditation practice';
      case VytalHealthDataCategory.WORKOUT:
        return 'Recorded workouts or physical activities';
      case VytalHealthDataCategory.DISTANCE:
        return 'Distance covered (walking/running)';
    }
  }
}
