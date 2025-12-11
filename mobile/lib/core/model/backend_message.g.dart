// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backend_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HealthDataRequestMessageImpl _$$HealthDataRequestMessageImplFromJson(
        Map<String, dynamic> json) =>
    _$HealthDataRequestMessageImpl(
      id: json['request_id'] as String,
      payload: json['payload'] as Map<String, dynamic>,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$HealthDataRequestMessageImplToJson(
        _$HealthDataRequestMessageImpl instance) =>
    <String, dynamic>{
      'request_id': instance.id,
      'payload': instance.payload,
      'type': instance.$type,
    };

_$ConnectionCodeMessageImpl _$$ConnectionCodeMessageImplFromJson(
        Map<String, dynamic> json) =>
    _$ConnectionCodeMessageImpl(
      code: json['code'] as String,
      word: json['word'] as String,
      message: json['message'] as String,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$ConnectionCodeMessageImplToJson(
        _$ConnectionCodeMessageImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'word': instance.word,
      'message': instance.message,
      'type': instance.$type,
    };

_$SummaryRequestMessageImpl _$$SummaryRequestMessageImplFromJson(
        Map<String, dynamic> json) =>
    _$SummaryRequestMessageImpl(
      id: json['request_id'] as String,
      payload: json['payload'] as Map<String, dynamic>,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$SummaryRequestMessageImplToJson(
        _$SummaryRequestMessageImpl instance) =>
    <String, dynamic>{
      'request_id': instance.id,
      'payload': instance.payload,
      'type': instance.$type,
    };

_$UnknownMessageImpl _$$UnknownMessageImplFromJson(Map<String, dynamic> json) =>
    _$UnknownMessageImpl(
      data: json['data'] as Map<String, dynamic>,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$UnknownMessageImplToJson(
        _$UnknownMessageImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'type': instance.$type,
    };
