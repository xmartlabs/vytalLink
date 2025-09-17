import 'package:dartx/dartx.dart';
import 'package:flutter_template/core/model/health_data_point.dart';
import 'package:flutter_template/core/model/health_data_temporal_behavior.dart';
import 'package:flutter_template/core/model/time_group_by.dart';
import 'package:flutter_template/model/health_data_unit.dart'
    hide HealthDataUnit;
import 'package:health/health.dart';

typedef _AggregationKey = ({HealthDataType type, String? sourceId});
typedef _SegmentAggregationContext = ({
  List<AppHealthDataPoint> data,
  DateTime segmentStart,
  DateTime segmentEnd,
  bool aggregatePerSource,
});

typedef HealthAggregationRequest = ({
  List<AppHealthDataPoint> data,
  TimeGroupBy groupBy,
  DateTime startTime,
  DateTime endTime,
  bool aggregatePerSource,
});

class HealthDataAggregator {
  const HealthDataAggregator();

  List<AggregatedHealthDataPoint> aggregate(
    HealthAggregationRequest request,
  ) {
    if (request.data.isEmpty) return [];

    final timeSegments = _generateTimeSegments(
      request.startTime,
      request.endTime,
      request.groupBy,
    );
    final aggregatedData = <AggregatedHealthDataPoint>[];
    final healthDataType = HealthDataType.values
        .firstWhere((type) => type.name == request.data.first.type);
    final temporalBehavior =
        HealthDataTemporalBehavior.forHealthDataType(healthDataType);

    for (int i = 0; i < timeSegments.length - 1; i++) {
      final segmentStart = timeSegments[i];
      final segmentEnd = timeSegments[i + 1];

      final aggregatedValue = _aggregateDataForSegment(
        (
          data: request.data,
          segmentStart: segmentStart,
          segmentEnd: segmentEnd,
          aggregatePerSource: request.aggregatePerSource,
        ),
        temporalBehavior,
      );

      for (final entry in aggregatedValue.entries) {
        aggregatedData.add(
          AggregatedHealthDataPoint(
            type: entry.key.type.name,
            value: entry.value,
            unit: entry.key.type.unit.name,
            dateFrom: segmentStart.toIso8601String(),
            dateTo: segmentEnd.toIso8601String(),
            sourceId: entry.key.sourceId,
          ),
        );
      }
    }

    return aggregatedData;
  }

  Map<_AggregationKey, double> _aggregateDataForSegment(
    _SegmentAggregationContext context,
    HealthDataTemporalBehavior temporalBehavior,
  ) =>
      switch (temporalBehavior) {
        HealthDataTemporalBehavior.instantaneous =>
          _aggregateInstantaneousData(context),
        HealthDataTemporalBehavior.cumulative =>
          _aggregateCumulativeData(context),
        HealthDataTemporalBehavior.sessional =>
          _aggregateSessionalData(context),
        HealthDataTemporalBehavior.durational =>
          _aggregateDurationalData(context),
      };

  Map<_AggregationKey, double> _aggregateInstantaneousData(
    _SegmentAggregationContext context,
  ) {
    final filteredData = context.data.where((point) {
      final pointDate = DateTime.parse(point.dateFrom);
      return (pointDate.isAfter(context.segmentStart) ||
              pointDate.isAtSameMomentAs(context.segmentStart)) &&
          pointDate.isBefore(context.segmentEnd);
    }).toList();

    return _aggregateValues(filteredData, context.aggregatePerSource);
  }

  Map<_AggregationKey, double> _aggregateCumulativeData(
    _SegmentAggregationContext context,
  ) {
    final totalValue = <_AggregationKey, double>{};

    final dataByKey = context.data.groupBy(
      (point) {
        final type = HealthDataType.values
            .firstWhere((element) => element.name == point.type);
        return (
          type: type,
          sourceId: context.aggregatePerSource ? point.sourceId : null,
        );
      },
    );

    for (final entry in dataByKey.entries) {
      final key = entry.key;
      for (final point in entry.value) {
        final pointStart = DateTime.parse(point.dateFrom);
        final pointEnd = DateTime.parse(point.dateTo);

        final overlapStart = _maxDateTime(pointStart, context.segmentStart);
        final overlapEnd = _minDateTime(pointEnd, context.segmentEnd);

        if (overlapStart.isBefore(overlapEnd)) {
          final pointDuration = pointEnd.difference(pointStart);
          final overlapDuration = overlapEnd.difference(overlapStart);

          if (pointDuration.inMilliseconds > 0) {
            final proportion =
                overlapDuration.inMilliseconds / pointDuration.inMilliseconds;
            final pointValue = double.tryParse(point.value.toString()) ?? 0.0;
            totalValue[key] =
                (totalValue[key] ?? 0.0) + pointValue * proportion;
          }
        }
      }
    }

    return totalValue;
  }

  Map<_AggregationKey, double> _aggregateSessionalData(
    _SegmentAggregationContext context,
  ) {
    final totalValue = <_AggregationKey, double>{};

    final dataByKey = context.data.groupBy(
      (point) {
        final type = HealthDataType.values
            .firstWhere((element) => element.name == point.type);
        return (
          type: type,
          sourceId: context.aggregatePerSource ? point.sourceId : null,
        );
      },
    );

    for (final entry in dataByKey.entries) {
      final key = entry.key;
      for (final point in entry.value) {
        final pointStart = DateTime.parse(point.dateFrom);
        final pointEnd = DateTime.parse(point.dateTo);

        final overlapStart = _maxDateTime(pointStart, context.segmentStart);
        final overlapEnd = _minDateTime(pointEnd, context.segmentEnd);

        if (overlapStart.isBefore(overlapEnd)) {
          final sessionDuration = pointEnd.difference(pointStart);
          final overlapDuration = overlapEnd.difference(overlapStart);

          if (sessionDuration.inMilliseconds > 0 &&
              overlapDuration.inMilliseconds >
                  sessionDuration.inMilliseconds / 2) {
            final pointValue = double.tryParse(point.value.toString()) ?? 0.0;
            totalValue[key] = (totalValue[key] ?? 0.0) + pointValue;
          }
        }
      }
    }

    return totalValue;
  }

  Map<_AggregationKey, double> _aggregateDurationalData(
    _SegmentAggregationContext context,
  ) {
    final totalDuration = <_AggregationKey, double>{};

    final dataByKey = context.data.groupBy(
      (point) {
        final type = HealthDataType.values
            .firstWhere((element) => element.name == point.type);
        return (
          type: type,
          sourceId: context.aggregatePerSource ? point.sourceId : null,
        );
      },
    );

    for (final entry in dataByKey.entries) {
      final key = entry.key;
      for (final point in entry.value) {
        final pointStart = DateTime.parse(point.dateFrom);
        final pointEnd = DateTime.parse(point.dateTo);

        if (pointEnd.isAfter(context.segmentStart) &&
            (pointEnd.isBefore(context.segmentEnd) ||
                pointEnd.isAtSameMomentAs(context.segmentEnd))) {
          final sessionDuration = pointEnd.difference(pointStart);
          totalDuration[key] = (totalDuration[key] ?? 0.0) +
              sessionDuration.inMinutes.toDouble();
        }
      }
    }

    return totalDuration;
  }

  Map<_AggregationKey, double> _aggregateValues(
    List<AppHealthDataPoint> dataPoints,
    bool aggregatePerSource,
  ) {
    if (dataPoints.isEmpty) return {};

    final groupedByKey = <_AggregationKey, List<AppHealthDataPoint>>{};
    for (final point in dataPoints) {
      final healthType =
          HealthDataType.values.firstWhere((type) => type.name == point.type);
      groupedByKey.putIfAbsent(
        (
          type: healthType,
          sourceId: aggregatePerSource ? point.sourceId : null,
        ),
        () => <AppHealthDataPoint>[],
      ).add(point);
    }

    final result = <_AggregationKey, double>{};

    for (final entry in groupedByKey.entries) {
      final key = entry.key;
      final typeDataPoints = entry.value;

      double total = 0;
      for (final point in typeDataPoints) {
        final value = point.value;
        if (value is num) {
          total += value.toDouble();
        }
      }

      if (!_isCumulativeDataType(key.type) && typeDataPoints.isNotEmpty) {
        result[key] = total / typeDataPoints.length;
      } else {
        result[key] = total;
      }
    }

    return result;
  }

  bool _isCumulativeDataType(HealthDataType dataType) {
    const cumulativeTypes = {
      HealthDataType.STEPS,
      HealthDataType.DISTANCE_DELTA,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.BASAL_ENERGY_BURNED,
      HealthDataType.WORKOUT,
      HealthDataType.WATER,
      HealthDataType.SLEEP_SESSION,
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.SLEEP_AWAKE,
      HealthDataType.SLEEP_DEEP,
      HealthDataType.SLEEP_LIGHT,
      HealthDataType.SLEEP_REM,
    };

    return cumulativeTypes.contains(dataType);
  }

  List<DateTime> _generateTimeSegments(
    DateTime startTime,
    DateTime endTime,
    TimeGroupBy groupBy,
  ) {
    final segments = <DateTime>[];
    var current = _alignToGroupBy(startTime, groupBy);

    while (current.isBefore(endTime)) {
      segments.add(current);
      current = _getNextSegment(current, groupBy);
    }

    if (segments.isEmpty || segments.last.isBefore(endTime)) {
      segments.add(endTime);
    }

    return segments;
  }

  DateTime _alignToGroupBy(DateTime dateTime, TimeGroupBy groupBy) {
    switch (groupBy) {
      case TimeGroupBy.hour:
        return DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          dateTime.hour,
        );
      case TimeGroupBy.day:
        return DateTime(dateTime.year, dateTime.month, dateTime.day);
      case TimeGroupBy.week:
        final daysToSubtract = dateTime.weekday - 1;
        return DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day - daysToSubtract,
        );
      case TimeGroupBy.month:
        return DateTime(dateTime.year, dateTime.month);
    }
  }

  DateTime _getNextSegment(DateTime current, TimeGroupBy groupBy) {
    switch (groupBy) {
      case TimeGroupBy.hour:
        return current.add(const Duration(hours: 1));
      case TimeGroupBy.day:
        return current.add(const Duration(days: 1));
      case TimeGroupBy.week:
        return current.add(const Duration(days: 7));
      case TimeGroupBy.month:
        return DateTime(current.year, current.month + 1);
    }
  }

  DateTime _maxDateTime(DateTime a, DateTime b) => a.isAfter(b) ? a : b;

  DateTime _minDateTime(DateTime a, DateTime b) => a.isBefore(b) ? a : b;
}
