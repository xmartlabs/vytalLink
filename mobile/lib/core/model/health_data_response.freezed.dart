// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_data_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HealthDataResponse _$HealthDataResponseFromJson(Map<String, dynamic> json) {
  return _HealthDataResponse.fromJson(json);
}

/// @nodoc
mixin _$HealthDataResponse {
  bool get success => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  List<AppHealthDataPoint> get healthData => throw _privateConstructorUsedError;
  @JsonKey(name: 'value_type')
  String get valueType => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError;
  String get endTime => throw _privateConstructorUsedError;
  String? get groupBy => throw _privateConstructorUsedError;
  bool? get isAggregated => throw _privateConstructorUsedError;
  String? get statisticType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HealthDataResponseCopyWith<HealthDataResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HealthDataResponseCopyWith<$Res> {
  factory $HealthDataResponseCopyWith(
          HealthDataResponse value, $Res Function(HealthDataResponse) then) =
      _$HealthDataResponseCopyWithImpl<$Res, HealthDataResponse>;
  @useResult
  $Res call(
      {bool success,
      int count,
      List<AppHealthDataPoint> healthData,
      @JsonKey(name: 'value_type') String valueType,
      String startTime,
      String endTime,
      String? groupBy,
      bool? isAggregated,
      String? statisticType});
}

/// @nodoc
class _$HealthDataResponseCopyWithImpl<$Res, $Val extends HealthDataResponse>
    implements $HealthDataResponseCopyWith<$Res> {
  _$HealthDataResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? count = null,
    Object? healthData = null,
    Object? valueType = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? groupBy = freezed,
    Object? isAggregated = freezed,
    Object? statisticType = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      healthData: null == healthData
          ? _value.healthData
          : healthData // ignore: cast_nullable_to_non_nullable
              as List<AppHealthDataPoint>,
      valueType: null == valueType
          ? _value.valueType
          : valueType // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      groupBy: freezed == groupBy
          ? _value.groupBy
          : groupBy // ignore: cast_nullable_to_non_nullable
              as String?,
      isAggregated: freezed == isAggregated
          ? _value.isAggregated
          : isAggregated // ignore: cast_nullable_to_non_nullable
              as bool?,
      statisticType: freezed == statisticType
          ? _value.statisticType
          : statisticType // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HealthDataResponseImplCopyWith<$Res>
    implements $HealthDataResponseCopyWith<$Res> {
  factory _$$HealthDataResponseImplCopyWith(_$HealthDataResponseImpl value,
          $Res Function(_$HealthDataResponseImpl) then) =
      __$$HealthDataResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      int count,
      List<AppHealthDataPoint> healthData,
      @JsonKey(name: 'value_type') String valueType,
      String startTime,
      String endTime,
      String? groupBy,
      bool? isAggregated,
      String? statisticType});
}

/// @nodoc
class __$$HealthDataResponseImplCopyWithImpl<$Res>
    extends _$HealthDataResponseCopyWithImpl<$Res, _$HealthDataResponseImpl>
    implements _$$HealthDataResponseImplCopyWith<$Res> {
  __$$HealthDataResponseImplCopyWithImpl(_$HealthDataResponseImpl _value,
      $Res Function(_$HealthDataResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? count = null,
    Object? healthData = null,
    Object? valueType = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? groupBy = freezed,
    Object? isAggregated = freezed,
    Object? statisticType = freezed,
  }) {
    return _then(_$HealthDataResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      healthData: null == healthData
          ? _value._healthData
          : healthData // ignore: cast_nullable_to_non_nullable
              as List<AppHealthDataPoint>,
      valueType: null == valueType
          ? _value.valueType
          : valueType // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      groupBy: freezed == groupBy
          ? _value.groupBy
          : groupBy // ignore: cast_nullable_to_non_nullable
              as String?,
      isAggregated: freezed == isAggregated
          ? _value.isAggregated
          : isAggregated // ignore: cast_nullable_to_non_nullable
              as bool?,
      statisticType: freezed == statisticType
          ? _value.statisticType
          : statisticType // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HealthDataResponseImpl implements _HealthDataResponse {
  const _$HealthDataResponseImpl(
      {required this.success,
      required this.count,
      required final List<AppHealthDataPoint> healthData,
      @JsonKey(name: 'value_type') required this.valueType,
      required this.startTime,
      required this.endTime,
      this.groupBy,
      this.isAggregated,
      this.statisticType})
      : _healthData = healthData;

  factory _$HealthDataResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$HealthDataResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final int count;
  final List<AppHealthDataPoint> _healthData;
  @override
  List<AppHealthDataPoint> get healthData {
    if (_healthData is EqualUnmodifiableListView) return _healthData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_healthData);
  }

  @override
  @JsonKey(name: 'value_type')
  final String valueType;
  @override
  final String startTime;
  @override
  final String endTime;
  @override
  final String? groupBy;
  @override
  final bool? isAggregated;
  @override
  final String? statisticType;

  @override
  String toString() {
    return 'HealthDataResponse(success: $success, count: $count, healthData: $healthData, valueType: $valueType, startTime: $startTime, endTime: $endTime, groupBy: $groupBy, isAggregated: $isAggregated, statisticType: $statisticType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthDataResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.count, count) || other.count == count) &&
            const DeepCollectionEquality()
                .equals(other._healthData, _healthData) &&
            (identical(other.valueType, valueType) ||
                other.valueType == valueType) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.groupBy, groupBy) || other.groupBy == groupBy) &&
            (identical(other.isAggregated, isAggregated) ||
                other.isAggregated == isAggregated) &&
            (identical(other.statisticType, statisticType) ||
                other.statisticType == statisticType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      success,
      count,
      const DeepCollectionEquality().hash(_healthData),
      valueType,
      startTime,
      endTime,
      groupBy,
      isAggregated,
      statisticType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthDataResponseImplCopyWith<_$HealthDataResponseImpl> get copyWith =>
      __$$HealthDataResponseImplCopyWithImpl<_$HealthDataResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HealthDataResponseImplToJson(
      this,
    );
  }
}

abstract class _HealthDataResponse implements HealthDataResponse {
  const factory _HealthDataResponse(
      {required final bool success,
      required final int count,
      required final List<AppHealthDataPoint> healthData,
      @JsonKey(name: 'value_type') required final String valueType,
      required final String startTime,
      required final String endTime,
      final String? groupBy,
      final bool? isAggregated,
      final String? statisticType}) = _$HealthDataResponseImpl;

  factory _HealthDataResponse.fromJson(Map<String, dynamic> json) =
      _$HealthDataResponseImpl.fromJson;

  @override
  bool get success;
  @override
  int get count;
  @override
  List<AppHealthDataPoint> get healthData;
  @override
  @JsonKey(name: 'value_type')
  String get valueType;
  @override
  String get startTime;
  @override
  String get endTime;
  @override
  String? get groupBy;
  @override
  bool? get isAggregated;
  @override
  String? get statisticType;
  @override
  @JsonKey(ignore: true)
  _$$HealthDataResponseImplCopyWith<_$HealthDataResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HealthDataErrorResponse _$HealthDataErrorResponseFromJson(
    Map<String, dynamic> json) {
  return _HealthDataErrorResponse.fromJson(json);
}

/// @nodoc
mixin _$HealthDataErrorResponse {
  bool get success => throw _privateConstructorUsedError;
  @JsonKey(name: 'error_message')
  String get errorMessage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HealthDataErrorResponseCopyWith<HealthDataErrorResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HealthDataErrorResponseCopyWith<$Res> {
  factory $HealthDataErrorResponseCopyWith(HealthDataErrorResponse value,
          $Res Function(HealthDataErrorResponse) then) =
      _$HealthDataErrorResponseCopyWithImpl<$Res, HealthDataErrorResponse>;
  @useResult
  $Res call(
      {bool success, @JsonKey(name: 'error_message') String errorMessage});
}

/// @nodoc
class _$HealthDataErrorResponseCopyWithImpl<$Res,
        $Val extends HealthDataErrorResponse>
    implements $HealthDataErrorResponseCopyWith<$Res> {
  _$HealthDataErrorResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? errorMessage = null,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HealthDataErrorResponseImplCopyWith<$Res>
    implements $HealthDataErrorResponseCopyWith<$Res> {
  factory _$$HealthDataErrorResponseImplCopyWith(
          _$HealthDataErrorResponseImpl value,
          $Res Function(_$HealthDataErrorResponseImpl) then) =
      __$$HealthDataErrorResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success, @JsonKey(name: 'error_message') String errorMessage});
}

/// @nodoc
class __$$HealthDataErrorResponseImplCopyWithImpl<$Res>
    extends _$HealthDataErrorResponseCopyWithImpl<$Res,
        _$HealthDataErrorResponseImpl>
    implements _$$HealthDataErrorResponseImplCopyWith<$Res> {
  __$$HealthDataErrorResponseImplCopyWithImpl(
      _$HealthDataErrorResponseImpl _value,
      $Res Function(_$HealthDataErrorResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? errorMessage = null,
  }) {
    return _then(_$HealthDataErrorResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HealthDataErrorResponseImpl implements _HealthDataErrorResponse {
  const _$HealthDataErrorResponseImpl(
      {required this.success,
      @JsonKey(name: 'error_message') required this.errorMessage});

  factory _$HealthDataErrorResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$HealthDataErrorResponseImplFromJson(json);

  @override
  final bool success;
  @override
  @JsonKey(name: 'error_message')
  final String errorMessage;

  @override
  String toString() {
    return 'HealthDataErrorResponse(success: $success, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthDataErrorResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, success, errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthDataErrorResponseImplCopyWith<_$HealthDataErrorResponseImpl>
      get copyWith => __$$HealthDataErrorResponseImplCopyWithImpl<
          _$HealthDataErrorResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HealthDataErrorResponseImplToJson(
      this,
    );
  }
}

abstract class _HealthDataErrorResponse implements HealthDataErrorResponse {
  const factory _HealthDataErrorResponse(
          {required final bool success,
          @JsonKey(name: 'error_message') required final String errorMessage}) =
      _$HealthDataErrorResponseImpl;

  factory _HealthDataErrorResponse.fromJson(Map<String, dynamic> json) =
      _$HealthDataErrorResponseImpl.fromJson;

  @override
  bool get success;
  @override
  @JsonKey(name: 'error_message')
  String get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$HealthDataErrorResponseImplCopyWith<_$HealthDataErrorResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
