import 'package:flutter_template/core/common/logger.dart';
import 'package:flutter_template/core/model/health_data_request.dart';
import 'package:flutter_template/core/model/statistic_types.dart';
import 'package:flutter_template/core/model/summary_request.dart';
import 'package:flutter_template/core/model/summary_response.dart';
import 'package:flutter_template/core/model/time_group_by.dart';
import 'package:flutter_template/model/vytal_health_data_category.dart';

import 'package:flutter_template/core/service/health_data_manager.dart';

class SummaryDataManager {
  SummaryDataManager({
    HealthDataManager? healthDataManager,
    DateTime Function()? nowProvider,
  })  : _healthDataManager = healthDataManager ?? HealthDataManager(),
        _now = nowProvider ?? DateTime.now;

  final HealthDataManager _healthDataManager;
  final DateTime Function() _now;
  static const bool _useConcurrentProcessing = true;

  Future<SummaryResponse> processSummaryRequest(
    SummaryRequest request,
  ) async {
    try {
      _validateTimeRange(request.startTime, request.endTime);

      final resolvedMetrics = _resolveMetrics(
        request.startTime,
        request.endTime,
        request.metrics,
      );

      final results = _useConcurrentProcessing
          ? await Future.wait(
              resolvedMetrics.map(
                (metric) => _processMetric(request, metric),
              ),
            )
          : await _processSequentially(request, resolvedMetrics);

      final overallSuccess = results.every((result) => result.success);

      return SummaryResponse(
        success: overallSuccess,
        startTime: request.startTime.toIso8601String(),
        endTime: request.endTime.toIso8601String(),
        results: results,
        errorMessage: overallSuccess ? null : 'Some metrics failed',
      );
    } catch (error, stackTrace) {
      Logger.e('Failed to process summary request', error, stackTrace);
      return SummaryResponse(
        success: false,
        startTime: request.startTime.toIso8601String(),
        endTime: request.endTime.toIso8601String(),
        results: const [],
        errorMessage: error.toString(),
      );
    }
  }

  Future<List<SummaryMetricResult>> _processSequentially(
    SummaryRequest request,
    List<SummaryMetricRequest> metrics,
  ) async {
    final results = <SummaryMetricResult>[];

    for (final metric in metrics) {
      results.add(await _processMetric(request, metric));
    }

    return results;
  }

  Future<SummaryMetricResult> _processMetric(
    SummaryRequest request,
    SummaryMetricRequest metric,
  ) async {
    try {
      final dataResponse = await _healthDataManager.processHealthDataRequest(
        HealthDataRequest(
          valueType: metric.valueType,
          startTime: request.startTime,
          endTime: request.endTime,
          groupBy: metric.groupBy,
          statistic: metric.statistic,
        ),
      );

      return SummaryMetricResult(
        valueType: metric.valueType,
        success: true,
        data: dataResponse,
      );
    } catch (error, stackTrace) {
      Logger.e(
        'Failed to process summary metric ${metric.valueType}',
        error,
        stackTrace,
      );
      return SummaryMetricResult(
        valueType: metric.valueType,
        success: false,
        errorMessage: error.toString(),
      );
    }
  }

  List<SummaryMetricRequest> _resolveMetrics(
    DateTime start,
    DateTime end,
    List<SummaryMetricRequest>? metrics,
  ) {
    final duration = end.difference(start);
    final preset = _presetForDuration(duration);

    final baseMetrics = (metrics?.isNotEmpty ?? false)
        ? metrics!
        : _defaultMetricsForPreset(preset);

    return baseMetrics
        .map(
          (metric) => SummaryMetricRequest(
            valueType: metric.valueType,
            groupBy: metric.groupBy ?? _defaultGroupBy(preset),
            statistic: metric.statistic ??
                _defaultStatisticForMetric(metric.valueType, preset),
          ),
        )
        .toList();
  }

  void _validateTimeRange(DateTime start, DateTime end) {
    if (start.isAfter(end)) {
      throw ArgumentError('Start time cannot be after end time');
    }

    final now = _now();
    if (start.isAfter(now)) {
      throw ArgumentError('Start time cannot be in the future');
    }
  }

  _SummaryPreset _presetForDuration(Duration duration) {
    final totalDays = duration.inDays.abs();

    if (totalDays <= 31) {
      return _SummaryPreset.day;
    } else if (totalDays <= 93) {
      return _SummaryPreset.week;
    } else {
      return _SummaryPreset.month;
    }
  }

  TimeGroupBy _defaultGroupBy(_SummaryPreset preset) {
    switch (preset) {
      case _SummaryPreset.day:
        return TimeGroupBy.day;
      case _SummaryPreset.week:
        return TimeGroupBy.week;
      case _SummaryPreset.month:
        return TimeGroupBy.month;
    }
  }

  StatisticType _defaultStatisticForMetric(
    VytalHealthDataCategory category,
    _SummaryPreset preset,
  ) =>
      switch (category) {
        VytalHealthDataCategory.SLEEP => StatisticType.average,
        VytalHealthDataCategory.HEART_RATE => StatisticType.average,
        _ => StatisticType.sum,
      };

  List<SummaryMetricRequest> _defaultMetricsForPreset(
    _SummaryPreset preset,
  ) =>
      [
        SummaryMetricRequest(
          valueType: VytalHealthDataCategory.STEPS,
          groupBy: _defaultGroupBy(preset),
          statistic: StatisticType.sum,
        ),
        SummaryMetricRequest(
          valueType: VytalHealthDataCategory.CALORIES,
          groupBy: _defaultGroupBy(preset),
          statistic: StatisticType.sum,
        ),
        SummaryMetricRequest(
          valueType: VytalHealthDataCategory.DISTANCE,
          groupBy: _defaultGroupBy(preset),
          statistic: StatisticType.sum,
        ),
        SummaryMetricRequest(
          valueType: VytalHealthDataCategory.WORKOUT,
          groupBy: _defaultGroupBy(preset),
          statistic: StatisticType.sum,
        ),
        SummaryMetricRequest(
          valueType: VytalHealthDataCategory.SLEEP,
          groupBy: _defaultGroupBy(preset),
          statistic: StatisticType.average,
        ),
      ];
}

enum _SummaryPreset {
  day,
  week,
  month;
}
