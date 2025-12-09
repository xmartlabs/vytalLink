import 'package:flutter_template/core/model/health_data_request.dart';
import 'package:flutter_template/core/model/summary_request.dart';
import 'package:flutter_template/core/model/summary_response.dart';
import 'package:flutter_template/core/model/statistic_types.dart';
import 'package:flutter_template/core/model/time_group_by.dart';
import 'package:flutter_template/core/service/health_data_manager.dart';
import 'package:flutter_template/core/service/summary_data_manager.dart';
import 'package:flutter_template/model/vytal_health_data_category.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/test_data_factory.dart';

class MockHealthDataManager extends Mock implements HealthDataManager {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      TestDataFactory.createHealthDataRequest(),
    );
  });

  group('SummaryDataManager', () {
    late SummaryDataManager summaryDataManager;
    late MockHealthDataManager mockHealthDataManager;

    setUp(() {
      mockHealthDataManager = MockHealthDataManager();
      summaryDataManager = SummaryDataManager(
        healthDataManager: mockHealthDataManager,
      );

      when(
        () => mockHealthDataManager.processHealthDataRequest(any()),
      ).thenAnswer(
        (_) async => TestDataFactory.createHealthDataResponse(),
      );
    });

    test('uses day preset for <=31 days with default metrics', () async {
      final start = DateTime(2025, 1, 1);
      final end = DateTime(2025, 1, 10);

      final response = await summaryDataManager.processSummaryRequest(
        SummaryRequest(startTime: start, endTime: end),
      );

      expect(response.success, isTrue);
      expect(response.results, hasLength(5));
      final requests = verify(
        () => mockHealthDataManager.processHealthDataRequest(
          captureAny<HealthDataRequest>(),
        ),
      ).captured;
      for (final request in requests) {
        expect(request.groupBy, TimeGroupBy.day);
      }
    });

    test('uses week preset for >31 and <=93 days with default metrics',
        () async {
      final start = DateTime(2025, 1, 1);
      final end = DateTime(2025, 3, 15);

      await summaryDataManager.processSummaryRequest(
        SummaryRequest(startTime: start, endTime: end),
      );

      final requests = verify(
        () => mockHealthDataManager.processHealthDataRequest(
          captureAny<HealthDataRequest>(),
        ),
      ).captured;
      for (final request in requests) {
        expect(request.groupBy, TimeGroupBy.week);
      }
    });

    test('uses month preset for >93 days with default metrics', () async {
      final start = DateTime(2025, 1, 1);
      final end = DateTime(2025, 7, 1);

      await summaryDataManager.processSummaryRequest(
        SummaryRequest(startTime: start, endTime: end),
      );

      final requests = verify(
        () => mockHealthDataManager.processHealthDataRequest(
          captureAny<HealthDataRequest>(),
        ),
      ).captured;
      for (final request in requests) {
        expect(request.groupBy, TimeGroupBy.month);
      }
    });

    test('respects provided metric overrides and fills missing defaults',
        () async {
      final start = DateTime(2025, 1, 1);
      final end = DateTime(2025, 3, 1);

      await summaryDataManager.processSummaryRequest(
        SummaryRequest(
          startTime: start,
          endTime: end,
          metrics: [
            const SummaryMetricRequest(
              valueType: VytalHealthDataCategory.STEPS,
              groupBy: TimeGroupBy.month,
              statistic: StatisticType.sum,
            ),
            const SummaryMetricRequest(
              valueType: VytalHealthDataCategory.SLEEP,
            ),
          ],
        ),
      );

      final requests = verify(
        () => mockHealthDataManager.processHealthDataRequest(
          captureAny<HealthDataRequest>(),
        ),
      ).captured;

      final stepsRequest = requests
          .whereType<HealthDataRequest>()
          .firstWhere((r) => r.valueType == VytalHealthDataCategory.STEPS);
      final sleepRequest = requests
          .whereType<HealthDataRequest>()
          .firstWhere((r) => r.valueType == VytalHealthDataCategory.SLEEP);

      expect(stepsRequest.groupBy, TimeGroupBy.month);
      expect(stepsRequest.statistic, StatisticType.sum);
      // Sleep fills defaults based on preset (week for this range) and average statistic.
      expect(sleepRequest.groupBy, TimeGroupBy.week);
      expect(sleepRequest.statistic, StatisticType.average);
    });

    test('returns error when time range is invalid', () async {
      final start = DateTime(2025, 1, 2);
      final end = DateTime(2025, 1, 1);

      final response = await summaryDataManager.processSummaryRequest(
        SummaryRequest(startTime: start, endTime: end),
      );

      expect(response.success, isFalse);
      expect(response.results, isEmpty);
      expect(response.errorMessage, isNotEmpty);
    });

    test('marks failed metric and overall success=false when one metric fails',
        () async {
      when(
        () => mockHealthDataManager.processHealthDataRequest(
          any(
            that: isA<HealthDataRequest>().having(
              (r) => r.valueType,
              'valueType',
              VytalHealthDataCategory.CALORIES,
            ),
          ),
        ),
      ).thenThrow(Exception('fail calories'));

      final start = DateTime(2025, 1, 1);
      final end = DateTime(2025, 1, 15);

      final response = await summaryDataManager.processSummaryRequest(
        SummaryRequest(startTime: start, endTime: end),
      );

      expect(response.success, isFalse);
      final caloriesResult = response.results.firstWhere(
        (r) => r.valueType == VytalHealthDataCategory.CALORIES,
      );
      expect(caloriesResult.success, isFalse);
      expect(caloriesResult.errorMessage, isNotEmpty);
    });
  });
}
