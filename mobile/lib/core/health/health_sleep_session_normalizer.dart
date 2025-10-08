import 'dart:math';

import 'package:dartx/dartx.dart';
import 'package:flutter_template/core/model/health_data_point.dart';
import 'package:flutter_template/model/vytal_health_data_category.dart';
import 'package:health/health.dart';

enum SleepNormalizationStrategy {
  mergeAdjacent,
  preferConsolidated,
}

typedef AdjustedTimeRange = ({DateTime startTime, DateTime endTime});

class HealthSleepSessionNormalizer {
  const HealthSleepSessionNormalizer();

  static const int _sleepHour = 21;
  static const int _fullDayToleranceMinutes = 5;

  List<HealthDataPoint> normalize(
    List<HealthDataPoint> dataPoints, {
    SleepNormalizationStrategy strategy =
        SleepNormalizationStrategy.preferConsolidated,
    Duration gapTolerance = const Duration(minutes: 5),
    double containmentThreshold = 0.95,
  }) {
    final sleepSessions =
        dataPoints.where((point) => point.type == HealthDataType.SLEEP_SESSION);

    if (sleepSessions.isEmpty) {
      return dataPoints;
    }

    final nonSleepSessions = dataPoints
        .where((point) => point.type != HealthDataType.SLEEP_SESSION)
        .toList();

    final mergedSessions = <HealthDataPoint>[];

    // Group by source to avoid mixing sessions coming from different devices
    // or recording strategies.
    final sessionsBySource =
        sleepSessions.groupBy((point) => _buildSourceGroupingKey(point));

    for (final entry in sessionsBySource.entries) {
      final sessions = entry.value.map(_cloneSleepSession).toList()
        ..sort((a, b) => a.dateFrom.compareTo(b.dateFrom));

      if (sessions.isEmpty) {
        continue;
      }

      var current = sessions.first;

      for (final session in sessions.skip(1)) {
        if (_sessionsOverlapOrAreContinuous(current, session, gapTolerance)) {
          final preferConsolidated =
              strategy == SleepNormalizationStrategy.preferConsolidated &&
                  _isAlmostContained(
                    current,
                    session,
                    containmentThreshold,
                  );
          current = preferConsolidated
              ? _selectLongerSession(current, session)
              : _mergeSleepSessionPair(current, session);
        } else {
          mergedSessions.add(current);
          current = session;
        }
      }

      mergedSessions.add(current);
    }

    return [...nonSleepSessions, ...mergedSessions]
      ..sort((a, b) => a.dateFrom.compareTo(b.dateFrom));
  }

  String _buildSourceGroupingKey(HealthDataPoint point) => [
        point.sourceId,
        point.sourceDeviceId,
        point.recordingMethod.name,
      ].join('::');

  HealthDataPoint _cloneSleepSession(HealthDataPoint point) => HealthDataPoint(
        uuid: point.uuid,
        value: point.value is NumericHealthValue
            ? NumericHealthValue(
                numericValue: (point.value as NumericHealthValue).numericValue,
              )
            : NumericHealthValue(
                numericValue:
                    point.dateTo.difference(point.dateFrom).inSeconds / 60,
              ),
        type: point.type,
        unit: point.unit,
        dateFrom: point.dateFrom,
        dateTo: point.dateTo,
        sourcePlatform: point.sourcePlatform,
        sourceDeviceId: point.sourceDeviceId,
        sourceId: point.sourceId,
        sourceName: point.sourceName,
        recordingMethod: point.recordingMethod,
        workoutSummary: point.workoutSummary,
        metadata: point.metadata != null
            ? Map<String, dynamic>.from(point.metadata!)
            : null,
        deviceModel: point.deviceModel,
      );

  bool _sessionsOverlapOrAreContinuous(
    HealthDataPoint current,
    HealthDataPoint candidate,
    Duration gapTolerance,
  ) {
    final startA = current.dateFrom;
    final endA = current.dateTo;
    final startB = candidate.dateFrom;
    final endB = candidate.dateTo;

    final bool overlaps = startB.isBefore(endA) && endB.isAfter(startA);
    final bool touches = startB.isAtSameMomentAs(endA);

    if (overlaps || touches) {
      return true;
    }

    if (startB.isAfter(endA)) {
      final gap = startB.difference(endA);
      return gap <= gapTolerance;
    }

    return false;
  }

  bool _isAlmostContained(
    HealthDataPoint first,
    HealthDataPoint second,
    double threshold,
  ) {
    final overlapStart = first.dateFrom.isAfter(second.dateFrom)
        ? first.dateFrom
        : second.dateFrom;
    final overlapEnd =
        first.dateTo.isBefore(second.dateTo) ? first.dateTo : second.dateTo;

    if (!overlapStart.isBefore(overlapEnd)) {
      return false;
    }

    final overlapSeconds = overlapEnd.difference(overlapStart).inSeconds;
    final firstDurationSeconds =
        max(0, first.dateTo.difference(first.dateFrom).inSeconds);
    final secondDurationSeconds =
        max(0, second.dateTo.difference(second.dateFrom).inSeconds);

    final shorterDurationSeconds =
        min(firstDurationSeconds, secondDurationSeconds);

    if (shorterDurationSeconds == 0) {
      return false;
    }

    final coverage = overlapSeconds / shorterDurationSeconds;
    return coverage >= threshold;
  }

  HealthDataPoint _selectLongerSession(
    HealthDataPoint first,
    HealthDataPoint second,
  ) {
    final firstDuration = first.dateTo.difference(first.dateFrom);
    final secondDuration = second.dateTo.difference(second.dateFrom);

    if (secondDuration > firstDuration) {
      return second;
    }

    return first;
  }

  HealthDataPoint _mergeSleepSessionPair(
    HealthDataPoint first,
    HealthDataPoint second,
  ) {
    final earliestStart = first.dateFrom.isBefore(second.dateFrom)
        ? first.dateFrom
        : second.dateFrom;
    final latestEnd =
        first.dateTo.isAfter(second.dateTo) ? first.dateTo : second.dateTo;

    final durationMinutes = latestEnd.difference(earliestStart).inSeconds / 60;

    final mergedMetadata = <String, dynamic>{
      if (first.metadata != null) ...first.metadata!,
      if (second.metadata != null) ...second.metadata!,
    };

    first
      ..dateFrom = earliestStart
      ..dateTo = latestEnd
      ..value = NumericHealthValue(numericValue: durationMinutes)
      ..unit = HealthDataUnit.MINUTE
      ..metadata = mergedMetadata.isEmpty ? first.metadata : mergedMetadata
      ..deviceModel ??= second.deviceModel;

    return first;
  }

  AdjustedTimeRange adjustTimeRangeForSleepData(
    VytalHealthDataCategory valueType,
    DateTime originalStartTime,
    DateTime originalEndTime,
  ) {
    if (valueType != VytalHealthDataCategory.SLEEP) {
      return (startTime: originalStartTime, endTime: originalEndTime);
    }

    // Only adjust if this looks like a natural time range request (day/week/month boundaries)
    if (!_isNaturalTimeRangeRequest(originalStartTime, originalEndTime)) {
      return (startTime: originalStartTime, endTime: originalEndTime);
    }

    // For any range, we capture sleep from 21:00 of the first day to 21:00 of
    // the last day.
    // This creates clean 24-hour sleep windows. For example:
    // Request: 2025-10-07T00:00:00Z to 2025-10-08T23:59:59Z
    // Adjusted: 2025-10-07T21:00:00 to 2025-10-08T21:00:00
    final adjustedStartTime = DateTime(
      originalStartTime.year,
      originalStartTime.month,
      originalStartTime.day,
      _sleepHour,
      0,
      0,
    );

    final adjustedEndTime = DateTime(
      originalEndTime.year,
      originalEndTime.month,
      originalEndTime.day,
      _sleepHour,
      0,
      0,
    );

    return (startTime: adjustedStartTime, endTime: adjustedEndTime);
  }

  /// Detects if this is a natural time range request (e.g.,
  /// from ChatGPT asking for "today's sleep", "this week's sleep")
  /// Checks if start time is around 00:00 and end time is around 23:59,
  /// regardless of how many days span
  bool _isNaturalTimeRangeRequest(DateTime startTime, DateTime endTime) {
    // Check if start time is close to 00:00:00
    final isStartOfDay =
        startTime.hour == 0 && startTime.minute <= _fullDayToleranceMinutes;

    // Check if end time is close to 23:59:59
    final isEndOfDay =
        endTime.hour == 23 && endTime.minute >= (59 - _fullDayToleranceMinutes);

    return isStartOfDay && isEndOfDay;
  }

  /// Gets the appropriate date range for aggregated sleep data
  /// Returns actual sleep session times instead of aggregation segment
  /// boundaries
  ({DateTime start, DateTime end}) getDateRangeForAggregatedSleepData(
    List<AppHealthDataPoint> allData,
    DateTime segmentStart,
    DateTime segmentEnd,
    String? sourceId,
  ) {
    final relevantSleepData = allData.where((point) {
      final pointStart = DateTime.parse(point.dateFrom);
      final pointEnd = DateTime.parse(point.dateTo);
      final matchesSource = sourceId == null || point.sourceId == sourceId;

      return matchesSource &&
          pointStart.isBefore(segmentEnd) &&
          pointEnd.isAfter(segmentStart);
    }).toList();

    if (relevantSleepData.isEmpty) {
      return (start: segmentStart, end: segmentEnd);
    }

    // Find the earliest start and latest end of actual sleep sessions
    DateTime? earliestStart;
    DateTime? latestEnd;

    for (final sleepPoint in relevantSleepData) {
      final pointStart = DateTime.parse(sleepPoint.dateFrom);
      final pointEnd = DateTime.parse(sleepPoint.dateTo);

      if (earliestStart == null || pointStart.isBefore(earliestStart)) {
        earliestStart = pointStart;
      }
      if (latestEnd == null || pointEnd.isAfter(latestEnd)) {
        latestEnd = pointEnd;
      }
    }

    return (start: earliestStart!, end: latestEnd!);
  }
}
