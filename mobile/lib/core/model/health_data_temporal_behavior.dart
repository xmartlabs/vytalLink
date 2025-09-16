import 'package:health/health.dart';

enum HealthDataTemporalBehavior {
  /// Data represents a point in time (e.g., weight, heart rate)
  /// Should be assigned to the segment containing the measurement time
  instantaneous,

  /// Data represents an activity over a duration (e.g., steps, calories)
  /// Should be distributed proportionally across segments it spans
  cumulative,

  /// Data represents a session/state over time (e.g., workouts)
  /// Should be assigned to the segment where it predominately occurs
  sessional,

  /// Data represents a period between two points (e.g., sleep phases)
  /// Should be assigned in full to the segment containing the end time
  durational;

  static HealthDataTemporalBehavior forHealthDataType(HealthDataType type) =>
      switch (type) {
        HealthDataType.WEIGHT ||
        HealthDataType.HEIGHT ||
        HealthDataType.HEART_RATE ||
        HealthDataType.BLOOD_PRESSURE_SYSTOLIC ||
        HealthDataType.BLOOD_PRESSURE_DIASTOLIC ||
        HealthDataType.BLOOD_GLUCOSE ||
        HealthDataType.BODY_TEMPERATURE =>
          HealthDataTemporalBehavior.instantaneous,
        HealthDataType.STEPS ||
        HealthDataType.ACTIVE_ENERGY_BURNED ||
        HealthDataType.DISTANCE_DELTA ||
        HealthDataType.WATER ||
        HealthDataType.FLIGHTS_CLIMBED =>
          HealthDataTemporalBehavior.cumulative,
        HealthDataType.WORKOUT ||
        HealthDataType.MINDFULNESS =>
          HealthDataTemporalBehavior.sessional,
        HealthDataType.SLEEP_SESSION ||
        HealthDataType.SLEEP_ASLEEP ||
        HealthDataType.SLEEP_AWAKE ||
        HealthDataType.SLEEP_DEEP ||
        HealthDataType.SLEEP_LIGHT ||
        HealthDataType.SLEEP_REM =>
          HealthDataTemporalBehavior.durational,
        _ => HealthDataTemporalBehavior.instantaneous,
      };

  bool get spansTimeBoundaries => switch (this) {
        HealthDataTemporalBehavior.instantaneous => false,
        HealthDataTemporalBehavior.cumulative => true,
        HealthDataTemporalBehavior.sessional => true,
        HealthDataTemporalBehavior.durational => true,
      };

  bool get shouldDistribute => switch (this) {
        HealthDataTemporalBehavior.instantaneous => false,
        HealthDataTemporalBehavior.cumulative => true,
        HealthDataTemporalBehavior.sessional => false,
        HealthDataTemporalBehavior.durational => false,
      };
}
