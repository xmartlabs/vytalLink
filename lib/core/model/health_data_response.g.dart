// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HealthDataResponseImpl _$$HealthDataResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$HealthDataResponseImpl(
      success: json['success'] as bool,
      count: (json['count'] as num).toInt(),
      healthData: (json['health_data'] as List<dynamic>)
          .map((e) => AppHealthDataPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      valueType: json['value_type'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      groupBy: json['group_by'] as String?,
      isAggregated: json['is_aggregated'] as bool?,
      statisticType: json['statistic_type'] as String?,
    );

Map<String, dynamic> _$$HealthDataResponseImplToJson(
        _$HealthDataResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'count': instance.count,
      'health_data': instance.healthData.map((e) => e.toJson()).toList(),
      'value_type': instance.valueType,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'group_by': instance.groupBy,
      'is_aggregated': instance.isAggregated,
      'statistic_type': instance.statisticType,
    };

_$AggregatedHealthDataResponseImpl _$$AggregatedHealthDataResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$AggregatedHealthDataResponseImpl(
      success: json['success'] as bool,
      count: (json['count'] as num).toInt(),
      healthData: (json['health_data'] as List<dynamic>)
          .map((e) => AppHealthDataPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      valueType: json['value_type'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      groupBy: json['group_by'] as String?,
      isAggregated: json['is_aggregated'] as bool?,
      statisticType: json['statistic_type'] as String?,
    );

Map<String, dynamic> _$$AggregatedHealthDataResponseImplToJson(
        _$AggregatedHealthDataResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'count': instance.count,
      'health_data': instance.healthData.map((e) => e.toJson()).toList(),
      'value_type': instance.valueType,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'group_by': instance.groupBy,
      'is_aggregated': instance.isAggregated,
      'statistic_type': instance.statisticType,
    };

_$HealthDataErrorResponseImpl _$$HealthDataErrorResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$HealthDataErrorResponseImpl(
      success: json['success'] as bool,
      errorMessage: json['error_message'] as String,
    );

Map<String, dynamic> _$$HealthDataErrorResponseImplToJson(
        _$HealthDataErrorResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error_message': instance.errorMessage,
    };
