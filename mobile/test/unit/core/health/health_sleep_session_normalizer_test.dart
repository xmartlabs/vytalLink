import 'package:flutter_template/core/health/health_sleep_session_normalizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health/health.dart';

import '../../../helpers/mock_health_data_point.dart';

void main() {
  group('HealthSleepSessionNormalizer', () {
    late HealthSleepSessionNormalizer normalizer;

    setUp(() {
      normalizer = const HealthSleepSessionNormalizer();
    });

    group('normalize', () {
      test('returns empty list when input is empty', () {
        final result = normalizer.normalize([]);
        expect(result, isEmpty);
      });

      test('returns original list when no sleep sessions are present', () {
        final nonSleepData = [
          TestHealthDataFactory.createStepsDataPoint(
            dateFrom: DateTime(2024, 1, 1, 10),
            dateTo: DateTime(2024, 1, 1, 11),
            steps: 1000,
          ),
          TestHealthDataFactory.createHeartRateDataPoint(
            dateFrom: DateTime(2024, 1, 1, 12),
            dateTo: DateTime(2024, 1, 1, 13),
            heartRate: 70.0,
          ),
        ];

        final result = normalizer.normalize(nonSleepData);
        expect(result, hasLength(2));
        expect(
          result.every((p) => p.type != HealthDataType.SLEEP_SESSION),
          isTrue,
        );
      });

      test('returns single sleep session unchanged when no overlaps', () {
        final sleepSession = TestHealthDataFactory.createSleepDataPoint(
          dateFrom: DateTime(2024, 1, 1, 22),
          dateTo: DateTime(2024, 1, 2, 6),
        );

        final result = normalizer.normalize([sleepSession]);
        expect(result, hasLength(1));
        expect(result.first.type, equals(HealthDataType.SLEEP_SESSION));
      });

      test('preserves non-sleep data points in final result', () {
        final sleepSession = TestHealthDataFactory.createSleepDataPoint(
          dateFrom: DateTime(2024, 1, 1, 22),
          dateTo: DateTime(2024, 1, 2, 6),
        );
        final stepsData = TestHealthDataFactory.createStepsDataPoint(
          dateFrom: DateTime(2024, 1, 1, 10),
          dateTo: DateTime(2024, 1, 1, 11),
          steps: 1000,
        );

        final result = normalizer.normalize([sleepSession, stepsData]);
        expect(result, hasLength(2));
        expect(result.any((p) => p.type == HealthDataType.STEPS), isTrue);
        expect(
          result.any((p) => p.type == HealthDataType.SLEEP_SESSION),
          isTrue,
        );
      });

      test('sorts final result by dateFrom', () {
        final laterSession = TestHealthDataFactory.createSleepDataPoint(
          dateFrom: DateTime(2024, 1, 2, 22),
          dateTo: DateTime(2024, 1, 3, 6),
        );
        final earlierSteps = TestHealthDataFactory.createStepsDataPoint(
          dateFrom: DateTime(2024, 1, 1, 10),
          dateTo: DateTime(2024, 1, 1, 11),
          steps: 1000,
        );

        final result = normalizer.normalize([laterSession, earlierSteps]);
        expect(result.first.dateFrom, equals(DateTime(2024, 1, 1, 10)));
        expect(result.last.dateFrom, equals(DateTime(2024, 1, 2, 22)));
      });

      group('mergeAdjacent strategy', () {
        test('merges overlapping sessions from same source', () {
          final session1 = TestHealthDataFactory.createSleepDataPoint(
            dateFrom: DateTime(2024, 1, 1, 22),
            dateTo: DateTime(2024, 1, 2, 2),
            sourceId: 'apple_health',
          );
          final session2 = TestHealthDataFactory.createSleepDataPoint(
            dateFrom: DateTime(2024, 1, 2, 1),
            dateTo: DateTime(2024, 1, 2, 6),
            sourceId: 'apple_health',
          );

          final result = normalizer.normalize(
            [session1, session2],
            strategy: SleepNormalizationStrategy.mergeAdjacent,
          );

          expect(result, hasLength(1));
          final merged = result.first;
          expect(merged.dateFrom, equals(DateTime(2024, 1, 1, 22)));
          expect(merged.dateTo, equals(DateTime(2024, 1, 2, 6)));
        });

        test('merges sessions within gap tolerance', () {
          final session1 = TestHealthDataFactory.createSleepDataPoint(
            dateFrom: DateTime(2024, 1, 1, 22),
            dateTo: DateTime(2024, 1, 2, 2),
            sourceId: 'apple_health',
          );
          final session2 = TestHealthDataFactory.createSleepDataPoint(
            dateFrom: DateTime(2024, 1, 2, 2, 3), // 3 minutes gap
            dateTo: DateTime(2024, 1, 2, 6),
            sourceId: 'apple_health',
          );

          final result = normalizer.normalize(
            [session1, session2],
            strategy: SleepNormalizationStrategy.mergeAdjacent,
            gapTolerance: const Duration(minutes: 5),
          );

          expect(result, hasLength(1));
          final merged = result.first;
          expect(merged.dateFrom, equals(DateTime(2024, 1, 1, 22)));
          expect(merged.dateTo, equals(DateTime(2024, 1, 2, 6)));
        });

        test('does not merge sessions beyond gap tolerance', () {
          final session1 = TestHealthDataFactory.createSleepDataPoint(
            dateFrom: DateTime(2024, 1, 1, 22),
            dateTo: DateTime(2024, 1, 2, 2),
            sourceId: 'apple_health',
          );
          final session2 = TestHealthDataFactory.createSleepDataPoint(
            dateFrom: DateTime(2024, 1, 2, 2, 10), // 10 minutes gap
            dateTo: DateTime(2024, 1, 2, 6),
            sourceId: 'apple_health',
          );

          final result = normalizer.normalize(
            [session1, session2],
            strategy: SleepNormalizationStrategy.mergeAdjacent,
            gapTolerance: const Duration(minutes: 5),
          );

          expect(result, hasLength(2));
        });

        test('does not merge sessions from different sources', () {
          final session1 = TestHealthDataFactory.createSleepDataPoint(
            dateFrom: DateTime(2024, 1, 1, 22),
            dateTo: DateTime(2024, 1, 2, 2),
            sourceId: 'apple_health',
          );
          final session2 = TestHealthDataFactory.createSleepDataPoint(
            dateFrom: DateTime(2024, 1, 2, 1),
            dateTo: DateTime(2024, 1, 2, 6),
            sourceId: 'fitbit',
          );

          final result = normalizer.normalize(
            [session1, session2],
            strategy: SleepNormalizationStrategy.mergeAdjacent,
          );

          expect(result, hasLength(2));
        });

        test('merges sessions that touch exactly', () {
          final session1 = TestHealthDataFactory.createSleepDataPoint(
            dateFrom: DateTime(2024, 1, 1, 22),
            dateTo: DateTime(2024, 1, 2, 2),
            sourceId: 'apple_health',
          );
          final session2 = TestHealthDataFactory.createSleepDataPoint(
            dateFrom: DateTime(2024, 1, 2, 2), // Exact touch
            dateTo: DateTime(2024, 1, 2, 6),
            sourceId: 'apple_health',
          );

          final result = normalizer.normalize(
            [session1, session2],
            strategy: SleepNormalizationStrategy.mergeAdjacent,
          );

          expect(result, hasLength(1));
          final merged = result.first;
          expect(merged.dateFrom, equals(DateTime(2024, 1, 1, 22)));
          expect(merged.dateTo, equals(DateTime(2024, 1, 2, 6)));
        });
      });

      group('preferConsolidated strategy', () {
        test('prefers longer session when sessions are almost contained', () {
          final shortSession = TestHealthDataFactory.createSleepDataPoint(
            dateFrom: DateTime(2024, 1, 1, 23),
            dateTo: DateTime(2024, 1, 2, 5),
            sourceId: 'apple_health',
          );
          final longSession = TestHealthDataFactory.createSleepDataPoint(
            dateFrom: DateTime(2024, 1, 1, 22),
            dateTo: DateTime(2024, 1, 2, 6),
            sourceId: 'apple_health',
          );

          final result = normalizer.normalize(
            [shortSession, longSession],
            strategy: SleepNormalizationStrategy.preferConsolidated,
            containmentThreshold: 0.8,
          );

          expect(result, hasLength(1));
          final selected = result.first;
          expect(selected.dateFrom, equals(DateTime(2024, 1, 1, 22)));
          expect(selected.dateTo, equals(DateTime(2024, 1, 2, 6)));
        });

        test('merges sessions when not almost contained', () {
          final session1 = TestHealthDataFactory.createSleepDataPoint(
            dateFrom: DateTime(2024, 1, 1, 22),
            dateTo: DateTime(2024, 1, 2, 1),
            sourceId: 'apple_health',
          );
          final session2 = TestHealthDataFactory.createSleepDataPoint(
            dateFrom: DateTime(2024, 1, 2, 0),
            dateTo: DateTime(2024, 1, 2, 6),
            sourceId: 'apple_health',
          );

          final result = normalizer.normalize(
            [session1, session2],
            strategy: SleepNormalizationStrategy.preferConsolidated,
            containmentThreshold: 0.95,
          );

          expect(result, hasLength(1));
          final merged = result.first;
          expect(merged.dateFrom, equals(DateTime(2024, 1, 1, 22)));
          expect(merged.dateTo, equals(DateTime(2024, 1, 2, 6)));
        });
      });

      group('multiple sessions', () {
        test('handles chain of overlapping sessions', () {
          final sessions = [
            TestHealthDataFactory.createSleepDataPoint(
              dateFrom: DateTime(2024, 1, 1, 22),
              dateTo: DateTime(2024, 1, 2, 1),
              sourceId: 'apple_health',
            ),
            TestHealthDataFactory.createSleepDataPoint(
              dateFrom: DateTime(2024, 1, 2, 0),
              dateTo: DateTime(2024, 1, 2, 3),
              sourceId: 'apple_health',
            ),
            TestHealthDataFactory.createSleepDataPoint(
              dateFrom: DateTime(2024, 1, 2, 2),
              dateTo: DateTime(2024, 1, 2, 6),
              sourceId: 'apple_health',
            ),
          ];

          final result = normalizer.normalize(sessions);

          expect(result, hasLength(1));
          final merged = result.first;
          expect(merged.dateFrom, equals(DateTime(2024, 1, 1, 22)));
          expect(merged.dateTo, equals(DateTime(2024, 1, 2, 6)));
        });

        test('handles sessions from multiple sources separately', () {
          final sessions = [
            TestHealthDataFactory.createSleepDataPoint(
              dateFrom: DateTime(2024, 1, 1, 22),
              dateTo: DateTime(2024, 1, 2, 2),
              sourceId: 'apple_health',
            ),
            TestHealthDataFactory.createSleepDataPoint(
              dateFrom: DateTime(2024, 1, 2, 1),
              dateTo: DateTime(2024, 1, 2, 3),
              sourceId: 'apple_health',
            ),
            TestHealthDataFactory.createSleepDataPoint(
              dateFrom: DateTime(2024, 1, 1, 23),
              dateTo: DateTime(2024, 1, 2, 4),
              sourceId: 'fitbit',
            ),
            TestHealthDataFactory.createSleepDataPoint(
              dateFrom: DateTime(2024, 1, 2, 3),
              dateTo: DateTime(2024, 1, 2, 5),
              sourceId: 'fitbit',
            ),
          ];

          final result = normalizer.normalize(sessions);

          expect(result, hasLength(2)); // One merged session per source

          // Check that both sources are represented
          final sources = result.map((p) => p.sourceId).toSet();
          expect(sources, containsAll(['apple_health', 'fitbit']));
        });

        test('handles mix of overlapping and separate sessions', () {
          final sessions = [
            TestHealthDataFactory.createSleepDataPoint(
              dateFrom: DateTime(2024, 1, 1, 22),
              dateTo: DateTime(2024, 1, 2, 1),
              sourceId: 'apple_health',
            ),
            TestHealthDataFactory.createSleepDataPoint(
              dateFrom: DateTime(2024, 1, 2, 0),
              dateTo: DateTime(2024, 1, 2, 2),
              sourceId: 'apple_health',
            ),
            TestHealthDataFactory.createSleepDataPoint(
              dateFrom: DateTime(2024, 1, 3, 22), // Separate night
              dateTo: DateTime(2024, 1, 4, 6),
              sourceId: 'apple_health',
            ),
          ];

          final result = normalizer.normalize(sessions);

          expect(result, hasLength(2)); // One merged + one separate
        });
      });

      group('edge cases', () {
        test('handles sessions with same start and end times', () {
          final session1 = TestHealthDataFactory.createSleepDataPoint(
            dateFrom: DateTime(2024, 1, 1, 22),
            dateTo: DateTime(2024, 1, 2, 6),
            sourceId: 'apple_health',
          );
          final session2 = TestHealthDataFactory.createSleepDataPoint(
            dateFrom: DateTime(2024, 1, 1, 22),
            dateTo: DateTime(2024, 1, 2, 6),
            sourceId: 'apple_health',
          );

          final result = normalizer.normalize([session1, session2]);

          expect(result, hasLength(1));
        });

        test('handles sessions with zero duration', () {
          final zeroSession = TestHealthDataFactory.createSleepDataPoint(
            dateFrom: DateTime(2024, 1, 1, 22),
            dateTo: DateTime(2024, 1, 1, 22),
            sourceId: 'apple_health',
          );
          final normalSession = TestHealthDataFactory.createSleepDataPoint(
            dateFrom: DateTime(2024, 1, 1, 22),
            dateTo: DateTime(2024, 1, 2, 6),
            sourceId: 'apple_health',
          );

          final result = normalizer.normalize([zeroSession, normalSession]);

          expect(result, hasLength(1));
          final merged = result.first;
          expect(merged.dateTo, equals(DateTime(2024, 1, 2, 6)));
        });

        test('handles very small gap tolerance', () {
          final session1 = TestHealthDataFactory.createSleepDataPoint(
            dateFrom: DateTime(2024, 1, 1, 22),
            dateTo: DateTime(2024, 1, 2, 2),
            sourceId: 'apple_health',
          );
          final session2 = TestHealthDataFactory.createSleepDataPoint(
            dateFrom: DateTime(2024, 1, 2, 2, 0, 30), // 30 seconds gap
            dateTo: DateTime(2024, 1, 2, 6),
            sourceId: 'apple_health',
          );

          final result = normalizer.normalize(
            [session1, session2],
            gapTolerance: const Duration(seconds: 10),
          );

          expect(result, hasLength(2)); // Should not merge
        });

        test('handles very large gap tolerance', () {
          final session1 = TestHealthDataFactory.createSleepDataPoint(
            dateFrom: DateTime(2024, 1, 1, 22),
            dateTo: DateTime(2024, 1, 2, 2),
            sourceId: 'apple_health',
          );
          final session2 = TestHealthDataFactory.createSleepDataPoint(
            dateFrom: DateTime(2024, 1, 2, 4), // 2 hours gap
            dateTo: DateTime(2024, 1, 2, 8),
            sourceId: 'apple_health',
          );

          final result = normalizer.normalize(
            [session1, session2],
            gapTolerance: const Duration(hours: 3),
          );

          expect(result, hasLength(1)); // Should merge
        });

        test('handles sessions in reverse chronological order', () {
          final laterSession = TestHealthDataFactory.createSleepDataPoint(
            dateFrom: DateTime(2024, 1, 2, 1),
            dateTo: DateTime(2024, 1, 2, 6),
            sourceId: 'apple_health',
          );
          final earlierSession = TestHealthDataFactory.createSleepDataPoint(
            dateFrom: DateTime(2024, 1, 1, 22),
            dateTo: DateTime(2024, 1, 2, 2),
            sourceId: 'apple_health',
          );

          final result = normalizer.normalize([laterSession, earlierSession]);

          expect(result, hasLength(1));
          final merged = result.first;
          expect(merged.dateFrom, equals(DateTime(2024, 1, 1, 22)));
          expect(merged.dateTo, equals(DateTime(2024, 1, 2, 6)));
        });
      });

      group('merging behavior', () {
        test('calculates correct duration in merged session value', () {
          final session1 = TestHealthDataFactory.createSleepDataPoint(
            dateFrom: DateTime(2024, 1, 1, 22),
            dateTo: DateTime(2024, 1, 2, 2), // 4 hours
            sourceId: 'apple_health',
          );
          final session2 = TestHealthDataFactory.createSleepDataPoint(
            dateFrom: DateTime(2024, 1, 2, 1),
            dateTo: DateTime(2024, 1, 2, 6), // 5 hours, overlaps 1 hour
            sourceId: 'apple_health',
          );

          final result = normalizer.normalize([session1, session2]);

          expect(result, hasLength(1));
          final merged = result.first;
          expect(merged.value, isA<NumericHealthValue>());
          final value = merged.value as NumericHealthValue;
          expect(value.numericValue, equals(8 * 60)); // 8 hours in minutes
          expect(merged.unit, equals(HealthDataUnit.MINUTE));
        });
      });
    });

    group('SleepNormalizationStrategy enum', () {
      test('has correct values', () {
        expect(SleepNormalizationStrategy.values, hasLength(2));
        expect(
          SleepNormalizationStrategy.values,
          contains(SleepNormalizationStrategy.mergeAdjacent),
        );
        expect(
          SleepNormalizationStrategy.values,
          contains(SleepNormalizationStrategy.preferConsolidated),
        );
      });
    });
  });
}
