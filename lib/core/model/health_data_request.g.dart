// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_data_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HealthDataRequestImpl _$$HealthDataRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$HealthDataRequestImpl(
      valueType:
          $enumDecode(_$VytalHealthDataCategoryEnumMap, json['value_type']),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      groupBy: $enumDecode(_$TimeGroupByEnumMap, json['group_by']),
      statistic: $enumDecode(_$StatisticTypeEnumMap, json['statistic']),
    );

Map<String, dynamic> _$$HealthDataRequestImplToJson(
        _$HealthDataRequestImpl instance) =>
    <String, dynamic>{
      'value_type': _$VytalHealthDataCategoryEnumMap[instance.valueType]!,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'group_by': _$TimeGroupByEnumMap[instance.groupBy]!,
      'statistic': _$StatisticTypeEnumMap[instance.statistic]!,
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
