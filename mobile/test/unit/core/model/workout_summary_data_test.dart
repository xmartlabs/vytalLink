import 'package:flutter_template/core/model/workout_summary_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WorkoutSummaryData', () {
    group('constructor', () {
      test('creates instance with all required fields', () {
        const workoutSummary = WorkoutSummaryData(
          workoutType: 'RUNNING',
          totalDistance: 5.2,
          totalEnergyBurned: 450.0,
          totalSteps: 8500,
        );

        expect(workoutSummary.workoutType, equals('RUNNING'));
        expect(workoutSummary.totalDistance, equals(5.2));
        expect(workoutSummary.totalEnergyBurned, equals(450.0));
        expect(workoutSummary.totalSteps, equals(8500));
      });

      test('creates instance with zero values', () {
        const workoutSummary = WorkoutSummaryData(
          workoutType: 'OTHER',
          totalDistance: 0.0,
          totalEnergyBurned: 0.0,
          totalSteps: 0.0,
        );

        expect(workoutSummary.workoutType, equals('OTHER'));
        expect(workoutSummary.totalDistance, equals(0.0));
        expect(workoutSummary.totalEnergyBurned, equals(0.0));
        expect(workoutSummary.totalSteps, equals(0.0));
      });
    });

    group('JSON serialization', () {
      test('serializes to JSON correctly', () {
        const workoutSummary = WorkoutSummaryData(
          workoutType: 'CYCLING',
          totalDistance: 15.5,
          totalEnergyBurned: 600.0,
          totalSteps: 0.0,
        );

        final json = workoutSummary.toJson();

        expect(json['workout_type'], equals('CYCLING'));
        expect(json['total_distance'], equals(15.5));
        expect(json['total_energy_burned'], equals(600.0));
        expect(json['total_steps'], equals(0.0));
      });

      test('deserializes from JSON correctly', () {
        final json = {
          'workout_type': 'SWIMMING',
          'total_distance': 2.0,
          'total_energy_burned': 300.0,
          'total_steps': 0.0,
        };

        final workoutSummary = WorkoutSummaryData.fromJson(json);

        expect(workoutSummary.workoutType, equals('SWIMMING'));
        expect(workoutSummary.totalDistance, equals(2.0));
        expect(workoutSummary.totalEnergyBurned, equals(300.0));
        expect(workoutSummary.totalSteps, equals(0.0));
      });

      test('handles missing fields with defaults in fromMap', () {
        final map = {
          'workout_type': 'WALKING',
          // Missing other fields
        };

        final workoutSummary = WorkoutSummaryData.fromJson(map);

        expect(workoutSummary.workoutType, equals('WALKING'));
        expect(workoutSummary.totalDistance, equals(0.0));
        expect(workoutSummary.totalEnergyBurned, equals(0.0));
        expect(workoutSummary.totalSteps, equals(0.0));
      });

      test('handles different numeric types in fromMap', () {
        final map = {
          'workout_type': 'RUNNING',
          'total_distance': 5, // int
          'total_energy_burned': 450, // int
          'total_steps': 8500.0, // double
        };

        final workoutSummary = WorkoutSummaryData.fromJson(map);

        expect(workoutSummary.workoutType, equals('RUNNING'));
        expect(workoutSummary.totalDistance, equals(5.0));
        expect(workoutSummary.totalEnergyBurned, equals(450.0));
        expect(workoutSummary.totalSteps, equals(8500.0));
      });
    });

    group('equality', () {
      test('two instances with same values are equal', () {
        const workoutSummary1 = WorkoutSummaryData(
          workoutType: 'RUNNING',
          totalDistance: 5.2,
          totalEnergyBurned: 450.0,
          totalSteps: 8500,
        );

        const workoutSummary2 = WorkoutSummaryData(
          workoutType: 'RUNNING',
          totalDistance: 5.2,
          totalEnergyBurned: 450.0,
          totalSteps: 8500,
        );

        expect(workoutSummary1, equals(workoutSummary2));
        expect(workoutSummary1.hashCode, equals(workoutSummary2.hashCode));
      });

      test('two instances with different values are not equal', () {
        const workoutSummary1 = WorkoutSummaryData(
          workoutType: 'RUNNING',
          totalDistance: 5.2,
          totalEnergyBurned: 450.0,
          totalSteps: 8500,
        );

        const workoutSummary2 = WorkoutSummaryData(
          workoutType: 'CYCLING',
          totalDistance: 5.2,
          totalEnergyBurned: 450.0,
          totalSteps: 8500,
        );

        expect(workoutSummary1, isNot(equals(workoutSummary2)));
      });
    });

    group('copyWith', () {
      test('creates new instance with updated values', () {
        const original = WorkoutSummaryData(
          workoutType: 'RUNNING',
          totalDistance: 5.2,
          totalEnergyBurned: 450.0,
          totalSteps: 8500,
        );

        final updated = original.copyWith(
          workoutType: 'CYCLING',
          totalDistance: 15.0,
        );

        expect(updated.workoutType, equals('CYCLING'));
        expect(updated.totalDistance, equals(15.0));
        expect(updated.totalEnergyBurned, equals(450.0)); // Unchanged
        expect(updated.totalSteps, equals(8500)); // Unchanged
      });

      test('creates identical instance when no parameters provided', () {
        const original = WorkoutSummaryData(
          workoutType: 'RUNNING',
          totalDistance: 5.2,
          totalEnergyBurned: 450.0,
          totalSteps: 8500,
        );

        final copy = original.copyWith();

        expect(copy, equals(original));
      });
    });

    group('round-trip serialization', () {
      test('maintains data integrity through JSON serialization cycles', () {
        const original = WorkoutSummaryData(
          workoutType: 'MIXED',
          totalDistance: 12.75,
          totalEnergyBurned: 678.5,
          totalSteps: 15432,
        );

        final json = original.toJson();
        final deserialized = WorkoutSummaryData.fromJson(json);

        expect(deserialized, equals(original));
      });
    });
  });
}
