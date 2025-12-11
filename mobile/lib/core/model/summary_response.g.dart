// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SummaryMetricResultImpl _$$SummaryMetricResultImplFromJson(
        Map<String, dynamic> json) =>
    _$SummaryMetricResultImpl(
      valueType:
          $enumDecode(_$VytalHealthDataCategoryEnumMap, json['value_type']),
      success: json['success'] as bool,
      data: json['data'] == null
          ? null
          : HealthDataResponse.fromJson(json['data'] as Map<String, dynamic>),
      errorMessage: json['error_message'] as String?,
    );

Map<String, dynamic> _$$SummaryMetricResultImplToJson(
        _$SummaryMetricResultImpl instance) =>
    <String, dynamic>{
      'value_type': _$VytalHealthDataCategoryEnumMap[instance.valueType]!,
      'success': instance.success,
      'data': instance.data?.toJson(),
      'error_message': instance.errorMessage,
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

_$SummaryResponseImpl _$$SummaryResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$SummaryResponseImpl(
      success: json['success'] as bool,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      results: (json['results'] as List<dynamic>)
          .map((e) => SummaryMetricResult.fromJson(e as Map<String, dynamic>))
          .toList(),
      errorMessage: json['error_message'] as String?,
    );

Map<String, dynamic> _$$SummaryResponseImplToJson(
        _$SummaryResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'results': instance.results.map((e) => e.toJson()).toList(),
      'error_message': instance.errorMessage,
    };
