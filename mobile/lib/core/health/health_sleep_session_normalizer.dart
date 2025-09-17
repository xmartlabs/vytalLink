import 'dart:math';

import 'package:dartx/dartx.dart';
import 'package:health/health.dart';

enum SleepNormalizationStrategy {
  mergeAdjacent,
  preferConsolidated,
}

/// Consolidates overlapping or near-contiguous sleep sessions originating from
/// the same source into a single interval.
class HealthSleepSessionNormalizer {
  const HealthSleepSessionNormalizer();

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
          if (strategy == SleepNormalizationStrategy.preferConsolidated &&
              _isAlmostContained(
                current,
                session,
                containmentThreshold,
              )) {
            current = _selectLongerSession(current, session);
          } else {
            current = _mergeSleepSessionPair(current, session);
          }
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

  HealthDataPoint _cloneSleepSession(HealthDataPoint point) =>
      HealthDataPoint(
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
}
