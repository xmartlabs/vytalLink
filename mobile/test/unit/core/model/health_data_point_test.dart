import 'package:flutter_template/core/model/health_data_point.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppHealthDataPoint', () {
    group('SimpleHealthDataPoint', () {
      test('creates raw health data point correctly', () {
        const dataPoint = AppHealthDataPoint.raw(
          type: 'STEPS',
          value: 1000,
          unit: 'COUNT',
          dateFrom: '2024-01-01T10:00:00.000Z',
          dateTo: '2024-01-01T11:00:00.000Z',
          sourceId: 'test-source',
        );

        expect(dataPoint.type, equals('STEPS'));
        expect(dataPoint.value, equals(1000));
        expect(dataPoint.unit, equals('COUNT'));
        expect(dataPoint.dateFrom, equals('2024-01-01T10:00:00.000Z'));
        expect(dataPoint.dateTo, equals('2024-01-01T11:00:00.000Z'));
        expect(dataPoint.sourceId, equals('test-source'));
      });

      test('handles different value types', () {
        final testCases = [
          1000, // int
          1500.5, // double
          'SLEEP', // string
          true, // bool
        ];

        for (final value in testCases) {
          final dataPoint = AppHealthDataPoint.raw(
            type: 'TEST_TYPE',
            value: value,
            unit: 'TEST_UNIT',
            dateFrom: '2024-01-01T10:00:00.000Z',
            dateTo: '2024-01-01T11:00:00.000Z',
            sourceId: 'test-source',
          );

          expect(dataPoint.value, equals(value));
        }
      });

      test('handles null sourceId', () {
        const dataPoint = AppHealthDataPoint.raw(
          type: 'STEPS',
          value: 1000,
          unit: 'COUNT',
          dateFrom: '2024-01-01T10:00:00.000Z',
          dateTo: '2024-01-01T11:00:00.000Z',
          sourceId: null,
        );

        expect(dataPoint.sourceId, isNull);
      });
    });

    group('AggregatedHealthDataPoint', () {
      test('creates aggregated health data point correctly', () {
        const dataPoint = AppHealthDataPoint.aggregated(
          type: 'STEPS',
          value: 1500.5,
          unit: 'COUNT',
          dateFrom: '2024-01-01T00:00:00.000Z',
          dateTo: '2024-01-02T00:00:00.000Z',
          sourceId: 'aggregated-source',
        );

        expect(dataPoint.type, equals('STEPS'));
        expect(dataPoint.value, equals(1500.5));
        expect(dataPoint.unit, equals('COUNT'));
        expect(dataPoint.dateFrom, equals('2024-01-01T00:00:00.000Z'));
        expect(dataPoint.dateTo, equals('2024-01-02T00:00:00.000Z'));
        expect(dataPoint.sourceId, equals('aggregated-source'));
      });

      test('enforces double value type', () {
        const dataPoint = AppHealthDataPoint.aggregated(
          type: 'HEART_RATE',
          value: 80.5,
          unit: 'BPM',
          dateFrom: '2024-01-01T10:00:00.000Z',
          dateTo: '2024-01-01T10:01:00.000Z',
          sourceId: 'heart-monitor',
        );

        expect(dataPoint.value, isA<double>());
        expect(dataPoint.value, equals(80.5));
      });

      test('handles null sourceId in aggregated data', () {
        const dataPoint = AppHealthDataPoint.aggregated(
          type: 'STEPS',
          value: 2000.0,
          unit: 'COUNT',
          dateFrom: '2024-01-01T00:00:00.000Z',
          dateTo: '2024-01-02T00:00:00.000Z',
          sourceId: null,
        );

        expect(dataPoint.sourceId, isNull);
      });
    });

    group('JSON serialization', () {
      test('serializes raw health data point to JSON', () {
        const dataPoint = AppHealthDataPoint.raw(
          type: 'STEPS',
          value: 1000,
          unit: 'COUNT',
          dateFrom: '2024-01-01T10:00:00.000Z',
          dateTo: '2024-01-01T11:00:00.000Z',
          sourceId: 'test-source',
        );

        final json = dataPoint.toJson();

        expect(json['type'], equals('STEPS'));
        expect(json['value'], equals(1000));
        expect(json['unit'], equals('COUNT'));
        expect(json['date_from'], equals('2024-01-01T10:00:00.000Z'));
        expect(json['date_to'], equals('2024-01-01T11:00:00.000Z'));
        expect(json['source_id'], equals('test-source'));
        expect(json['runtimeType'], equals('raw'));
      });

      test('serializes aggregated health data point to JSON', () {
        const dataPoint = AppHealthDataPoint.aggregated(
          type: 'STEPS',
          value: 1500.5,
          unit: 'COUNT',
          dateFrom: '2024-01-01T00:00:00.000Z',
          dateTo: '2024-01-02T00:00:00.000Z',
          sourceId: 'aggregated-source',
        );

        final json = dataPoint.toJson();

        expect(json['type'], equals('STEPS'));
        expect(json['value'], equals(1500.5));
        expect(json['unit'], equals('COUNT'));
        expect(json['date_from'], equals('2024-01-01T00:00:00.000Z'));
        expect(json['date_to'], equals('2024-01-02T00:00:00.000Z'));
        expect(json['source_id'], equals('aggregated-source'));
        expect(json['runtimeType'], equals('aggregated'));
      });

      test('deserializes raw health data point from JSON', () {
        final json = {
          'runtimeType': 'raw',
          'type': 'STEPS',
          'value': 1000,
          'unit': 'COUNT',
          'date_from': '2024-01-01T10:00:00.000Z',
          'date_to': '2024-01-01T11:00:00.000Z',
          'source_id': 'test-source',
        };

        final dataPoint = AppHealthDataPoint.fromJson(json);

        expect(dataPoint, isA<SimpleHealthDataPoint>());
        expect(dataPoint.type, equals('STEPS'));
        expect(dataPoint.value, equals(1000));
        expect(dataPoint.unit, equals('COUNT'));
        expect(dataPoint.dateFrom, equals('2024-01-01T10:00:00.000Z'));
        expect(dataPoint.dateTo, equals('2024-01-01T11:00:00.000Z'));
        expect(dataPoint.sourceId, equals('test-source'));
      });

      test('deserializes aggregated health data point from JSON', () {
        final json = {
          'runtimeType': 'aggregated',
          'type': 'STEPS',
          'value': 1500.5,
          'unit': 'COUNT',
          'date_from': '2024-01-01T00:00:00.000Z',
          'date_to': '2024-01-02T00:00:00.000Z',
          'source_id': 'aggregated-source',
        };

        final dataPoint = AppHealthDataPoint.fromJson(json);

        expect(dataPoint, isA<AggregatedHealthDataPoint>());
        expect(dataPoint.type, equals('STEPS'));
        expect(dataPoint.value, equals(1500.5));
        expect(dataPoint.unit, equals('COUNT'));
        expect(dataPoint.dateFrom, equals('2024-01-01T00:00:00.000Z'));
        expect(dataPoint.dateTo, equals('2024-01-02T00:00:00.000Z'));
        expect(dataPoint.sourceId, equals('aggregated-source'));
      });

      test('handles null sourceId in JSON', () {
        final json = {
          'runtimeType': 'raw',
          'type': 'STEPS',
          'value': 1000,
          'unit': 'COUNT',
          'date_from': '2024-01-01T10:00:00.000Z',
          'date_to': '2024-01-01T11:00:00.000Z',
          'source_id': null,
        };

        final dataPoint = AppHealthDataPoint.fromJson(json);

        expect(dataPoint.sourceId, isNull);
      });

      test('handles missing sourceId in JSON', () {
        final json = {
          'runtimeType': 'raw',
          'type': 'STEPS',
          'value': 1000,
          'unit': 'COUNT',
          'date_from': '2024-01-01T10:00:00.000Z',
          'date_to': '2024-01-01T11:00:00.000Z',
          // source_id is missing
        };

        final dataPoint = AppHealthDataPoint.fromJson(json);

        expect(dataPoint.sourceId, isNull);
      });
    });

    group('polymorphism', () {
      test('can store different types in same list', () {
        final dataPoints = <AppHealthDataPoint>[
          const AppHealthDataPoint.raw(
            type: 'STEPS',
            value: 1000,
            unit: 'COUNT',
            dateFrom: '2024-01-01T10:00:00.000Z',
            dateTo: '2024-01-01T11:00:00.000Z',
            sourceId: 'raw-source',
          ),
          const AppHealthDataPoint.aggregated(
            type: 'STEPS',
            value: 1500.5,
            unit: 'COUNT',
            dateFrom: '2024-01-01T00:00:00.000Z',
            dateTo: '2024-01-02T00:00:00.000Z',
            sourceId: 'aggregated-source',
          ),
        ];

        expect(dataPoints.length, equals(2));
        expect(dataPoints[0], isA<SimpleHealthDataPoint>());
        expect(dataPoints[1], isA<AggregatedHealthDataPoint>());
        expect(dataPoints[0].value, equals(1000));
        expect(dataPoints[1].value, equals(1500.5));
      });

      test('can differentiate between types using pattern matching', () {
        const rawPoint = AppHealthDataPoint.raw(
          type: 'STEPS',
          value: 1000,
          unit: 'COUNT',
          dateFrom: '2024-01-01T10:00:00.000Z',
          dateTo: '2024-01-01T11:00:00.000Z',
          sourceId: 'raw-source',
        );

        const aggregatedPoint = AppHealthDataPoint.aggregated(
          type: 'STEPS',
          value: 1500.5,
          unit: 'COUNT',
          dateFrom: '2024-01-01T00:00:00.000Z',
          dateTo: '2024-01-02T00:00:00.000Z',
          sourceId: 'aggregated-source',
        );

        expect(
          rawPoint.when(
            raw: (type, value, unit, dateFrom, dateTo, sourceId) => 'raw',
            aggregated: (type, value, unit, dateFrom, dateTo, sourceId) =>
                'aggregated',
          ),
          equals('raw'),
        );

        expect(
          aggregatedPoint.when(
            raw: (type, value, unit, dateFrom, dateTo, sourceId) => 'raw',
            aggregated: (type, value, unit, dateFrom, dateTo, sourceId) =>
                'aggregated',
          ),
          equals('aggregated'),
        );
      });
    });

    group('edge cases', () {
      test('handles empty string values', () {
        const dataPoint = AppHealthDataPoint.raw(
          type: '',
          value: '',
          unit: '',
          dateFrom: '',
          dateTo: '',
          sourceId: '',
        );

        expect(dataPoint.type, isEmpty);
        expect(dataPoint.value, isEmpty);
        expect(dataPoint.unit, isEmpty);
        expect(dataPoint.dateFrom, isEmpty);
        expect(dataPoint.dateTo, isEmpty);
        expect(dataPoint.sourceId, isEmpty);
      });

      test('handles special characters in string fields', () {
        const dataPoint = AppHealthDataPoint.raw(
          type: 'TYPE_WITH_SPECIAL_CHARS_!@#\$%^&*()',
          value: 'VALUE_WITH_UNICODE_ëñ',
          unit: 'UNIT_WITH_SYMBOLS_±≈',
          dateFrom: '2024-01-01T10:00:00.000Z',
          dateTo: '2024-01-01T11:00:00.000Z',
          sourceId: 'SOURCE_WITH_SPACES AND SYMBOLS !@#',
        );

        expect(dataPoint.type, equals('TYPE_WITH_SPECIAL_CHARS_!@#\$%^&*()'));
        expect(dataPoint.value, equals('VALUE_WITH_UNICODE_ëñ'));
        expect(dataPoint.unit, equals('UNIT_WITH_SYMBOLS_±≈'));
        expect(
          dataPoint.sourceId,
          equals('SOURCE_WITH_SPACES AND SYMBOLS !@#'),
        );
      });

      test('handles very large numeric values', () {
        const dataPoint = AppHealthDataPoint.aggregated(
          type: 'LARGE_VALUE',
          value: 1e20, // Very large double
          unit: 'COUNT',
          dateFrom: '2024-01-01T10:00:00.000Z',
          dateTo: '2024-01-01T11:00:00.000Z',
          sourceId: 'test-source',
        );

        expect(dataPoint.value, equals(1e20));
      });

      test('handles very small numeric values', () {
        const dataPoint = AppHealthDataPoint.aggregated(
          type: 'SMALL_VALUE',
          value: 1e-20, // Very small double
          unit: 'COUNT',
          dateFrom: '2024-01-01T10:00:00.000Z',
          dateTo: '2024-01-01T11:00:00.000Z',
          sourceId: 'test-source',
        );

        expect(dataPoint.value, equals(1e-20));
      });
    });

    group('round-trip serialization', () {
      test('maintains data integrity through serialization cycles for raw data',
          () {
        const originalPoint = AppHealthDataPoint.raw(
          type: 'COMPLEX_TYPE',
          value: {'nested': 'value', 'number': 42},
          unit: 'COMPLEX_UNIT',
          dateFrom: '2024-01-01T10:00:00.000Z',
          dateTo: '2024-01-01T11:00:00.000Z',
          sourceId: 'complex-source',
        );

        var currentPoint = originalPoint;
        for (int i = 0; i < 3; i++) {
          final json = currentPoint.toJson();
          currentPoint = AppHealthDataPoint.fromJson(json);
        }

        expect(currentPoint.type, equals(originalPoint.type));
        expect(currentPoint.value, equals(originalPoint.value));
        expect(currentPoint.unit, equals(originalPoint.unit));
        expect(currentPoint.dateFrom, equals(originalPoint.dateFrom));
        expect(currentPoint.dateTo, equals(originalPoint.dateTo));
        expect(currentPoint.sourceId, equals(originalPoint.sourceId));
      });

      test(
          // ignore: lines_longer_than_80_chars
          'maintains data integrity through serialization cycles for aggregated data',
          () {
        const originalPoint = AppHealthDataPoint.aggregated(
          type: 'AGGREGATED_TYPE',
          value: 123.456789,
          unit: 'PRECISE_UNIT',
          dateFrom: '2024-01-01T00:00:00.000Z',
          dateTo: '2024-01-02T00:00:00.000Z',
          sourceId: 'precision-source',
        );

        var currentPoint = originalPoint;
        for (int i = 0; i < 3; i++) {
          final json = currentPoint.toJson();
          currentPoint = AppHealthDataPoint.fromJson(json);
        }

        expect(currentPoint.type, equals(originalPoint.type));
        expect(currentPoint.value, equals(originalPoint.value));
        expect(currentPoint.unit, equals(originalPoint.unit));
        expect(currentPoint.dateFrom, equals(originalPoint.dateFrom));
        expect(currentPoint.dateTo, equals(originalPoint.dateTo));
        expect(currentPoint.sourceId, equals(originalPoint.sourceId));
      });
    });

    group('equality', () {
      test('two raw points with same values are equal', () {
        const point1 = AppHealthDataPoint.raw(
          type: 'STEPS',
          value: 1000,
          unit: 'COUNT',
          dateFrom: '2024-01-01T10:00:00.000Z',
          dateTo: '2024-01-01T11:00:00.000Z',
          sourceId: 'test-source',
        );

        const point2 = AppHealthDataPoint.raw(
          type: 'STEPS',
          value: 1000,
          unit: 'COUNT',
          dateFrom: '2024-01-01T10:00:00.000Z',
          dateTo: '2024-01-01T11:00:00.000Z',
          sourceId: 'test-source',
        );

        expect(point1, equals(point2));
        expect(point1.hashCode, equals(point2.hashCode));
      });

      test('two aggregated points with same values are equal', () {
        const point1 = AppHealthDataPoint.aggregated(
          type: 'STEPS',
          value: 1500.5,
          unit: 'COUNT',
          dateFrom: '2024-01-01T00:00:00.000Z',
          dateTo: '2024-01-02T00:00:00.000Z',
          sourceId: 'test-source',
        );

        const point2 = AppHealthDataPoint.aggregated(
          type: 'STEPS',
          value: 1500.5,
          unit: 'COUNT',
          dateFrom: '2024-01-01T00:00:00.000Z',
          dateTo: '2024-01-02T00:00:00.000Z',
          sourceId: 'test-source',
        );

        expect(point1, equals(point2));
        expect(point1.hashCode, equals(point2.hashCode));
      });

      test('raw and aggregated points with same data are not equal', () {
        const rawPoint = AppHealthDataPoint.raw(
          type: 'STEPS',
          value: 1000,
          unit: 'COUNT',
          dateFrom: '2024-01-01T10:00:00.000Z',
          dateTo: '2024-01-01T11:00:00.000Z',
          sourceId: 'test-source',
        );

        const aggregatedPoint = AppHealthDataPoint.aggregated(
          type: 'STEPS',
          value: 1000.0,
          unit: 'COUNT',
          dateFrom: '2024-01-01T10:00:00.000Z',
          dateTo: '2024-01-01T11:00:00.000Z',
          sourceId: 'test-source',
        );

        expect(rawPoint, isNot(equals(aggregatedPoint)));
      });
    });
  });
}
