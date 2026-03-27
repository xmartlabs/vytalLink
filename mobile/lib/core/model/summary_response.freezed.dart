// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'summary_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SummaryMetricResult _$SummaryMetricResultFromJson(Map<String, dynamic> json) {
  return _SummaryMetricResult.fromJson(json);
}

/// @nodoc
mixin _$SummaryMetricResult {
  VytalHealthDataCategory get valueType => throw _privateConstructorUsedError;
  bool get success => throw _privateConstructorUsedError;
  HealthDataResponse? get data => throw _privateConstructorUsedError;
  @JsonKey(name: 'error_message')
  String? get errorMessage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SummaryMetricResultCopyWith<SummaryMetricResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SummaryMetricResultCopyWith<$Res> {
  factory $SummaryMetricResultCopyWith(
          SummaryMetricResult value, $Res Function(SummaryMetricResult) then) =
      _$SummaryMetricResultCopyWithImpl<$Res, SummaryMetricResult>;
  @useResult
  $Res call(
      {VytalHealthDataCategory valueType,
      bool success,
      HealthDataResponse? data,
      @JsonKey(name: 'error_message') String? errorMessage});

  $HealthDataResponseCopyWith<$Res>? get data;
}

/// @nodoc
class _$SummaryMetricResultCopyWithImpl<$Res, $Val extends SummaryMetricResult>
    implements $SummaryMetricResultCopyWith<$Res> {
  _$SummaryMetricResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? valueType = null,
    Object? success = null,
    Object? data = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      valueType: null == valueType
          ? _value.valueType
          : valueType // ignore: cast_nullable_to_non_nullable
              as VytalHealthDataCategory,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as HealthDataResponse?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $HealthDataResponseCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $HealthDataResponseCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SummaryMetricResultImplCopyWith<$Res>
    implements $SummaryMetricResultCopyWith<$Res> {
  factory _$$SummaryMetricResultImplCopyWith(_$SummaryMetricResultImpl value,
          $Res Function(_$SummaryMetricResultImpl) then) =
      __$$SummaryMetricResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {VytalHealthDataCategory valueType,
      bool success,
      HealthDataResponse? data,
      @JsonKey(name: 'error_message') String? errorMessage});

  @override
  $HealthDataResponseCopyWith<$Res>? get data;
}

/// @nodoc
class __$$SummaryMetricResultImplCopyWithImpl<$Res>
    extends _$SummaryMetricResultCopyWithImpl<$Res, _$SummaryMetricResultImpl>
    implements _$$SummaryMetricResultImplCopyWith<$Res> {
  __$$SummaryMetricResultImplCopyWithImpl(_$SummaryMetricResultImpl _value,
      $Res Function(_$SummaryMetricResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? valueType = null,
    Object? success = null,
    Object? data = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_$SummaryMetricResultImpl(
      valueType: null == valueType
          ? _value.valueType
          : valueType // ignore: cast_nullable_to_non_nullable
              as VytalHealthDataCategory,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as HealthDataResponse?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SummaryMetricResultImpl implements _SummaryMetricResult {
  const _$SummaryMetricResultImpl(
      {required this.valueType,
      required this.success,
      this.data,
      @JsonKey(name: 'error_message') this.errorMessage});

  factory _$SummaryMetricResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$SummaryMetricResultImplFromJson(json);

  @override
  final VytalHealthDataCategory valueType;
  @override
  final bool success;
  @override
  final HealthDataResponse? data;
  @override
  @JsonKey(name: 'error_message')
  final String? errorMessage;

  @override
  String toString() {
    return 'SummaryMetricResult(valueType: $valueType, success: $success, data: $data, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SummaryMetricResultImpl &&
            (identical(other.valueType, valueType) ||
                other.valueType == valueType) &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, valueType, success, data, errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SummaryMetricResultImplCopyWith<_$SummaryMetricResultImpl> get copyWith =>
      __$$SummaryMetricResultImplCopyWithImpl<_$SummaryMetricResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SummaryMetricResultImplToJson(
      this,
    );
  }
}

abstract class _SummaryMetricResult implements SummaryMetricResult {
  const factory _SummaryMetricResult(
          {required final VytalHealthDataCategory valueType,
          required final bool success,
          final HealthDataResponse? data,
          @JsonKey(name: 'error_message') final String? errorMessage}) =
      _$SummaryMetricResultImpl;

  factory _SummaryMetricResult.fromJson(Map<String, dynamic> json) =
      _$SummaryMetricResultImpl.fromJson;

  @override
  VytalHealthDataCategory get valueType;
  @override
  bool get success;
  @override
  HealthDataResponse? get data;
  @override
  @JsonKey(name: 'error_message')
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$SummaryMetricResultImplCopyWith<_$SummaryMetricResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SummaryResponse _$SummaryResponseFromJson(Map<String, dynamic> json) {
  return _SummaryResponse.fromJson(json);
}

/// @nodoc
mixin _$SummaryResponse {
  bool get success => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError;
  String get endTime => throw _privateConstructorUsedError;
  List<SummaryMetricResult> get results => throw _privateConstructorUsedError;
  @JsonKey(name: 'error_message')
  String? get errorMessage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SummaryResponseCopyWith<SummaryResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SummaryResponseCopyWith<$Res> {
  factory $SummaryResponseCopyWith(
          SummaryResponse value, $Res Function(SummaryResponse) then) =
      _$SummaryResponseCopyWithImpl<$Res, SummaryResponse>;
  @useResult
  $Res call(
      {bool success,
      String startTime,
      String endTime,
      List<SummaryMetricResult> results,
      @JsonKey(name: 'error_message') String? errorMessage});
}

/// @nodoc
class _$SummaryResponseCopyWithImpl<$Res, $Val extends SummaryResponse>
    implements $SummaryResponseCopyWith<$Res> {
  _$SummaryResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? results = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      results: null == results
          ? _value.results
          : results // ignore: cast_nullable_to_non_nullable
              as List<SummaryMetricResult>,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SummaryResponseImplCopyWith<$Res>
    implements $SummaryResponseCopyWith<$Res> {
  factory _$$SummaryResponseImplCopyWith(_$SummaryResponseImpl value,
          $Res Function(_$SummaryResponseImpl) then) =
      __$$SummaryResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      String startTime,
      String endTime,
      List<SummaryMetricResult> results,
      @JsonKey(name: 'error_message') String? errorMessage});
}

/// @nodoc
class __$$SummaryResponseImplCopyWithImpl<$Res>
    extends _$SummaryResponseCopyWithImpl<$Res, _$SummaryResponseImpl>
    implements _$$SummaryResponseImplCopyWith<$Res> {
  __$$SummaryResponseImplCopyWithImpl(
      _$SummaryResponseImpl _value, $Res Function(_$SummaryResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? results = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$SummaryResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      results: null == results
          ? _value._results
          : results // ignore: cast_nullable_to_non_nullable
              as List<SummaryMetricResult>,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SummaryResponseImpl implements _SummaryResponse {
  const _$SummaryResponseImpl(
      {required this.success,
      required this.startTime,
      required this.endTime,
      required final List<SummaryMetricResult> results,
      @JsonKey(name: 'error_message') this.errorMessage})
      : _results = results;

  factory _$SummaryResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SummaryResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final String startTime;
  @override
  final String endTime;
  final List<SummaryMetricResult> _results;
  @override
  List<SummaryMetricResult> get results {
    if (_results is EqualUnmodifiableListView) return _results;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_results);
  }

  @override
  @JsonKey(name: 'error_message')
  final String? errorMessage;

  @override
  String toString() {
    return 'SummaryResponse(success: $success, startTime: $startTime, endTime: $endTime, results: $results, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SummaryResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            const DeepCollectionEquality().equals(other._results, _results) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, success, startTime, endTime,
      const DeepCollectionEquality().hash(_results), errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SummaryResponseImplCopyWith<_$SummaryResponseImpl> get copyWith =>
      __$$SummaryResponseImplCopyWithImpl<_$SummaryResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SummaryResponseImplToJson(
      this,
    );
  }
}

abstract class _SummaryResponse implements SummaryResponse {
  const factory _SummaryResponse(
          {required final bool success,
          required final String startTime,
          required final String endTime,
          required final List<SummaryMetricResult> results,
          @JsonKey(name: 'error_message') final String? errorMessage}) =
      _$SummaryResponseImpl;

  factory _SummaryResponse.fromJson(Map<String, dynamic> json) =
      _$SummaryResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String get startTime;
  @override
  String get endTime;
  @override
  List<SummaryMetricResult> get results;
  @override
  @JsonKey(name: 'error_message')
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$SummaryResponseImplCopyWith<_$SummaryResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
