import 'package:flutter_template/core/health/health_data_mapper.dart';
import 'package:flutter_template/core/model/health_data_point.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health/health.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mock_health_data_point.dart';
import '../../../helpers/mock_health_value.dart';

class MockNumericHealthValue extends Mock implements NumericHealthValue {}

class MockWorkoutHealthValue extends Mock implements WorkoutHealthValue {}

class MockNutritionHealthValue extends Mock implements NutritionHealthValue {}

void main() {
  group('HealthDataMapper', () {
    late HealthDataMapper mapper;

    setUpAll(() {
      registerFallbackValue('fallback_string');
    });

    setUp(() {
      mapper = const HealthDataMapper();
    });

    group('map', () {
      test('maps empty list correctly', () {
        // Arrange
        final emptyList = <HealthDataPoint>[];

        // Act
        final result = mapper.map(emptyList);

        // Assert
        expect(result, isEmpty);
      });

      test('maps basic health data point correctly', () {
        // Arrange
        final mockValue = MockNumericHealthValue();
        when(() => mockValue.numericValue).thenReturn(1000.0);

        final healthDataPoint = MockHealthDataPoint(
          type: HealthDataType.STEPS,
          unit: HealthDataUnit.COUNT,
          dateFrom: DateTime(2024, 1, 1, 10, 0, 0),
          dateTo: DateTime(2024, 1, 1, 11, 0, 0),
          value: mockValue,
          sourceId: 'test-source-id',
          sourceName: 'Test Source',
        );

        // Act
        final result = mapper.map([healthDataPoint]);

        // Assert
        expect(result.length, equals(1));
        final mappedPoint = result.first;
        expect(mappedPoint.type, equals('STEPS'));
        expect(mappedPoint.value, equals(1000.0));
        expect(mappedPoint.unit, equals('COUNT'));
        expect(mappedPoint.dateFrom, equals('2024-01-01T10:00:00.000'));
        expect(mappedPoint.dateTo, equals('2024-01-01T11:00:00.000'));
        expect(mappedPoint.sourceId, equals('test-source-id'));
        expect(mappedPoint, isA<SimpleHealthDataPoint>());
      });

      test('maps multiple health data points correctly', () {
        // Arrange
        final mockValue1 = MockNumericHealthValue();
        final mockValue2 = MockNumericHealthValue();
        when(() => mockValue1.numericValue).thenReturn(1000.0);
        when(() => mockValue2.numericValue).thenReturn(80.5);

        final healthDataPoints = [
          MockHealthDataPoint(
            type: HealthDataType.STEPS,
            unit: HealthDataUnit.COUNT,
            dateFrom: DateTime(2024, 1, 1, 10, 0, 0),
            dateTo: DateTime(2024, 1, 1, 11, 0, 0),
            value: mockValue1,
            sourceId: 'steps-source',
          ),
          MockHealthDataPoint(
            type: HealthDataType.HEART_RATE,
            unit: HealthDataUnit.BEATS_PER_MINUTE,
            dateFrom: DateTime(2024, 1, 1, 11, 0, 0),
            dateTo: DateTime(2024, 1, 1, 11, 1, 0),
            value: mockValue2,
            sourceId: 'heart-rate-source',
          ),
        ];

        // Act
        final result = mapper.map(healthDataPoints);

        // Assert
        expect(result.length, equals(2));

        expect(result[0].type, equals('STEPS'));
        expect(result[0].value, equals(1000.0));
        expect(result[0].unit, equals('COUNT'));
        expect(result[0].sourceId, equals('steps-source'));

        expect(result[1].type, equals('HEART_RATE'));
        expect(result[1].value, equals(80.5));
        expect(result[1].unit, equals('BEATS_PER_MINUTE'));
        expect(result[1].sourceId, equals('heart-rate-source'));
      });
    });

    group('numeric health value mapping', () {
      test('maps integer numeric values correctly', () {
        // Arrange
        final mockValue = MockNumericHealthValue();
        when(() => mockValue.numericValue).thenReturn(1000.0);

        final healthDataPoint = MockHealthDataPoint(
          type: HealthDataType.STEPS,
          unit: HealthDataUnit.COUNT,
          dateFrom: DateTime(2024, 1, 1, 10, 0, 0),
          dateTo: DateTime(2024, 1, 1, 11, 0, 0),
          value: mockValue,
          sourceId: 'test-source',
        );

        // Act
        final result = mapper.map([healthDataPoint]);

        // Assert
        expect(result.first.value, equals(1000.0));
      });

      test('maps decimal numeric values correctly', () {
        // Arrange
        final mockValue = MockNumericHealthValue();
        when(() => mockValue.numericValue).thenReturn(80.5);

        final healthDataPoint = MockHealthDataPoint(
          type: HealthDataType.HEART_RATE,
          unit: HealthDataUnit.BEATS_PER_MINUTE,
          dateFrom: DateTime(2024, 1, 1, 10, 0, 0),
          dateTo: DateTime(2024, 1, 1, 10, 1, 0),
          value: mockValue,
          sourceId: 'test-source',
        );

        // Act
        final result = mapper.map([healthDataPoint]);

        // Assert
        expect(result.first.value, equals(80.5));
      });

      test('maps zero numeric values correctly', () {
        // Arrange
        final mockValue = MockNumericHealthValue();
        when(() => mockValue.numericValue).thenReturn(0.0);

        final healthDataPoint = MockHealthDataPoint(
          type: HealthDataType.STEPS,
          unit: HealthDataUnit.COUNT,
          dateFrom: DateTime(2024, 1, 1, 10, 0, 0),
          dateTo: DateTime(2024, 1, 1, 11, 0, 0),
          value: mockValue,
          sourceId: 'test-source',
        );

        // Act
        final result = mapper.map([healthDataPoint]);

        // Assert
        expect(result.first.value, equals(0.0));
      });

      test('maps negative numeric values correctly', () {
        // Arrange
        final mockValue = MockNumericHealthValue();
        when(() => mockValue.numericValue).thenReturn(-10.5);

        final healthDataPoint = MockHealthDataPoint(
          type: HealthDataType.BODY_TEMPERATURE,
          unit: HealthDataUnit.DEGREE_CELSIUS,
          dateFrom: DateTime(2024, 1, 1, 10, 0, 0),
          dateTo: DateTime(2024, 1, 1, 10, 1, 0),
          value: mockValue,
          sourceId: 'test-source',
        );

        // Act
        final result = mapper.map([healthDataPoint]);

        // Assert
        expect(result.first.value, equals(-10.5));
      });
    });

    group('workout health value mapping', () {
      test('maps workout values to structured data correctly', () {
        // Arrange
        final mockValue = MockWorkoutHealthValue();
        when(() => mockValue.workoutActivityType)
            .thenReturn(HealthWorkoutActivityType.RUNNING);
        when(() => mockValue.totalEnergyBurned).thenReturn(350);
        when(() => mockValue.totalDistance).thenReturn(5000);

        final healthDataPoint = MockHealthDataPoint(
          type: HealthDataType.WORKOUT,
          unit: HealthDataUnit.NO_UNIT,
          dateFrom: DateTime(2024, 1, 1, 10, 0, 0),
          dateTo: DateTime(2024, 1, 1, 11, 0, 0),
          value: mockValue,
          sourceId: 'workout-source',
        );

        // Act
        final result = mapper.map([healthDataPoint]);

        // Assert
        final workoutData = result.first.value as Map<String, dynamic>;
        expect(workoutData['workoutActivityType'], equals('RUNNING'));
        expect(workoutData['totalEnergyBurned'], equals(350));
        expect(workoutData['totalDistance'], equals(5000));
      });

      test('maps workout values with null fields correctly', () {
        // Arrange
        final mockValue = MockWorkoutHealthValue();
        when(() => mockValue.workoutActivityType)
            .thenReturn(HealthWorkoutActivityType.OTHER);
        when(() => mockValue.totalEnergyBurned).thenReturn(null);
        when(() => mockValue.totalDistance).thenReturn(null);

        final healthDataPoint = MockHealthDataPoint(
          type: HealthDataType.WORKOUT,
          unit: HealthDataUnit.NO_UNIT,
          dateFrom: DateTime(2024, 1, 1, 10, 0, 0),
          dateTo: DateTime(2024, 1, 1, 11, 0, 0),
          value: mockValue,
          sourceId: 'workout-source',
        );

        // Act
        final result = mapper.map([healthDataPoint]);

        // Assert
        final workoutData = result.first.value as Map<String, dynamic>;
        expect(workoutData['workoutActivityType'], equals('OTHER'));
        expect(workoutData['totalEnergyBurned'], isNull);
        expect(workoutData['totalDistance'], isNull);
      });

      test('maps different workout activity types correctly', () {
        final testCases = [
          HealthWorkoutActivityType.RUNNING,
          HealthWorkoutActivityType.WALKING,
          HealthWorkoutActivityType.SWIMMING,
          HealthWorkoutActivityType.OTHER,
        ];

        for (final activityType in testCases) {
          // Arrange
          final mockValue = MockWorkoutHealthValue();
          when(() => mockValue.workoutActivityType).thenReturn(activityType);
          when(() => mockValue.totalEnergyBurned).thenReturn(100);
          when(() => mockValue.totalDistance).thenReturn(1000);

          final healthDataPoint = MockHealthDataPoint(
            type: HealthDataType.WORKOUT,
            unit: HealthDataUnit.NO_UNIT,
            dateFrom: DateTime(2024, 1, 1, 10, 0, 0),
            dateTo: DateTime(2024, 1, 1, 11, 0, 0),
            value: mockValue,
            sourceId: 'test-source',
          );

          // Act
          final result = mapper.map([healthDataPoint]);

          // Assert
          final workoutData = result.first.value as Map<String, dynamic>;
          expect(workoutData['workoutActivityType'], equals(activityType.name));
        }
      });
    });

    group('nutrition health value mapping', () {
      test('maps nutrition values to structured data correctly', () {
        // Arrange
        final mockValue = MockNutritionHealthValue();
        when(() => mockValue.calories).thenReturn(250.0);
        when(() => mockValue.protein).thenReturn(15.5);
        when(() => mockValue.carbs).thenReturn(30.0);
        when(() => mockValue.fat).thenReturn(8.5);

        final healthDataPoint = MockHealthDataPoint(
          type: HealthDataType.NUTRITION,
          unit: HealthDataUnit.KILOCALORIE,
          dateFrom: DateTime(2024, 1, 1, 12, 0, 0),
          dateTo: DateTime(2024, 1, 1, 12, 30, 0),
          value: mockValue,
          sourceId: 'nutrition-source',
        );

        // Act
        final result = mapper.map([healthDataPoint]);

        // Assert
        final nutritionData = result.first.value as Map<String, dynamic>;
        expect(nutritionData['calories'], equals(250.0));
        expect(nutritionData['protein'], equals(15.5));
        expect(nutritionData['carbs'], equals(30.0));
        expect(nutritionData['fat'], equals(8.5));
      });

      test('maps nutrition values with null fields correctly', () {
        // Arrange
        final mockValue = MockNutritionHealthValue();
        when(() => mockValue.calories).thenReturn(200.0);
        when(() => mockValue.protein).thenReturn(null);
        when(() => mockValue.carbs).thenReturn(null);
        when(() => mockValue.fat).thenReturn(null);

        final healthDataPoint = MockHealthDataPoint(
          type: HealthDataType.NUTRITION,
          unit: HealthDataUnit.KILOCALORIE,
          dateFrom: DateTime(2024, 1, 1, 12, 0, 0),
          dateTo: DateTime(2024, 1, 1, 12, 30, 0),
          value: mockValue,
          sourceId: 'nutrition-source',
        );

        // Act
        final result = mapper.map([healthDataPoint]);

        // Assert
        final nutritionData = result.first.value as Map<String, dynamic>;
        expect(nutritionData['calories'], equals(200.0));
        expect(nutritionData['protein'], isNull);
        expect(nutritionData['carbs'], isNull);
        expect(nutritionData['fat'], isNull);
      });

      test('maps zero nutrition values correctly', () {
        // Arrange
        final mockValue = MockNutritionHealthValue();
        when(() => mockValue.calories).thenReturn(0.0);
        when(() => mockValue.protein).thenReturn(0.0);
        when(() => mockValue.carbs).thenReturn(0.0);
        when(() => mockValue.fat).thenReturn(0.0);

        final healthDataPoint = MockHealthDataPoint(
          type: HealthDataType.NUTRITION,
          unit: HealthDataUnit.KILOCALORIE,
          dateFrom: DateTime(2024, 1, 1, 12, 0, 0),
          dateTo: DateTime(2024, 1, 1, 12, 30, 0),
          value: mockValue,
          sourceId: 'nutrition-source',
        );

        // Act
        final result = mapper.map([healthDataPoint]);

        // Assert
        final nutritionData = result.first.value as Map<String, dynamic>;
        expect(nutritionData['calories'], equals(0.0));
        expect(nutritionData['protein'], equals(0.0));
        expect(nutritionData['carbs'], equals(0.0));
        expect(nutritionData['fat'], equals(0.0));
      });
    });

    group('unknown health value mapping', () {
      test('maps unknown health values to string representation', () {
        final testValue = TestHealthValue('SLEEP_DEEP');

        final healthDataPoint = MockHealthDataPoint(
          type: HealthDataType.SLEEP_DEEP,
          unit: HealthDataUnit.NO_UNIT,
          dateFrom: DateTime(2024, 1, 1, 22, 0, 0),
          dateTo: DateTime(2024, 1, 2, 6, 0, 0),
          value: testValue,
          sourceId: 'sleep-source',
        );

        final result = mapper.map([healthDataPoint]);

        expect(result.first.value, equals('SLEEP_DEEP'));
      });

      test('handles custom health value types', () {
        final testValue = TestHealthValue('CUSTOM_HEALTH_VALUE');

        final healthDataPoint = MockHealthDataPoint(
          type: HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
          unit: HealthDataUnit.MILLIMETER_OF_MERCURY,
          dateFrom: DateTime(2024, 1, 1, 10, 0, 0),
          dateTo: DateTime(2024, 1, 1, 10, 1, 0),
          value: testValue,
          sourceId: 'custom-source',
        );

        final result = mapper.map([healthDataPoint]);

        expect(result.first.value, equals('CUSTOM_HEALTH_VALUE'));
      });
    });

    group('source ID extraction', () {
      test('extracts source ID when available', () {
        final mockValue = MockNumericHealthValue();
        when(() => mockValue.numericValue).thenReturn(1000.0);

        final healthDataPoint = MockHealthDataPoint(
          type: HealthDataType.STEPS,
          unit: HealthDataUnit.COUNT,
          dateFrom: DateTime(2024, 1, 1, 10, 0, 0),
          dateTo: DateTime(2024, 1, 1, 11, 0, 0),
          value: mockValue,
          sourceId: 'primary-source-id',
          sourceName: 'Secondary Source',
        );

        final result = mapper.map([healthDataPoint]);

        expect(result.first.sourceId, equals('primary-source-id'));
      });

      test('falls back to source name when source ID is empty', () {
        final mockValue = MockNumericHealthValue();
        when(() => mockValue.numericValue).thenReturn(1000.0);

        final healthDataPoint = MockHealthDataPoint(
          type: HealthDataType.STEPS,
          unit: HealthDataUnit.COUNT,
          dateFrom: DateTime(2024, 1, 1, 10, 0, 0),
          dateTo: DateTime(2024, 1, 1, 11, 0, 0),
          value: mockValue,
          sourceId: '',
          sourceName: 'Fallback Source Name',
        );

        final result = mapper.map([healthDataPoint]);

        expect(result.first.sourceId, equals('Fallback Source Name'));
      });

      test('falls back to source device ID when source ID and name are empty',
          () {
        final mockValue = MockNumericHealthValue();
        when(() => mockValue.numericValue).thenReturn(1000.0);

        final healthDataPoint = MockHealthDataPoint(
          type: HealthDataType.STEPS,
          unit: HealthDataUnit.COUNT,
          dateFrom: DateTime(2024, 1, 1, 10, 0, 0),
          dateTo: DateTime(2024, 1, 1, 11, 0, 0),
          value: mockValue,
          sourceId: '',
          sourceName: '',
        );

        final result = mapper.map([healthDataPoint]);

        expect(result.first.sourceId, isNull);
      });

      test('trims whitespace from source identifiers', () {
        final mockValue = MockNumericHealthValue();
        when(() => mockValue.numericValue).thenReturn(1000.0);

        final healthDataPoint = MockHealthDataPoint(
          type: HealthDataType.STEPS,
          unit: HealthDataUnit.COUNT,
          dateFrom: DateTime(2024, 1, 1, 10, 0, 0),
          dateTo: DateTime(2024, 1, 1, 11, 0, 0),
          value: mockValue,
          sourceId: '  trimmed-source-id  ',
          sourceName: 'Other Source',
        );

        final result = mapper.map([healthDataPoint]);

        expect(result.first.sourceId, equals('trimmed-source-id'));
      });

      test('returns null when all source identifiers are empty or whitespace',
          () {
        final mockValue = MockNumericHealthValue();
        when(() => mockValue.numericValue).thenReturn(1000.0);

        final healthDataPoint = MockHealthDataPoint(
          type: HealthDataType.STEPS,
          unit: HealthDataUnit.COUNT,
          dateFrom: DateTime(2024, 1, 1, 10, 0, 0),
          dateTo: DateTime(2024, 1, 1, 11, 0, 0),
          value: mockValue,
          sourceId: '   ',
          sourceName: '',
        );

        final result = mapper.map([healthDataPoint]);

        expect(result.first.sourceId, isNull);
      });
    });

    group('date formatting', () {
      test('formats dates to ISO8601 strings correctly', () {
        final mockValue = MockNumericHealthValue();
        when(() => mockValue.numericValue).thenReturn(1000.0);

        final startDate = DateTime(2024, 3, 15, 14, 30, 45, 123);
        final endDate = DateTime(2024, 3, 15, 15, 30, 45, 456);

        final healthDataPoint = MockHealthDataPoint(
          type: HealthDataType.STEPS,
          unit: HealthDataUnit.COUNT,
          dateFrom: startDate,
          dateTo: endDate,
          value: mockValue,
          sourceId: 'test-source',
        );

        final result = mapper.map([healthDataPoint]);

        expect(result.first.dateFrom, equals('2024-03-15T14:30:45.123'));
        expect(result.first.dateTo, equals('2024-03-15T15:30:45.456'));
      });

      test('handles edge case dates correctly', () {
        final edgeCases = [
          DateTime(2024, 1, 1, 0, 0, 0), // Beginning of year
          DateTime(2024, 2, 29, 23, 59, 59), // Leap year
          DateTime(2024, 12, 31, 23, 59, 59, 999), // End of year
        ];

        for (final date in edgeCases) {
          final mockValue = MockNumericHealthValue();
          when(() => mockValue.numericValue).thenReturn(1000.0);

          final healthDataPoint = MockHealthDataPoint(
            type: HealthDataType.STEPS,
            unit: HealthDataUnit.COUNT,
            dateFrom: date,
            dateTo: date.add(const Duration(hours: 1)),
            value: mockValue,
            sourceId: 'test-source',
          );

          final result = mapper.map([healthDataPoint]);

          expect(result.first.dateFrom, equals(date.toIso8601String()));
          expect(
            result.first.dateTo,
            equals(date.add(const Duration(hours: 1)).toIso8601String()),
          );
        }
      });
    });

    group('health data type and unit mapping', () {
      test('maps different health data types correctly', () {
        final testCases = [
          (HealthDataType.STEPS, HealthDataUnit.COUNT),
          (HealthDataType.HEART_RATE, HealthDataUnit.BEATS_PER_MINUTE),
          (HealthDataType.DISTANCE_DELTA, HealthDataUnit.METER),
          (HealthDataType.ACTIVE_ENERGY_BURNED, HealthDataUnit.KILOCALORIE),
          (HealthDataType.SLEEP_SESSION, HealthDataUnit.NO_UNIT),
        ];

        for (final (type, unit) in testCases) {
          final mockValue = MockNumericHealthValue();
          when(() => mockValue.numericValue).thenReturn(100.0);

          final healthDataPoint = MockHealthDataPoint(
            type: type,
            unit: unit,
            dateFrom: DateTime(2024, 1, 1, 10, 0, 0),
            dateTo: DateTime(2024, 1, 1, 11, 0, 0),
            value: mockValue,
            sourceId: 'test-source',
          );

          final result = mapper.map([healthDataPoint]);

          expect(result.first.type, equals(type.name));
          expect(result.first.unit, equals(unit.name));
        }
      });
    });

    group('edge cases', () {
      test('handles very large lists efficiently', () {
        final largeList = List.generate(1000, (index) {
          final mockValue = MockNumericHealthValue();
          when(() => mockValue.numericValue).thenReturn(index.toDouble());

          return MockHealthDataPoint(
            type: HealthDataType.STEPS,
            unit: HealthDataUnit.COUNT,
            dateFrom:
                DateTime(2024, 1, 1, 10, 0, 0).add(Duration(minutes: index)),
            dateTo:
                DateTime(2024, 1, 1, 10, 1, 0).add(Duration(minutes: index)),
            value: mockValue,
            sourceId: 'source-$index',
          );
        });

        final result = mapper.map(largeList);

        expect(result.length, equals(1000));
        expect(result.first.value, equals(0.0));
        expect(result.last.value, equals(999.0));
      });

      test('handles mixed health value types in single list', () {
        final mockNumericValue = MockNumericHealthValue();
        final mockWorkoutValue = MockWorkoutHealthValue();
        final mockNutritionValue = MockNutritionHealthValue();
        final testUnknownValue = TestHealthValue('UNKNOWN_VALUE');

        when(() => mockNumericValue.numericValue).thenReturn(1000.0);
        when(() => mockWorkoutValue.workoutActivityType)
            .thenReturn(HealthWorkoutActivityType.RUNNING);
        when(() => mockWorkoutValue.totalEnergyBurned).thenReturn(350);
        when(() => mockWorkoutValue.totalDistance).thenReturn(5000);
        when(() => mockNutritionValue.calories).thenReturn(250.0);
        when(() => mockNutritionValue.protein).thenReturn(15.0);
        when(() => mockNutritionValue.carbs).thenReturn(30.0);
        when(() => mockNutritionValue.fat).thenReturn(8.0);

        final mixedDataPoints = [
          MockHealthDataPoint(
            type: HealthDataType.STEPS,
            unit: HealthDataUnit.COUNT,
            dateFrom: DateTime(2024, 1, 1, 10, 0, 0),
            dateTo: DateTime(2024, 1, 1, 11, 0, 0),
            value: mockNumericValue,
            sourceId: 'numeric-source',
          ),
          MockHealthDataPoint(
            type: HealthDataType.WORKOUT,
            unit: HealthDataUnit.NO_UNIT,
            dateFrom: DateTime(2024, 1, 1, 11, 0, 0),
            dateTo: DateTime(2024, 1, 1, 12, 0, 0),
            value: mockWorkoutValue,
            sourceId: 'workout-source',
          ),
          MockHealthDataPoint(
            type: HealthDataType.NUTRITION,
            unit: HealthDataUnit.KILOCALORIE,
            dateFrom: DateTime(2024, 1, 1, 12, 0, 0),
            dateTo: DateTime(2024, 1, 1, 12, 30, 0),
            value: mockNutritionValue,
            sourceId: 'nutrition-source',
          ),
          MockHealthDataPoint(
            type: HealthDataType.SLEEP_DEEP,
            unit: HealthDataUnit.NO_UNIT,
            dateFrom: DateTime(2024, 1, 1, 22, 0, 0),
            dateTo: DateTime(2024, 1, 2, 6, 0, 0),
            value: testUnknownValue,
            sourceId: 'sleep-source',
          ),
        ];

        final result = mapper.map(mixedDataPoints);

        expect(result.length, equals(4));
        expect(result[0].value, equals(1000.0));
        expect(result[1].value, isA<Map<String, dynamic>>());
        expect(result[2].value, isA<Map<String, dynamic>>());
        expect(result[3].value, equals('UNKNOWN_VALUE'));
      });
    });
  });
}
