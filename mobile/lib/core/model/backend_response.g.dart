// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backend_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HealthDataBackendResponseImpl _$$HealthDataBackendResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$HealthDataBackendResponseImpl(
      id: json['id'] as String,
      data: json['health_data'] as Map<String, dynamic>,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$HealthDataBackendResponseImplToJson(
        _$HealthDataBackendResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'health_data': instance.data,
      'type': instance.$type,
    };

_$GenericBackendResponseImpl _$$GenericBackendResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GenericBackendResponseImpl(
      id: json['id'] as String?,
      data: json['data'] as Map<String, dynamic>?,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$GenericBackendResponseImplToJson(
        _$GenericBackendResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'data': instance.data,
      'type': instance.$type,
    };
