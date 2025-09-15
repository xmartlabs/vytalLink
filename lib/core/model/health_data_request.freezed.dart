// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_data_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HealthDataRequest _$HealthDataRequestFromJson(Map<String, dynamic> json) {
  return _HealthDataRequest.fromJson(json);
}

/// @nodoc
mixin _$HealthDataRequest {
  VytalHealthDataCategory get valueType => throw _privateConstructorUsedError;
  @JsonKey(name: 'startTime')
  DateTime get startTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'endTime')
  DateTime get endTime => throw _privateConstructorUsedError;
  TimeGroupBy get groupBy => throw _privateConstructorUsedError;
  StatisticType get statistic => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HealthDataRequestCopyWith<HealthDataRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HealthDataRequestCopyWith<$Res> {
  factory $HealthDataRequestCopyWith(
          HealthDataRequest value, $Res Function(HealthDataRequest) then) =
      _$HealthDataRequestCopyWithImpl<$Res, HealthDataRequest>;
  @useResult
  $Res call(
      {VytalHealthDataCategory valueType,
      @JsonKey(name: 'startTime') DateTime startTime,
      @JsonKey(name: 'endTime') DateTime endTime,
      TimeGroupBy groupBy,
      StatisticType statistic});
}

/// @nodoc
class _$HealthDataRequestCopyWithImpl<$Res, $Val extends HealthDataRequest>
    implements $HealthDataRequestCopyWith<$Res> {
  _$HealthDataRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? valueType = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? groupBy = null,
    Object? statistic = null,
  }) {
    return _then(_value.copyWith(
      valueType: null == valueType
          ? _value.valueType
          : valueType // ignore: cast_nullable_to_non_nullable
              as VytalHealthDataCategory,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      groupBy: null == groupBy
          ? _value.groupBy
          : groupBy // ignore: cast_nullable_to_non_nullable
              as TimeGroupBy,
      statistic: null == statistic
          ? _value.statistic
          : statistic // ignore: cast_nullable_to_non_nullable
              as StatisticType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HealthDataRequestImplCopyWith<$Res>
    implements $HealthDataRequestCopyWith<$Res> {
  factory _$$HealthDataRequestImplCopyWith(_$HealthDataRequestImpl value,
          $Res Function(_$HealthDataRequestImpl) then) =
      __$$HealthDataRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {VytalHealthDataCategory valueType,
      @JsonKey(name: 'startTime') DateTime startTime,
      @JsonKey(name: 'endTime') DateTime endTime,
      TimeGroupBy groupBy,
      StatisticType statistic});
}

/// @nodoc
class __$$HealthDataRequestImplCopyWithImpl<$Res>
    extends _$HealthDataRequestCopyWithImpl<$Res, _$HealthDataRequestImpl>
    implements _$$HealthDataRequestImplCopyWith<$Res> {
  __$$HealthDataRequestImplCopyWithImpl(_$HealthDataRequestImpl _value,
      $Res Function(_$HealthDataRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? valueType = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? groupBy = null,
    Object? statistic = null,
  }) {
    return _then(_$HealthDataRequestImpl(
      valueType: null == valueType
          ? _value.valueType
          : valueType // ignore: cast_nullable_to_non_nullable
              as VytalHealthDataCategory,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      groupBy: null == groupBy
          ? _value.groupBy
          : groupBy // ignore: cast_nullable_to_non_nullable
              as TimeGroupBy,
      statistic: null == statistic
          ? _value.statistic
          : statistic // ignore: cast_nullable_to_non_nullable
              as StatisticType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HealthDataRequestImpl implements _HealthDataRequest {
  const _$HealthDataRequestImpl(
      {required this.valueType,
      @JsonKey(name: 'startTime') required this.startTime,
      @JsonKey(name: 'endTime') required this.endTime,
      required this.groupBy,
      required this.statistic});

  factory _$HealthDataRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$HealthDataRequestImplFromJson(json);

  @override
  final VytalHealthDataCategory valueType;
  @override
  @JsonKey(name: 'startTime')
  final DateTime startTime;
  @override
  @JsonKey(name: 'endTime')
  final DateTime endTime;
  @override
  final TimeGroupBy groupBy;
  @override
  final StatisticType statistic;

  @override
  String toString() {
    return 'HealthDataRequest(valueType: $valueType, startTime: $startTime, endTime: $endTime, groupBy: $groupBy, statistic: $statistic)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthDataRequestImpl &&
            (identical(other.valueType, valueType) ||
                other.valueType == valueType) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.groupBy, groupBy) || other.groupBy == groupBy) &&
            (identical(other.statistic, statistic) ||
                other.statistic == statistic));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, valueType, startTime, endTime, groupBy, statistic);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthDataRequestImplCopyWith<_$HealthDataRequestImpl> get copyWith =>
      __$$HealthDataRequestImplCopyWithImpl<_$HealthDataRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HealthDataRequestImplToJson(
      this,
    );
  }
}

abstract class _HealthDataRequest implements HealthDataRequest {
  const factory _HealthDataRequest(
      {required final VytalHealthDataCategory valueType,
      @JsonKey(name: 'startTime') required final DateTime startTime,
      @JsonKey(name: 'endTime') required final DateTime endTime,
      required final TimeGroupBy groupBy,
      required final StatisticType statistic}) = _$HealthDataRequestImpl;

  factory _HealthDataRequest.fromJson(Map<String, dynamic> json) =
      _$HealthDataRequestImpl.fromJson;

  @override
  VytalHealthDataCategory get valueType;
  @override
  @JsonKey(name: 'startTime')
  DateTime get startTime;
  @override
  @JsonKey(name: 'endTime')
  DateTime get endTime;
  @override
  TimeGroupBy get groupBy;
  @override
  StatisticType get statistic;
  @override
  @JsonKey(ignore: true)
  _$$HealthDataRequestImplCopyWith<_$HealthDataRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
