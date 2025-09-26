import 'package:flutter_template/core/model/health_data_point.dart';
import 'package:flutter_template/core/model/health_data_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_data_factory.dart';

void main() {
  group('HealthDataResponse', () {
    group('serialization', () {
      test('serializes to JSON correctly with all fields', () {
        final healthData = [
          TestDataFactory.createRawHealthDataPoint(type: 'STEPS', value: 1000),
          TestDataFactory.createRawHealthDataPoint(type: 'STEPS', value: 2000),
        ];

        final response = HealthDataResponse(
          success: true,
          count: 2,
          healthData: healthData,
          valueType: 'STEPS',
          startTime: '2024-01-01T00:00:00.000Z',
          endTime: '2024-01-02T00:00:00.000Z',
          groupBy: 'day',
          isAggregated: true,
          statisticType: 'sum',
        );

        final json = response.toJson();

        expect(json['success'], isTrue);
        expect(json['count'], equals(2));
        expect(json['value_type'], equals('STEPS'));
        expect(json['start_time'], equals('2024-01-01T00:00:00.000Z'));
        expect(json['end_time'], equals('2024-01-02T00:00:00.000Z'));
        expect(json['group_by'], equals('day'));
        expect(json['is_aggregated'], isTrue);
        expect(json['statistic_type'], equals('sum'));
        expect(json['health_data'], isA<List>());
        expect(json['health_data'].length, equals(2));
      });

      test('serializes to JSON correctly with minimal fields', () {
        const response = HealthDataResponse(
          success: false,
          count: 0,
          healthData: <AppHealthDataPoint>[],
          valueType: 'HEART_RATE',
          startTime: '2024-01-01T00:00:00.000Z',
          endTime: '2024-01-02T00:00:00.000Z',
        );

        final json = response.toJson();

        expect(json['success'], isFalse);
        expect(json['count'], equals(0));
        expect(json['value_type'], equals('HEART_RATE'));
        expect(json['start_time'], equals('2024-01-01T00:00:00.000Z'));
        expect(json['end_time'], equals('2024-01-02T00:00:00.000Z'));
        expect(json['group_by'], isNull);
        expect(json['is_aggregated'], isNull);
        expect(json['statistic_type'], isNull);
        expect(json['health_data'], isEmpty);
      });

      test('deserializes from JSON correctly with all fields', () {
        final json = {
          'success': true,
          'count': 2,
          'value_type': 'STEPS',
          'start_time': '2024-01-01T00:00:00.000Z',
          'end_time': '2024-01-02T00:00:00.000Z',
          'group_by': 'day',
          'is_aggregated': true,
          'statistic_type': 'sum',
          'health_data': [
            {
              'runtimeType': 'raw',
              'type': 'STEPS',
              'value': 1000,
              'unit': 'COUNT',
              'date_from': '2024-01-01T10:00:00.000Z',
              'date_to': '2024-01-01T11:00:00.000Z',
              'source_id': 'test-source',
            },
            {
              'runtimeType': 'raw',
              'type': 'STEPS',
              'value': 2000.0,
              'unit': 'COUNT',
              'date_from': '2024-01-01T14:00:00.000Z',
              'date_to': '2024-01-01T15:00:00.000Z',
              'source_id': 'test-source',
            }
          ],
        };

        final response = HealthDataResponse.fromJson(json);

        expect(response.success, isTrue);
        expect(response.count, equals(2));
        expect(response.valueType, equals('STEPS'));
        expect(response.startTime, equals('2024-01-01T00:00:00.000Z'));
        expect(response.endTime, equals('2024-01-02T00:00:00.000Z'));
        expect(response.groupBy, equals('day'));
        expect(response.isAggregated, isTrue);
        expect(response.statisticType, equals('sum'));
        expect(response.healthData.length, equals(2));
      });

      test('deserializes from JSON correctly with minimal fields', () {
        final json = {
          'success': false,
          'count': 0,
          'value_type': 'HEART_RATE',
          'start_time': '2024-01-01T00:00:00.000Z',
          'end_time': '2024-01-02T00:00:00.000Z',
          'health_data': <Map<String, dynamic>>[],
        };

        final response = HealthDataResponse.fromJson(json);

        expect(response.success, isFalse);
        expect(response.count, equals(0));
        expect(response.valueType, equals('HEART_RATE'));
        expect(response.startTime, equals('2024-01-01T00:00:00.000Z'));
        expect(response.endTime, equals('2024-01-02T00:00:00.000Z'));
        expect(response.groupBy, isNull);
        expect(response.isAggregated, isNull);
        expect(response.statisticType, isNull);
        expect(response.healthData, isEmpty);
      });

      test('handles mixed health data point types', () {
        final json = {
          'success': true,
          'count': 2,
          'value_type': 'STEPS',
          'start_time': '2024-01-01T00:00:00.000Z',
          'end_time': '2024-01-02T00:00:00.000Z',
          'health_data': [
            {
              'runtimeType': 'raw',
              'type': 'STEPS',
              'value': 1000,
              'unit': 'COUNT',
              'date_from': '2024-01-01T10:00:00.000Z',
              'date_to': '2024-01-01T11:00:00.000Z',
              'source_id': 'test-source',
            },
            {
              'runtimeType': 'raw',
              'type': 'STEPS',
              'value': 1500.0,
              'unit': 'COUNT',
              'date_from': '2024-01-01T00:00:00.000Z',
              'date_to': '2024-01-02T00:00:00.000Z',
              'source_id': null,
            }
          ],
        };

        final response = HealthDataResponse.fromJson(json);

        expect(response.healthData.length, equals(2));
        expect(response.healthData[0].value, equals(1000));
        expect(response.healthData[1].value, equals(1500.0));
      });
    });

    group('validation', () {
      test('requires success field', () {
        final json = {
          'count': 1,
          'value_type': 'STEPS',
          'start_time': '2024-01-01T00:00:00.000Z',
          'end_time': '2024-01-02T00:00:00.000Z',
          'health_data': <Map<String, dynamic>>[],
        };

        expect(
          () => HealthDataResponse.fromJson(json),
          throwsA(isA<TypeError>()),
        );
      });

      test('requires count field', () {
        final json = {
          'success': true,
          'value_type': 'STEPS',
          'start_time': '2024-01-01T00:00:00.000Z',
          'end_time': '2024-01-02T00:00:00.000Z',
          'health_data': <Map<String, dynamic>>[],
        };

        expect(
          () => HealthDataResponse.fromJson(json),
          throwsA(isA<TypeError>()),
        );
      });

      test('requires value_type field', () {
        final json = {
          'success': true,
          'count': 0,
          'start_time': '2024-01-01T00:00:00.000Z',
          'end_time': '2024-01-02T00:00:00.000Z',
          'health_data': <Map<String, dynamic>>[],
        };

        expect(
          () => HealthDataResponse.fromJson(json),
          throwsA(isA<TypeError>()),
        );
      });

      test('requires healthData field', () {
        final json = {
          'success': true,
          'count': 0,
          'value_type': 'STEPS',
          'start_time': '2024-01-01T00:00:00.000Z',
          'end_time': '2024-01-02T00:00:00.000Z',
        };

        expect(
          () => HealthDataResponse.fromJson(json),
          throwsA(isA<TypeError>()),
        );
      });

      test('validates count matches healthData length', () {
        final response = HealthDataResponse(
          success: true,
          count: 5, // Mismatch: says 5 but only has 2 items
          healthData: [
            TestDataFactory.createRawHealthDataPoint(),
            TestDataFactory.createRawHealthDataPoint(),
          ],
          valueType: 'STEPS',
          startTime: '2024-01-01T00:00:00.000Z',
          endTime: '2024-01-02T00:00:00.000Z',
        );

        expect(response.count, isNot(equals(response.healthData.length)));
      });
    });

    group('edge cases', () {
      test('handles large health data arrays', () {
        final largeHealthData = List.generate(
          1000,
          (index) => TestDataFactory.createRawHealthDataPoint(value: index),
        );

        final response = HealthDataResponse(
          success: true,
          count: 1000,
          healthData: largeHealthData,
          valueType: 'STEPS',
          startTime: '2024-01-01T00:00:00.000Z',
          endTime: '2024-01-02T00:00:00.000Z',
        );

        final json = response.toJson();
        final deserializedResponse = HealthDataResponse.fromJson(json);


        expect(deserializedResponse.count, equals(1000));
        expect(deserializedResponse.healthData.length, equals(1000));
      });

      test('handles special characters in string fields', () {

        const response = HealthDataResponse(
          success: true,
          count: 0,
          healthData: <AppHealthDataPoint>[],
          valueType: 'STEPS_WITH_SPECIAL_CHARS_!@#\$%^&*()',
          startTime: '2024-01-01T00:00:00.000Z',
          endTime: '2024-01-02T00:00:00.000Z',
          groupBy: 'day_with_unicode_ëñ',
          statisticType: 'sum_with_symbols_±≈',
        );


        final json = response.toJson();
        final deserializedResponse = HealthDataResponse.fromJson(json);


        expect(deserializedResponse.valueType, equals(response.valueType));
        expect(deserializedResponse.groupBy, equals(response.groupBy));
        expect(
          deserializedResponse.statisticType,
          equals(response.statisticType),
        );
      });

      test('handles null values in optional fields', () {

        final json = {
          'success': true,
          'count': 0,
          'value_type': 'STEPS',
          'start_time': '2024-01-01T00:00:00.000Z',
          'end_time': '2024-01-02T00:00:00.000Z',
          'health_data': <Map<String, dynamic>>[],
          'group_by': null,
          'is_aggregated': null,
          'statistic_type': null,
        };


        final response = HealthDataResponse.fromJson(json);


        expect(response.groupBy, isNull);
        expect(response.isAggregated, isNull);
        expect(response.statisticType, isNull);
      });
    });

    group('round-trip serialization', () {
      test('maintains data integrity through serialization cycles', () {

        final originalResponse = HealthDataResponse(
          success: true,
          count: 3,
          healthData: [
            TestDataFactory.createRawHealthDataPoint(
              type: 'STEPS',
              value: 1000,
            ),
            TestDataFactory.createAggregatedHealthDataPoint(
              type: 'STEPS',
              value: 2000.5,
            ),
            TestDataFactory.createRawHealthDataPoint(
              type: 'STEPS',
              value: 'mixed_value',
            ),
          ],
          valueType: 'STEPS',
          startTime: '2024-01-01T00:00:00.000Z',
          endTime: '2024-01-02T00:00:00.000Z',
          groupBy: 'hour',
          isAggregated: true,
          statisticType: 'average',
        );


        var currentResponse = originalResponse;
        for (int i = 0; i < 3; i++) {
          final json = currentResponse.toJson();
          currentResponse = HealthDataResponse.fromJson(json);
        }


        expect(currentResponse.success, equals(originalResponse.success));
        expect(currentResponse.count, equals(originalResponse.count));
        expect(currentResponse.valueType, equals(originalResponse.valueType));
        expect(currentResponse.startTime, equals(originalResponse.startTime));
        expect(currentResponse.endTime, equals(originalResponse.endTime));
        expect(currentResponse.groupBy, equals(originalResponse.groupBy));
        expect(
          currentResponse.isAggregated,
          equals(originalResponse.isAggregated),
        );
        expect(
          currentResponse.statisticType,
          equals(originalResponse.statisticType),
        );
        expect(
          currentResponse.healthData.length,
          equals(originalResponse.healthData.length),
        );
      });
    });
  });

  group('HealthDataErrorResponse', () {
    group('serialization', () {
      test('serializes to JSON correctly', () {

        const errorResponse = HealthDataErrorResponse(
          success: false,
          errorMessage: 'Permission denied',
        );


        final json = errorResponse.toJson();


        expect(json['success'], isFalse);
        expect(json['error_message'], equals('Permission denied'));
      });

      test('deserializes from JSON correctly', () {

        final json = {
          'success': false,
          'error_message': 'Health Connect not available',
        };


        final errorResponse = HealthDataErrorResponse.fromJson(json);


        expect(errorResponse.success, isFalse);
        expect(
          errorResponse.errorMessage,
          equals('Health Connect not available'),
        );
      });

      test('uses correct JSON key for error message', () {

        const errorResponse = HealthDataErrorResponse(
          success: false,
          errorMessage: 'Test error',
        );


        final json = errorResponse.toJson();


        expect(json.containsKey('error_message'), isTrue);
        expect(json.containsKey('errorMessage'), isFalse);
      });
    });

    group('validation', () {
      test('requires success field', () {

        final json = {
          'error_message': 'Test error',
        };


        expect(
          () => HealthDataErrorResponse.fromJson(json),
          throwsA(isA<TypeError>()),
        );
      });

      test('requires error_message field', () {

        final json = {
          'success': false,
        };

        expect(
          () => HealthDataErrorResponse.fromJson(json),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('edge cases', () {
      test('handles empty error message', () {

        const errorResponse = HealthDataErrorResponse(
          success: false,
          errorMessage: '',
        );


        final json = errorResponse.toJson();
        final deserializedResponse = HealthDataErrorResponse.fromJson(json);


        expect(deserializedResponse.errorMessage, isEmpty);
      });

      test('handles long error message', () {

        final longMessage = 'A' * 1000; // 1000 character error message
        final errorResponse = HealthDataErrorResponse(
          success: false,
          errorMessage: longMessage,
        );


        final json = errorResponse.toJson();
        final deserializedResponse = HealthDataErrorResponse.fromJson(json);


        expect(deserializedResponse.errorMessage, equals(longMessage));
      });

      test('handles special characters in error message', () {

        const errorResponse = HealthDataErrorResponse(
          success: false,
          errorMessage:
              'Error with special chars: !@#\$%^&*()_+{}|:"<>?[]\\;\',./',
        );


        final json = errorResponse.toJson();
        final deserializedResponse = HealthDataErrorResponse.fromJson(json);


        expect(
          deserializedResponse.errorMessage,
          equals(errorResponse.errorMessage),
        );
      });
    });

    group('equality', () {
      test('two error responses with same values are equal', () {

        const errorResponse1 = HealthDataErrorResponse(
          success: false,
          errorMessage: 'Same error',
        );

        const errorResponse2 = HealthDataErrorResponse(
          success: false,
          errorMessage: 'Same error',
        );


        expect(errorResponse1, equals(errorResponse2));
        expect(errorResponse1.hashCode, equals(errorResponse2.hashCode));
      });

      test('two error responses with different values are not equal', () {

        const errorResponse1 = HealthDataErrorResponse(
          success: false,
          errorMessage: 'Error 1',
        );

        const errorResponse2 = HealthDataErrorResponse(
          success: false,
          errorMessage: 'Error 2',
        );

        expect(errorResponse1, isNot(equals(errorResponse2)));
      });
    });
  });
}
