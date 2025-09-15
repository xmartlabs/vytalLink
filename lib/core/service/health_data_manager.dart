import 'dart:io';

import 'package:flutter_template/core/model/aggregation_parameters.dart';
import 'package:flutter_template/core/model/health_data_point.dart';
import 'package:flutter_template/core/model/health_data_request.dart';
import 'package:flutter_template/core/model/health_data_response.dart';
import 'package:flutter_template/core/model/health_data_temporal_behavior.dart';
import 'package:flutter_template/core/model/statistic_types.dart';
import 'package:flutter_template/core/model/time_group_by.dart';
import 'package:flutter_template/core/source/mcp_server.dart';
import 'package:flutter_template/model/vytal_health_data_category.dart';
import 'package:health/health.dart';

class HealthDataManager {
  HealthDataManager({
    Health? healthClient,
  }) : _healthClient = healthClient ?? Health();

  final Health _healthClient;

  Future<AggregatedHealthDataResponse> processHealthDataRequest(
    HealthDataRequest request,
  ) async {
    try {
      final healthData = await _retrieveHealthData(request);
      return _createSuccessResponse(healthData, request);
    } catch (e) {
      throw HealthMcpServerException(
        'Error processing health data request: ${e.toString()}',
        e,
      );
    }
  }

  Future<List<AggregatedHealthDataPoint>> _retrieveHealthData(
    HealthDataRequest request,
  ) async {
    final HealthDataType valueType = request.valueType;
    final DateTime startTime = request.startTime;
    final DateTime endTime = request.endTime;
    final StatisticType statisticType = request.statistic;

    _validateTimeRange(startTime, endTime);
    await ensureHealthPermissions([valueType]);

    final List<HealthDataPoint> healthDataPoints =
        await _fetchHealthDataPoints(valueType, startTime, endTime);

    final formattedData = _formatHealthDataPoints(healthDataPoints);

    final aggregatedData = _aggregateHealthData(
      formattedData,
      request.groupBy,
      startTime,
      endTime,
    );

    switch (statisticType) {
      case StatisticType.sum:
        final context = HealthDataAggregationParameters(
          formattedData: formattedData,
          aggregatedData: aggregatedData,
          startTime: startTime,
          endTime: endTime,
          groupBy: request.groupBy,
          statisticType: statisticType,
        );
        return _buildOverallAverageResponse(context);
      case StatisticType.average:
        return _buildAggregatedStatisticsResponse(
          aggregatedData,
          statisticType,
        );
    }
  }

  void _validateTimeRange(DateTime startTime, DateTime endTime) {
    if (startTime.isAfter(endTime)) {
      throw ArgumentError('Start time cannot be after end time');
    }

    final now = DateTime.now();
    if (startTime.isAfter(now)) {
      throw ArgumentError('Start time cannot be in the future');
    }
  }

  VytalHealthDataCategory parseHealthDataType(String valueTypeStr) {
    try {
      return VytalHealthDataCategory.values.firstWhere(
        (type) => type.name == valueTypeStr,
      );
    } catch (e) {
      throw HealthMcpServerException(
        'Invalid health data type: $valueTypeStr',
        e,
      );
    }
  }

  void validateTimeRange(DateTime startTime, DateTime endTime) {
    if (startTime.isAfter(endTime)) {
      throw const HealthMcpServerException(
        'Start time must be before end time',
      );
    }
  }

  Future<void> checkHealthConnectAvailability() async {
    final isAvailable = await _healthClient.isHealthConnectAvailable();

    if (!isAvailable) {
      throw const HealthDataUnavailableException(
        'Google Health Connect is not available on this device. '
        'Please install it from the Play Store.',
      );
    }
  }

  Future<void> requestHealthPermissions(
    List<HealthDataType> healthTypes,
  ) async {
    final bool permissionsGranted = await _healthClient.requestAuthorization(
      healthTypes,
      permissions: healthTypes.map((_) => HealthDataAccess.READ).toList(),
    );

    if (!permissionsGranted) {
      throw const HealthPermissionException(
        'Health permissions not granted. '
        'Please open Health Connect app and grant permissions manually.',
      );
    }
  }

  Future<void> ensureHistoryAuthorizationIfNeeded() async {
    final isAuthorized = await _healthClient.isHealthDataHistoryAuthorized();

    if (!isAuthorized) {
      await _healthClient.requestHealthDataHistoryAuthorization();
    }
  }

  Future<void> ensureHealthPermissions(
    List<HealthDataType> healthTypes,
  ) async {
    if (Platform.isAndroid) {
      await checkHealthConnectAvailability();
    }

    final bool hasPermissions = await _healthClient.hasPermissions(
          healthTypes,
          permissions: healthTypes.map((_) => HealthDataAccess.READ).toList(),
        ) ??
        false;

    if (!hasPermissions) {
      await requestHealthPermissions(healthTypes);
    }

    await ensureHistoryAuthorizationIfNeeded();
  }

  Future<List<HealthDataPoint>> _fetchHealthDataPoints(
    HealthDataType valueType,
    DateTime startTime,
    DateTime endTime,
  ) async {
    final List<HealthDataPoint> result = [];

    final healthData = await _healthClient.getHealthDataFromTypes(
      types: [valueType],
      startTime: startTime,
      endTime: endTime,
    );
    result.addAll(healthData);

    return result;
  }

  List<AppHealthDataPoint> _formatHealthDataPoints(
    List<HealthDataPoint> dataPoints,
  ) =>
      dataPoints
          .map(
            (dataPoint) => AppHealthDataPoint(
              type: dataPoint.type.name,
              value: _formatHealthValue(dataPoint.value),
              unit: dataPoint.unit.name,
              dateFrom: dataPoint.dateFrom.toIso8601String(),
              dateTo: dataPoint.dateTo.toIso8601String(),
            ),
          )
          .toList();

  dynamic _formatHealthValue(HealthValue value) {
    if (value is NumericHealthValue) {
      return value.numericValue;
    } else if (value is WorkoutHealthValue) {
      return {
        'workoutActivityType': value.workoutActivityType.name,
        'totalEnergyBurned': value.totalEnergyBurned,
        'totalDistance': value.totalDistance,
      };
    } else if (value is NutritionHealthValue) {
      return {
        'calories': value.calories,
        'protein': value.protein,
        'carbs': value.carbs,
        'fat': value.fat,
      };
    }
    return value.toString();
  }

  List<AggregatedHealthDataPoint> _aggregateHealthData(
    List<AppHealthDataPoint> data,
    TimeGroupBy groupBy,
    DateTime startTime,
    DateTime endTime,
  ) {
    if (data.isEmpty) return [];

    final List<DateTime> timeSegments = _generateTimeSegments(
      startTime,
      endTime,
      groupBy,
    );
    final List<AggregatedHealthDataPoint> aggregatedData = [];

    final healthDataType = HealthDataType.values.firstWhere(
      (type) => type.name == data.first.type,
    );
    final temporalBehavior =
        HealthDataTemporalBehavior.forHealthDataType(healthDataType);

    for (int i = 0; i < timeSegments.length - 1; i++) {
      final DateTime segmentStart = timeSegments[i];
      final DateTime segmentEnd = timeSegments[i + 1];

      final aggregatedValue = _aggregateDataForSegment(
        data,
        segmentStart,
        segmentEnd,
        temporalBehavior,
      );

      aggregatedData.add(
        AggregatedHealthDataPoint(
          type: data.first.type,
          value: aggregatedValue,
          unit: data.first.unit,
          dateFrom: segmentStart.toIso8601String(),
          dateTo: segmentEnd.toIso8601String(),
        ),
      );
    }

    return aggregatedData;
  }

  /// Aggregate data for a specific time segment based on temporal behavior
  double _aggregateDataForSegment(
    List<AppHealthDataPoint> data,
    DateTime segmentStart,
    DateTime segmentEnd,
    HealthDataTemporalBehavior temporalBehavior,
  ) {
    switch (temporalBehavior) {
      case HealthDataTemporalBehavior.instantaneous:
        return _aggregateInstantaneousData(data, segmentStart, segmentEnd);

      case HealthDataTemporalBehavior.cumulative:
        return _aggregateCumulativeData(data, segmentStart, segmentEnd);

      case HealthDataTemporalBehavior.sessional:
        return _aggregateSessionalData(data, segmentStart, segmentEnd);

      case HealthDataTemporalBehavior.durational:
        return _aggregateDurationalData(data, segmentStart, segmentEnd);
    }
  }

  double _aggregateInstantaneousData(
    List<AppHealthDataPoint> data,
    DateTime segmentStart,
    DateTime segmentEnd,
  ) {
    final filteredData = data.where((point) {
      final DateTime pointDate = DateTime.parse(point.dateFrom);
      return (pointDate.isAfter(segmentStart) ||
              pointDate.isAtSameMomentAs(segmentStart)) &&
          pointDate.isBefore(segmentEnd);
    }).toList();

    return _aggregateValues(filteredData);
  }

  double _aggregateCumulativeData(
    List<AppHealthDataPoint> data,
    DateTime segmentStart,
    DateTime segmentEnd,
  ) {
    double totalValue = 0.0;

    for (final point in data) {
      final DateTime pointStart = DateTime.parse(point.dateFrom);
      final DateTime pointEnd = DateTime.parse(point.dateTo);

      final DateTime overlapStart = _maxDateTime(pointStart, segmentStart);
      final DateTime overlapEnd = _minDateTime(pointEnd, segmentEnd);

      if (overlapStart.isBefore(overlapEnd)) {
        // Calculate the proportion of the data point within this segment
        final Duration pointDuration = pointEnd.difference(pointStart);
        final Duration overlapDuration = overlapEnd.difference(overlapStart);

        if (pointDuration.inMilliseconds > 0) {
          final double proportion =
              overlapDuration.inMilliseconds / pointDuration.inMilliseconds;
          final double pointValue =
              double.tryParse(point.value.toString()) ?? 0.0;
          totalValue += pointValue * proportion;
        }
      }
    }

    return totalValue;
  }

  double _aggregateSessionalData(
    List<AppHealthDataPoint> data,
    DateTime segmentStart,
    DateTime segmentEnd,
  ) {
    double totalValue = 0.0;

    for (final point in data) {
      final DateTime pointStart = DateTime.parse(point.dateFrom);
      final DateTime pointEnd = DateTime.parse(point.dateTo);

      final DateTime overlapStart = _maxDateTime(pointStart, segmentStart);
      final DateTime overlapEnd = _minDateTime(pointEnd, segmentEnd);

      if (overlapStart.isBefore(overlapEnd)) {
        final Duration sessionDuration = pointEnd.difference(pointStart);
        final Duration overlapDuration = overlapEnd.difference(overlapStart);

        // If more than 50% of the session is in this segment, assign full value
        if (sessionDuration.inMilliseconds > 0 &&
            overlapDuration.inMilliseconds >
                sessionDuration.inMilliseconds / 2) {
          final double pointValue =
              double.tryParse(point.value.toString()) ?? 0.0;
          totalValue += pointValue;
        }
      }
    }

    return totalValue;
  }

  double _aggregateDurationalData(
    List<AppHealthDataPoint> data,
    DateTime segmentStart,
    DateTime segmentEnd,
  ) {
    double totalDuration = 0.0;

    for (final point in data) {
      final DateTime pointStart = DateTime.parse(point.dateFrom);
      final DateTime pointEnd = DateTime.parse(point.dateTo);

      // For sleep sessions, assign the full duration to the segment
      // containing the END time
      // This way "slept 10 hours" appears on the day you wake up,
      // not distributed
      if (pointEnd.isAfter(segmentStart) &&
          (pointEnd.isBefore(segmentEnd) ||
              pointEnd.isAtSameMomentAs(segmentEnd))) {
        final Duration sessionDuration = pointEnd.difference(pointStart);
        totalDuration += sessionDuration.inMinutes.toDouble();
      }
    }

    return totalDuration;
  }

  /// Utility: Get the maximum of two DateTimes
  DateTime _maxDateTime(DateTime a, DateTime b) => a.isAfter(b) ? a : b;

  /// Utility: Get the minimum of two DateTimes
  DateTime _minDateTime(DateTime a, DateTime b) => a.isBefore(b) ? a : b;

  List<DateTime> _generateTimeSegments(
    DateTime startTime,
    DateTime endTime,
    TimeGroupBy groupBy,
  ) {
    final List<DateTime> segments = [];
    DateTime current = _alignToGroupBy(startTime, groupBy);

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
        final int daysToSubtract = dateTime.weekday - 1;
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

  double _aggregateValues(List<AppHealthDataPoint> dataPoints) {
    if (dataPoints.isEmpty) return 0;

    final String dataType = dataPoints.first.type;
    double total = 0;

    for (final point in dataPoints) {
      final dynamic value = point.value;
      if (value is num) {
        total += value.toDouble();
      }
    }

    if (!_isCumulativeDataType(dataType) && dataPoints.isNotEmpty) {
      return total / dataPoints.length;
    }

    return total;
  }

  bool _isCumulativeDataType(String dataType) {
    const cumulativeTypes = {
      'STEPS',
      'DISTANCE_DELTA',
      'ACTIVE_ENERGY_BURNED',
      'BASAL_ENERGY_BURNED',
      'WORKOUT',
      'WATER',
      'SLEEP_SESSION',
      'SLEEP_ASLEEP',
      'SLEEP_AWAKE',
      'SLEEP_DEEP',
      'SLEEP_LIGHT',
      'SLEEP_REM',
    };

    return cumulativeTypes.contains(dataType.toUpperCase());
  }

  List<AggregatedHealthDataPoint> _buildOverallAverageResponse(
    HealthDataAggregationParameters aggregationParameters,
  ) {
    double totalValue = 0;
    int totalDataPoints = 0;

    for (final dataPoint in aggregationParameters.aggregatedData) {
      final value = dataPoint.value;
      const dataPointCount = 1;

      totalValue += value;
      totalDataPoints += dataPointCount;
    }

    final overallAverage = totalDataPoints > 0
        ? totalValue / aggregationParameters.aggregatedData.length
        : 0.0;

    return [
      AggregatedHealthDataPoint(
        type: aggregationParameters.formattedData.isNotEmpty
            ? aggregationParameters.formattedData.first.type
            : 'UNKNOWN',
        value: overallAverage,
        unit: aggregationParameters.formattedData.isNotEmpty
            ? aggregationParameters.formattedData.first.unit
            : 'NO_UNIT',
        dateFrom: aggregationParameters.startTime.toIso8601String(),
        dateTo: aggregationParameters.endTime.toIso8601String(),
      ),
    ];
  }

  List<AggregatedHealthDataPoint> _buildAggregatedStatisticsResponse(
    List<AggregatedHealthDataPoint> aggregatedData,
    StatisticType statisticType,
  ) =>
      aggregatedData;

  AggregatedHealthDataResponse _createSuccessResponse(
    List<AggregatedHealthDataPoint> healthData,
    HealthDataRequest request,
  ) =>
      AggregatedHealthDataResponse(
        success: true,
        count: healthData.length,
        healthData: healthData,
        valueType: request.valueType.name,
        startTime: request.startTime.toIso8601String(),
        endTime: request.endTime.toIso8601String(),
        groupBy: request.groupBy.name,
        isAggregated: true,
        statisticType: request.statistic.name,
      );
}
