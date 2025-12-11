// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SummaryMetricRequestImpl _$$SummaryMetricRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$SummaryMetricRequestImpl(
      valueType:
          $enumDecode(_$VytalHealthDataCategoryEnumMap, json['value_type']),
      groupBy: $enumDecodeNullable(_$TimeGroupByEnumMap, json['group_by']),
      statistic: $enumDecodeNullable(_$StatisticTypeEnumMap, json['statistic']),
    );

Map<String, dynamic> _$$SummaryMetricRequestImplToJson(
        _$SummaryMetricRequestImpl instance) =>
    <String, dynamic>{
      'value_type': _$VytalHealthDataCategoryEnumMap[instance.valueType]!,
      'group_by': _$TimeGroupByEnumMap[instance.groupBy],
      'statistic': _$StatisticTypeEnumMap[instance.statistic],
    };

const _$VytalHealthDataCategoryEnumMap = {
  VytalHealthDataCategory.STEPS: 'STEPS',
  VytalHealthDataCategory.HEART_RATE: 'HEART_RATE',
  VytalHealthDataCategory.CALORIES: 'CALORIES',
  VytalHealthDataCategory.BLOOD_OXYGEN: 'BLOOD_OXYGEN',
  VytalHealthDataCategory.BLOOD_PRESSURE: 'BLOOD_PRESSURE',
  VytalHealthDataCategory.BODY_TEMPERATURE: 'BODY_TEMPERATURE',
  VytalHealthDataCategory.BODY_METRICS: 'BODY_METRICS',
  VytalHealthDataCategory.GLUCOSE: 'GLUCOSE',
  VytalHealthDataCategory.EXERCISE_TIME: 'EXERCISE_TIME',
  VytalHealthDataCategory.RESPIRATORY_RATE: 'RESPIRATORY_RATE',
  VytalHealthDataCategory.WALKING_SPEED: 'WALKING_SPEED',
  VytalHealthDataCategory.SLEEP: 'SLEEP',
  VytalHealthDataCategory.MINDFULNESS: 'MINDFULNESS',
  VytalHealthDataCategory.WORKOUT: 'WORKOUT',
  VytalHealthDataCategory.DISTANCE: 'DISTANCE',
};

const _$TimeGroupByEnumMap = {
  TimeGroupBy.hour: 'HOUR',
  TimeGroupBy.day: 'DAY',
  TimeGroupBy.week: 'WEEK',
  TimeGroupBy.month: 'MONTH',
};

const _$StatisticTypeEnumMap = {
  StatisticType.sum: 'SUM',
  StatisticType.average: 'AVERAGE',
};

_$SummaryRequestImpl _$$SummaryRequestImplFromJson(Map<String, dynamic> json) =>
    _$SummaryRequestImpl(
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      metrics: (json['metrics'] as List<dynamic>?)
          ?.map((e) => SummaryMetricRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SummaryRequestImplToJson(
        _$SummaryRequestImpl instance) =>
    <String, dynamic>{
      'start_time': instance.startTime.toIso8601String(),
      'end_time': instance.endTime.toIso8601String(),
      'metrics': instance.metrics?.map((e) => e.toJson()).toList(),
    };
