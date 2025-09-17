import 'package:health/health.dart';

enum HealthDataUnit {
  calories,
  percentage,
  milligramPerDeciliter,
  millimeterOfMercury,
  kilogram,
  siemens,
  count,
  liter,
  minute,
  millisecond,
  decibelHearingLevel,
  volt,
  internationalUnit,
  meterPerSecond,
  second,
  hour,
  degreeCelsius,
  noUnit,
  beatsPerMinute,
  meter,
  respirationPerMinute,
}

// TODO: Send this information to the server
// ignore: unused-code
extension HealthDataTypeUnitExtension on HealthDataType {
  // ignore: long-method
  HealthDataUnit get unit {
    switch (this) {
      case HealthDataType.ACTIVE_ENERGY_BURNED:
      case HealthDataType.BASAL_ENERGY_BURNED:
        return HealthDataUnit.calories;
      case HealthDataType.ATRIAL_FIBRILLATION_BURDEN:
      case HealthDataType.BLOOD_OXYGEN:
      case HealthDataType.BODY_FAT_PERCENTAGE:
      case HealthDataType.PERIPHERAL_PERFUSION_INDEX:
        return HealthDataUnit.percentage;
      case HealthDataType.BLOOD_GLUCOSE:
        return HealthDataUnit.milligramPerDeciliter;
      case HealthDataType.BLOOD_PRESSURE_DIASTOLIC:
      case HealthDataType.BLOOD_PRESSURE_SYSTOLIC:
        return HealthDataUnit.millimeterOfMercury;
      case HealthDataType.BODY_WATER_MASS:
      case HealthDataType.WEIGHT:
      case HealthDataType.LEAN_BODY_MASS:
        return HealthDataUnit.kilogram;
      case HealthDataType.ELECTRODERMAL_ACTIVITY:
        return HealthDataUnit.siemens;
      case HealthDataType.HEART_RATE:
      case HealthDataType.RESTING_HEART_RATE:
      case HealthDataType.WALKING_HEART_RATE:
        return HealthDataUnit.beatsPerMinute;
      case HealthDataType.HEIGHT:
      case HealthDataType.WAIST_CIRCUMFERENCE:
      case HealthDataType.DISTANCE_WALKING_RUNNING:
      case HealthDataType.DISTANCE_DELTA:
      case HealthDataType.UNDERWATER_DEPTH:
        return HealthDataUnit.meter;
      case HealthDataType.RESPIRATORY_RATE:
        return HealthDataUnit.respirationPerMinute;
      case HealthDataType.STEPS:
      case HealthDataType.FLIGHTS_CLIMBED:
      case HealthDataType.UV_INDEX:
        return HealthDataUnit.count;
      case HealthDataType.WATER:
        return HealthDataUnit.liter;
      case HealthDataType.MINDFULNESS:
      case HealthDataType.SLEEP_ASLEEP:
      case HealthDataType.SLEEP_AWAKE:
      case HealthDataType.SLEEP_AWAKE_IN_BED:
      case HealthDataType.SLEEP_DEEP:
      case HealthDataType.SLEEP_IN_BED:
      case HealthDataType.SLEEP_LIGHT:
      case HealthDataType.SLEEP_OUT_OF_BED:
      case HealthDataType.SLEEP_REM:
      case HealthDataType.SLEEP_UNKNOWN:
      case HealthDataType.SLEEP_SESSION:
      case HealthDataType.EXERCISE_TIME:
      case HealthDataType.HEADACHE_NOT_PRESENT:
      case HealthDataType.HEADACHE_MILD:
      case HealthDataType.HEADACHE_MODERATE:
      case HealthDataType.HEADACHE_SEVERE:
      case HealthDataType.HEADACHE_UNSPECIFIED:
        return HealthDataUnit.minute;
      case HealthDataType.HEART_RATE_VARIABILITY_RMSSD:
      case HealthDataType.HEART_RATE_VARIABILITY_SDNN:
        return HealthDataUnit.millisecond;
      case HealthDataType.AUDIOGRAM:
        return HealthDataUnit.decibelHearingLevel;
      case HealthDataType.ELECTROCARDIOGRAM:
        return HealthDataUnit.volt;
      case HealthDataType.INSULIN_DELIVERY:
        return HealthDataUnit.internationalUnit;
      case HealthDataType.WALKING_SPEED:
        return HealthDataUnit.meterPerSecond;
      case HealthDataType.APPLE_MOVE_TIME:
        return HealthDataUnit.second;
      case HealthDataType.APPLE_STAND_HOUR:
        return HealthDataUnit.hour;
      case HealthDataType.BODY_MASS_INDEX:
      case HealthDataType.WORKOUT:
      case HealthDataType.HIGH_HEART_RATE_EVENT:
      case HealthDataType.LOW_HEART_RATE_EVENT:
      case HealthDataType.IRREGULAR_HEART_RATE_EVENT:
      case HealthDataType.NUTRITION:
      case HealthDataType.MENSTRUATION_FLOW:
        return HealthDataUnit.noUnit;
      case HealthDataType.BODY_TEMPERATURE:
      case HealthDataType.WATER_TEMPERATURE:
        return HealthDataUnit.degreeCelsius;
      case HealthDataType.APPLE_STAND_TIME:
      case HealthDataType.DIETARY_CARBS_CONSUMED:
      case HealthDataType.DIETARY_CAFFEINE:
      case HealthDataType.DIETARY_ENERGY_CONSUMED:
      case HealthDataType.DIETARY_FATS_CONSUMED:
      case HealthDataType.DIETARY_PROTEIN_CONSUMED:
      case HealthDataType.DIETARY_FIBER:
      case HealthDataType.DIETARY_SUGAR:
      case HealthDataType.DIETARY_FAT_MONOUNSATURATED:
      case HealthDataType.DIETARY_FAT_POLYUNSATURATED:
      case HealthDataType.DIETARY_FAT_SATURATED:
      case HealthDataType.DIETARY_CHOLESTEROL:
      case HealthDataType.DIETARY_VITAMIN_A:
      case HealthDataType.DIETARY_THIAMIN:
      case HealthDataType.DIETARY_RIBOFLAVIN:
      case HealthDataType.DIETARY_NIACIN:
      case HealthDataType.DIETARY_PANTOTHENIC_ACID:
      case HealthDataType.DIETARY_VITAMIN_B6:
      case HealthDataType.DIETARY_BIOTIN:
      case HealthDataType.DIETARY_VITAMIN_B12:
      case HealthDataType.DIETARY_VITAMIN_C:
      case HealthDataType.DIETARY_VITAMIN_D:
      case HealthDataType.DIETARY_VITAMIN_E:
      case HealthDataType.DIETARY_VITAMIN_K:
      case HealthDataType.DIETARY_FOLATE:
      case HealthDataType.DIETARY_CALCIUM:
      case HealthDataType.DIETARY_CHLORIDE:
      case HealthDataType.DIETARY_IRON:
      case HealthDataType.DIETARY_MAGNESIUM:
      case HealthDataType.DIETARY_PHOSPHORUS:
      case HealthDataType.DIETARY_POTASSIUM:
      case HealthDataType.DIETARY_SODIUM:
      case HealthDataType.DIETARY_ZINC:
      case HealthDataType.DIETARY_CHROMIUM:
      case HealthDataType.DIETARY_COPPER:
      case HealthDataType.DIETARY_IODINE:
      case HealthDataType.DIETARY_MANGANESE:
      case HealthDataType.DIETARY_MOLYBDENUM:
      case HealthDataType.DIETARY_SELENIUM:
      case HealthDataType.FORCED_EXPIRATORY_VOLUME:
      case HealthDataType.DISTANCE_SWIMMING:
      case HealthDataType.DISTANCE_CYCLING:
      case HealthDataType.SPEED:
      case HealthDataType.GENDER:
      case HealthDataType.BIRTH_DATE:
      case HealthDataType.BLOOD_TYPE:
      case HealthDataType.TOTAL_CALORIES_BURNED:
        return HealthDataUnit.noUnit;
    }
  }
}
