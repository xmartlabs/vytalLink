// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'summary_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SummaryMetricRequest _$SummaryMetricRequestFromJson(Map<String, dynamic> json) {
  return _SummaryMetricRequest.fromJson(json);
}

/// @nodoc
mixin _$SummaryMetricRequest {
  VytalHealthDataCategory get valueType => throw _privateConstructorUsedError;
  TimeGroupBy? get groupBy => throw _privateConstructorUsedError;
  StatisticType? get statistic => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SummaryMetricRequestCopyWith<SummaryMetricRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SummaryMetricRequestCopyWith<$Res> {
  factory $SummaryMetricRequestCopyWith(SummaryMetricRequest value,
          $Res Function(SummaryMetricRequest) then) =
      _$SummaryMetricRequestCopyWithImpl<$Res, SummaryMetricRequest>;
  @useResult
  $Res call(
      {VytalHealthDataCategory valueType,
      TimeGroupBy? groupBy,
      StatisticType? statistic});
}

/// @nodoc
class _$SummaryMetricRequestCopyWithImpl<$Res,
        $Val extends SummaryMetricRequest>
    implements $SummaryMetricRequestCopyWith<$Res> {
  _$SummaryMetricRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? valueType = null,
    Object? groupBy = freezed,
    Object? statistic = freezed,
  }) {
    return _then(_value.copyWith(
      valueType: null == valueType
          ? _value.valueType
          : valueType // ignore: cast_nullable_to_non_nullable
              as VytalHealthDataCategory,
      groupBy: freezed == groupBy
          ? _value.groupBy
          : groupBy // ignore: cast_nullable_to_non_nullable
              as TimeGroupBy?,
      statistic: freezed == statistic
          ? _value.statistic
          : statistic // ignore: cast_nullable_to_non_nullable
              as StatisticType?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SummaryMetricRequestImplCopyWith<$Res>
    implements $SummaryMetricRequestCopyWith<$Res> {
  factory _$$SummaryMetricRequestImplCopyWith(_$SummaryMetricRequestImpl value,
          $Res Function(_$SummaryMetricRequestImpl) then) =
      __$$SummaryMetricRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {VytalHealthDataCategory valueType,
      TimeGroupBy? groupBy,
      StatisticType? statistic});
}

/// @nodoc
class __$$SummaryMetricRequestImplCopyWithImpl<$Res>
    extends _$SummaryMetricRequestCopyWithImpl<$Res, _$SummaryMetricRequestImpl>
    implements _$$SummaryMetricRequestImplCopyWith<$Res> {
  __$$SummaryMetricRequestImplCopyWithImpl(_$SummaryMetricRequestImpl _value,
      $Res Function(_$SummaryMetricRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? valueType = null,
    Object? groupBy = freezed,
    Object? statistic = freezed,
  }) {
    return _then(_$SummaryMetricRequestImpl(
      valueType: null == valueType
          ? _value.valueType
          : valueType // ignore: cast_nullable_to_non_nullable
              as VytalHealthDataCategory,
      groupBy: freezed == groupBy
          ? _value.groupBy
          : groupBy // ignore: cast_nullable_to_non_nullable
              as TimeGroupBy?,
      statistic: freezed == statistic
          ? _value.statistic
          : statistic // ignore: cast_nullable_to_non_nullable
              as StatisticType?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SummaryMetricRequestImpl implements _SummaryMetricRequest {
  const _$SummaryMetricRequestImpl(
      {required this.valueType, this.groupBy, this.statistic});

  factory _$SummaryMetricRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$SummaryMetricRequestImplFromJson(json);

  @override
  final VytalHealthDataCategory valueType;
  @override
  final TimeGroupBy? groupBy;
  @override
  final StatisticType? statistic;

  @override
  String toString() {
    return 'SummaryMetricRequest(valueType: $valueType, groupBy: $groupBy, statistic: $statistic)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SummaryMetricRequestImpl &&
            (identical(other.valueType, valueType) ||
                other.valueType == valueType) &&
            (identical(other.groupBy, groupBy) || other.groupBy == groupBy) &&
            (identical(other.statistic, statistic) ||
                other.statistic == statistic));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, valueType, groupBy, statistic);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SummaryMetricRequestImplCopyWith<_$SummaryMetricRequestImpl>
      get copyWith =>
          __$$SummaryMetricRequestImplCopyWithImpl<_$SummaryMetricRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SummaryMetricRequestImplToJson(
      this,
    );
  }
}

abstract class _SummaryMetricRequest implements SummaryMetricRequest {
  const factory _SummaryMetricRequest(
      {required final VytalHealthDataCategory valueType,
      final TimeGroupBy? groupBy,
      final StatisticType? statistic}) = _$SummaryMetricRequestImpl;

  factory _SummaryMetricRequest.fromJson(Map<String, dynamic> json) =
      _$SummaryMetricRequestImpl.fromJson;

  @override
  VytalHealthDataCategory get valueType;
  @override
  TimeGroupBy? get groupBy;
  @override
  StatisticType? get statistic;
  @override
  @JsonKey(ignore: true)
  _$$SummaryMetricRequestImplCopyWith<_$SummaryMetricRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SummaryRequest _$SummaryRequestFromJson(Map<String, dynamic> json) {
  return _SummaryRequest.fromJson(json);
}

/// @nodoc
mixin _$SummaryRequest {
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  List<SummaryMetricRequest>? get metrics => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SummaryRequestCopyWith<SummaryRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SummaryRequestCopyWith<$Res> {
  factory $SummaryRequestCopyWith(
          SummaryRequest value, $Res Function(SummaryRequest) then) =
      _$SummaryRequestCopyWithImpl<$Res, SummaryRequest>;
  @useResult
  $Res call(
      {DateTime startTime,
      DateTime endTime,
      List<SummaryMetricRequest>? metrics});
}

/// @nodoc
class _$SummaryRequestCopyWithImpl<$Res, $Val extends SummaryRequest>
    implements $SummaryRequestCopyWith<$Res> {
  _$SummaryRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startTime = null,
    Object? endTime = null,
    Object? metrics = freezed,
  }) {
    return _then(_value.copyWith(
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metrics: freezed == metrics
          ? _value.metrics
          : metrics // ignore: cast_nullable_to_non_nullable
              as List<SummaryMetricRequest>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SummaryRequestImplCopyWith<$Res>
    implements $SummaryRequestCopyWith<$Res> {
  factory _$$SummaryRequestImplCopyWith(_$SummaryRequestImpl value,
          $Res Function(_$SummaryRequestImpl) then) =
      __$$SummaryRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime startTime,
      DateTime endTime,
      List<SummaryMetricRequest>? metrics});
}

/// @nodoc
class __$$SummaryRequestImplCopyWithImpl<$Res>
    extends _$SummaryRequestCopyWithImpl<$Res, _$SummaryRequestImpl>
    implements _$$SummaryRequestImplCopyWith<$Res> {
  __$$SummaryRequestImplCopyWithImpl(
      _$SummaryRequestImpl _value, $Res Function(_$SummaryRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startTime = null,
    Object? endTime = null,
    Object? metrics = freezed,
  }) {
    return _then(_$SummaryRequestImpl(
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metrics: freezed == metrics
          ? _value._metrics
          : metrics // ignore: cast_nullable_to_non_nullable
              as List<SummaryMetricRequest>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SummaryRequestImpl implements _SummaryRequest {
  const _$SummaryRequestImpl(
      {required this.startTime,
      required this.endTime,
      final List<SummaryMetricRequest>? metrics})
      : _metrics = metrics;

  factory _$SummaryRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$SummaryRequestImplFromJson(json);

  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  final List<SummaryMetricRequest>? _metrics;
  @override
  List<SummaryMetricRequest>? get metrics {
    final value = _metrics;
    if (value == null) return null;
    if (_metrics is EqualUnmodifiableListView) return _metrics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'SummaryRequest(startTime: $startTime, endTime: $endTime, metrics: $metrics)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SummaryRequestImpl &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            const DeepCollectionEquality().equals(other._metrics, _metrics));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, startTime, endTime,
      const DeepCollectionEquality().hash(_metrics));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SummaryRequestImplCopyWith<_$SummaryRequestImpl> get copyWith =>
      __$$SummaryRequestImplCopyWithImpl<_$SummaryRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SummaryRequestImplToJson(
      this,
    );
  }
}

abstract class _SummaryRequest implements SummaryRequest {
  const factory _SummaryRequest(
      {required final DateTime startTime,
      required final DateTime endTime,
      final List<SummaryMetricRequest>? metrics}) = _$SummaryRequestImpl;

  factory _SummaryRequest.fromJson(Map<String, dynamic> json) =
      _$SummaryRequestImpl.fromJson;

  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  List<SummaryMetricRequest>? get metrics;
  @override
  @JsonKey(ignore: true)
  _$$SummaryRequestImplCopyWith<_$SummaryRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
