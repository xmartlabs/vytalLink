import 'package:flutter_template/core/model/health_data_request.dart';
import 'package:flutter_template/core/model/statistic_types.dart';
import 'package:flutter_template/core/model/time_group_by.dart';
import 'package:flutter_template/model/vytal_health_data_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HealthDataRequest', () {
    group('serialization', () {
      test('serializes to JSON correctly with all fields', () {
        final request = HealthDataRequest(
          valueType: VytalHealthDataCategory.STEPS,
          startTime: DateTime(2024, 1, 1, 10, 0, 0),
          endTime: DateTime(2024, 1, 2, 10, 0, 0),
          groupBy: TimeGroupBy.day,
          statistic: StatisticType.sum,
        );

        final json = request.toJson();

        expect(json['value_type'], equals('STEPS'));
        expect(json['start_time'], equals('2024-01-01T10:00:00.000'));
        expect(json['end_time'], equals('2024-01-02T10:00:00.000'));
        expect(json['group_by'], equals('DAY'));
        expect(json['statistic'], equals('SUM'));
      });

      test('serializes to JSON correctly with minimal fields', () {
        final request = HealthDataRequest(
          valueType: VytalHealthDataCategory.HEART_RATE,
          startTime: DateTime(2024, 1, 1, 10, 0, 0),
          endTime: DateTime(2024, 1, 2, 10, 0, 0),
        );

        final json = request.toJson();

        expect(json['value_type'], equals('HEART_RATE'));
        expect(json['start_time'], equals('2024-01-01T10:00:00.000'));
        expect(json['end_time'], equals('2024-01-02T10:00:00.000'));
        expect(json['group_by'], isNull);
        expect(json['statistic'], isNull);
      });

      test('deserializes from JSON correctly with all fields', () {
        final json = {
          'value_type': 'STEPS',
          'start_time': '2024-01-01T10:00:00.000',
          'end_time': '2024-01-02T10:00:00.000',
          'group_by': 'DAY',
          'statistic': 'SUM',
        };

        final request = HealthDataRequest.fromJson(json);

        expect(request.valueType, equals(VytalHealthDataCategory.STEPS));
        expect(request.startTime, equals(DateTime(2024, 1, 1, 10, 0, 0)));
        expect(request.endTime, equals(DateTime(2024, 1, 2, 10, 0, 0)));
        expect(request.groupBy, equals(TimeGroupBy.day));
        expect(request.statistic, equals(StatisticType.sum));
      });

      test('deserializes from JSON correctly with minimal fields', () {
        final json = {
          'value_type': 'HEART_RATE',
          'start_time': '2024-01-01T10:00:00.000',
          'end_time': '2024-01-02T10:00:00.000',
        };

        final request = HealthDataRequest.fromJson(json);

        expect(request.valueType, equals(VytalHealthDataCategory.HEART_RATE));
        expect(request.startTime, equals(DateTime(2024, 1, 1, 10, 0, 0)));
        expect(request.endTime, equals(DateTime(2024, 1, 2, 10, 0, 0)));
        expect(request.groupBy, isNull);
        expect(request.statistic, isNull);
      });

      test('handles different value types correctly', () {
        final testCases = [
          VytalHealthDataCategory.STEPS,
          VytalHealthDataCategory.HEART_RATE,
          VytalHealthDataCategory.SLEEP,
          VytalHealthDataCategory.DISTANCE,
        ];

        for (final valueType in testCases) {
          final request = HealthDataRequest(
            valueType: valueType,
            startTime: DateTime(2024, 1, 1),
            endTime: DateTime(2024, 1, 2),
          );

          final json = request.toJson();
          final deserializedRequest = HealthDataRequest.fromJson(json);

          expect(deserializedRequest.valueType, equals(valueType));
        }
      });

      test('handles different time group by values correctly', () {
        final testCases = [
          TimeGroupBy.hour,
          TimeGroupBy.day,
          TimeGroupBy.week,
          TimeGroupBy.month,
        ];

        for (final groupBy in testCases) {
          final request = HealthDataRequest(
            valueType: VytalHealthDataCategory.STEPS,
            startTime: DateTime(2024, 1, 1),
            endTime: DateTime(2024, 1, 2),
            groupBy: groupBy,
            statistic: StatisticType.sum,
          );

          final json = request.toJson();
          final deserializedRequest = HealthDataRequest.fromJson(json);

          expect(deserializedRequest.groupBy, equals(groupBy));
        }
      });

      test('handles different statistic types correctly', () {
        final testCases = [
          StatisticType.sum,
          StatisticType.average,
        ];

        for (final statistic in testCases) {
          final request = HealthDataRequest(
            valueType: VytalHealthDataCategory.STEPS,
            startTime: DateTime(2024, 1, 1),
            endTime: DateTime(2024, 1, 2),
            groupBy: TimeGroupBy.day,
            statistic: statistic,
          );

          final json = request.toJson();
          final deserializedRequest = HealthDataRequest.fromJson(json);

          expect(deserializedRequest.statistic, equals(statistic));
        }
      });

      test('preserves exact datetime values', () {
        final startTime = DateTime(2024, 3, 15, 14, 30, 45, 123);
        final endTime = DateTime(2024, 3, 16, 16, 45, 30, 456);

        final request = HealthDataRequest(
          valueType: VytalHealthDataCategory.STEPS,
          startTime: startTime,
          endTime: endTime,
        );

        final json = request.toJson();
        final deserializedRequest = HealthDataRequest.fromJson(json);

        expect(deserializedRequest.startTime, equals(startTime));
        expect(deserializedRequest.endTime, equals(endTime));
      });
    });

    group('validation', () {
      test('handles invalid value type gracefully', () {
        final json = {
          'value_type': 'INVALID_TYPE',
          'start_time': '2024-01-01T10:00:00.000',
          'end_time': '2024-01-02T10:00:00.000',
        };

        expect(
          () => HealthDataRequest.fromJson(json),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('handles invalid date format gracefully', () {
        final json = {
          'value_type': 'STEPS',
          'start_time': 'invalid-date',
          'end_time': '2024-01-02T10:00:00.000',
        };

        expect(
          () => HealthDataRequest.fromJson(json),
          throwsA(isA<FormatException>()),
        );
      });

      test('handles invalid group by value gracefully', () {
        final json = {
          'value_type': 'STEPS',
          'start_time': '2024-01-01T10:00:00.000',
          'end_time': '2024-01-02T10:00:00.000',
          'group_by': 'invalid_group_by',
        };

        expect(
          () => HealthDataRequest.fromJson(json),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('handles invalid statistic type gracefully', () {    
        final json = {
          'value_type': 'STEPS',
          'start_time': '2024-01-01T10:00:00.000',
          'end_time': '2024-01-02T10:00:00.000',
          'group_by': 'DAY',
          'statistic': 'invalid_statistic',
        };

        expect(
          () => HealthDataRequest.fromJson(json),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('requires valueType field', () {
        final json = {
          'start_time': '2024-01-01T10:00:00.000',
          'end_time': '2024-01-02T10:00:00.000',
        };

        expect(
          () => HealthDataRequest.fromJson(json),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('requires startTime field', () {
        final json = {
          'value_type': 'STEPS',
          'end_time': '2024-01-02T10:00:00.000',
        };

        expect(
          () => HealthDataRequest.fromJson(json),
          throwsA(isA<TypeError>()),
        );
      });

      test('requires endTime field', () {
        final json = {
          'value_type': 'STEPS',
          'start_time': '2024-01-01T10:00:00.000',
        };

        expect(
          () => HealthDataRequest.fromJson(json),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('round-trip serialization', () {
      test('maintains data integrity through multiple serialization cycles',
          () {
        final originalRequest = HealthDataRequest(
          valueType: VytalHealthDataCategory.SLEEP,
          startTime: DateTime(2024, 5, 10, 22, 30, 0),
          endTime: DateTime(2024, 5, 11, 7, 0, 0),
          groupBy: TimeGroupBy.hour,
          statistic: StatisticType.average,
        );

        var currentRequest = originalRequest;
        for (int i = 0; i < 5; i++) {
          final json = currentRequest.toJson();
          currentRequest = HealthDataRequest.fromJson(json);
        }

        expect(currentRequest.valueType, equals(originalRequest.valueType));
        expect(currentRequest.startTime, equals(originalRequest.startTime));
        expect(currentRequest.endTime, equals(originalRequest.endTime));
        expect(currentRequest.groupBy, equals(originalRequest.groupBy));
        expect(currentRequest.statistic, equals(originalRequest.statistic));
      });

      test('handles edge case datetime values', () {
        final edgeCases = [
          DateTime(2024, 1, 1, 0, 0, 0), // Beginning of year
          DateTime(2024, 2, 29, 23, 59, 59), // Leap year
          DateTime(
            2024,
            12,
            31,
            23,
            59,
            59,
            999,
          ), // End of year with milliseconds
        ];

        for (final dateTime in edgeCases) {
          final request = HealthDataRequest(
            valueType: VytalHealthDataCategory.STEPS,
            startTime: dateTime,
            endTime: dateTime.add(const Duration(hours: 1)),
          );

          final json = request.toJson();
          final deserializedRequest = HealthDataRequest.fromJson(json);

          expect(deserializedRequest.startTime, equals(request.startTime));
          expect(deserializedRequest.endTime, equals(request.endTime));
        }
      });
    });

    group('equality', () {
      test('two requests with same values are equal', () {
        final request1 = HealthDataRequest(
          valueType: VytalHealthDataCategory.STEPS,
          startTime: DateTime(2024, 1, 1),
          endTime: DateTime(2024, 1, 2),
          groupBy: TimeGroupBy.day,
          statistic: StatisticType.sum,
        );

        final request2 = HealthDataRequest(
          valueType: VytalHealthDataCategory.STEPS,
          startTime: DateTime(2024, 1, 1),
          endTime: DateTime(2024, 1, 2),
          groupBy: TimeGroupBy.day,
          statistic: StatisticType.sum,
        );

        expect(request1, equals(request2));
        expect(request1.hashCode, equals(request2.hashCode));
      });

      test('two requests with different values are not equal', () {
        final request1 = HealthDataRequest(
          valueType: VytalHealthDataCategory.STEPS,
          startTime: DateTime(2024, 1, 1),
          endTime: DateTime(2024, 1, 2),
        );

        final request2 = HealthDataRequest(
          valueType: VytalHealthDataCategory.HEART_RATE,
          startTime: DateTime(2024, 1, 1),
          endTime: DateTime(2024, 1, 2),
        );

        expect(request1, isNot(equals(request2)));
      });

      test('requests with different optional fields are not equal', () {
        final request1 = HealthDataRequest(
          valueType: VytalHealthDataCategory.STEPS,
          startTime: DateTime(2024, 1, 1),
          endTime: DateTime(2024, 1, 2),
        );

        final request2 = HealthDataRequest(
          valueType: VytalHealthDataCategory.STEPS,
          startTime: DateTime(2024, 1, 1),
          endTime: DateTime(2024, 1, 2),
          groupBy: TimeGroupBy.day,
        );

        expect(request1, isNot(equals(request2)));
      });
    });
  });
}
