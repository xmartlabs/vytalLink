import 'package:dartx/dartx.dart';
import 'package:flutter_template/core/health/health_data_aggregator.dart';
import 'package:flutter_template/core/health/health_data_mapper.dart';
import 'package:flutter_template/core/health/health_permissions_guard.dart';
import 'package:flutter_template/core/health/health_sleep_session_normalizer.dart';
import 'package:flutter_template/core/model/aggregation_parameters.dart';
import 'package:flutter_template/core/model/health_data_point.dart';
import 'package:flutter_template/core/model/health_data_request.dart';
import 'package:flutter_template/core/model/health_data_response.dart';
import 'package:flutter_template/core/model/statistic_types.dart';
import 'package:flutter_template/core/source/mcp_server.dart';
import 'package:flutter_template/model/vytal_health_data_category.dart';
import 'package:health/health.dart';

class HealthDataManager {
  HealthDataManager({
    Health? healthClient,
    bool aggregatePerSource = true,
    HealthDataAggregator? healthDataAggregator,
    HealthDataMapper? healthDataMapper,
    HealthPermissionsGuard? healthPermissionsGuard,
    HealthSleepSessionNormalizer? healthSleepSessionNormalizer,
  })  : _healthClient = healthClient ?? Health(),
        _aggregatePerSource = aggregatePerSource,
        _healthDataAggregator =
            healthDataAggregator ?? const HealthDataAggregator(),
        _healthDataMapper = healthDataMapper ?? const HealthDataMapper(),
        _healthPermissionsGuard =
            healthPermissionsGuard ?? const HealthPermissionsGuard(),
        _sleepSessionNormalizer = healthSleepSessionNormalizer ??
            const HealthSleepSessionNormalizer();

  final Health _healthClient;
  final bool _aggregatePerSource;
  final HealthDataAggregator _healthDataAggregator;
  final HealthDataMapper _healthDataMapper;
  final HealthPermissionsGuard _healthPermissionsGuard;
  final HealthSleepSessionNormalizer _sleepSessionNormalizer;

  Future<HealthDataResponse> processHealthDataRequest(
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

  Future<List<AppHealthDataPoint>> _retrieveHealthData(
    HealthDataRequest request,
  ) async {
    final DateTime startTime = request.startTime;
    final DateTime endTime = request.endTime;

    final groupBy = request.groupBy;
    final dataPoints = await _processDataPoints(request, startTime, endTime);

    if (groupBy != null && request.statistic == null) {
      throw const HealthMcpServerException(
        'When groupBy is specified, statisticType must also be provided',
      );
    }

    if (groupBy == null || request.statistic == null) {
      return dataPoints;
    } else {
      final statisticType = request.statistic!;
      return _healthDataAggregator.aggregate(
        (
          data: dataPoints,
          groupBy: groupBy,
          startTime: startTime,
          endTime: endTime,
          aggregatePerSource: _aggregatePerSource,
          statisticType: statisticType,
        ),
      );
    }
  }

  Future<List<AppHealthDataPoint>> _processDataPoints(
    HealthDataRequest request,
    DateTime startTime,
    DateTime endTime,
  ) async {
    final VytalHealthDataCategory valueType = request.valueType;

    _validateTimeRange(startTime, endTime);
    await _healthPermissionsGuard.ensurePermissions(
      _healthClient,
      valueType.platformHealthDataTypes,
    );

    final List<HealthDataPoint> healthDataPoints =
        await _fetchHealthDataPoints(valueType, startTime, endTime);

    final normalizedDataPoints =
        _normalizeHealthDataPoints(valueType, healthDataPoints);

    return _healthDataMapper.map(normalizedDataPoints);
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

  Future<List<HealthDataPoint>> _fetchHealthDataPoints(
    VytalHealthDataCategory valueType,
    DateTime startTime,
    DateTime endTime,
  ) async {
    final List<HealthDataPoint> result = [];

    final healthData = await _healthClient.getHealthDataFromTypes(
      types: valueType.platformHealthDataTypes,
      startTime: startTime,
      endTime: endTime,
    );
    result.addAll(healthData);

    return result;
  }

  List<HealthDataPoint> _normalizeHealthDataPoints(
    VytalHealthDataCategory category,
    List<HealthDataPoint> dataPoints,
  ) {
    if (category != VytalHealthDataCategory.SLEEP || dataPoints.isEmpty) {
      return dataPoints;
    }

    return _sleepSessionNormalizer.normalize(dataPoints);
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
        sourceId: null,
      ),
    ];
  }

  List<AggregatedHealthDataPoint> _buildAggregatedStatisticsResponse(
    List<AggregatedHealthDataPoint> aggregatedData,
    StatisticType statisticType,
  ) =>
      aggregatedData;

  HealthDataResponse _createSuccessResponse(
    List<AppHealthDataPoint> healthData,
    HealthDataRequest request,
  ) {
    final isAggregated =
        healthData.all((point) => point is AggregatedHealthDataPoint);
    return HealthDataResponse(
      success: true,
      count: healthData.length,
      healthData: healthData,
      valueType: request.valueType.name,
      startTime: request.startTime.toIso8601String(),
      endTime: request.endTime.toIso8601String(),
      groupBy: isAggregated ? request.groupBy?.name : null,
      isAggregated: isAggregated,
      statisticType: isAggregated ? request.statistic?.name : null,
    );
  }
}
