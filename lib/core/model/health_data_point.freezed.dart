// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_data_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppHealthDataPoint _$AppHealthDataPointFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'raw':
      return SimpleHealthDataPoint.fromJson(json);
    case 'aggregated':
      return AggregatedHealthDataPoint.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'AppHealthDataPoint',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$AppHealthDataPoint {
  String get type => throw _privateConstructorUsedError;
  dynamic get value => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  String get dateFrom => throw _privateConstructorUsedError;
  String get dateTo => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String type, dynamic value, String unit,
            String dateFrom, String dateTo)
        raw,
    required TResult Function(String type, double value, String unit,
            String dateFrom, String dateTo)
        aggregated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String type, dynamic value, String unit, String dateFrom,
            String dateTo)?
        raw,
    TResult? Function(String type, double value, String unit, String dateFrom,
            String dateTo)?
        aggregated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String type, dynamic value, String unit, String dateFrom,
            String dateTo)?
        raw,
    TResult Function(String type, double value, String unit, String dateFrom,
            String dateTo)?
        aggregated,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SimpleHealthDataPoint value) raw,
    required TResult Function(AggregatedHealthDataPoint value) aggregated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SimpleHealthDataPoint value)? raw,
    TResult? Function(AggregatedHealthDataPoint value)? aggregated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SimpleHealthDataPoint value)? raw,
    TResult Function(AggregatedHealthDataPoint value)? aggregated,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppHealthDataPointCopyWith<AppHealthDataPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppHealthDataPointCopyWith<$Res> {
  factory $AppHealthDataPointCopyWith(
          AppHealthDataPoint value, $Res Function(AppHealthDataPoint) then) =
      _$AppHealthDataPointCopyWithImpl<$Res, AppHealthDataPoint>;
  @useResult
  $Res call({String type, String unit, String dateFrom, String dateTo});
}

/// @nodoc
class _$AppHealthDataPointCopyWithImpl<$Res, $Val extends AppHealthDataPoint>
    implements $AppHealthDataPointCopyWith<$Res> {
  _$AppHealthDataPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? unit = null,
    Object? dateFrom = null,
    Object? dateTo = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      dateFrom: null == dateFrom
          ? _value.dateFrom
          : dateFrom // ignore: cast_nullable_to_non_nullable
              as String,
      dateTo: null == dateTo
          ? _value.dateTo
          : dateTo // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SimpleHealthDataPointImplCopyWith<$Res>
    implements $AppHealthDataPointCopyWith<$Res> {
  factory _$$SimpleHealthDataPointImplCopyWith(
          _$SimpleHealthDataPointImpl value,
          $Res Function(_$SimpleHealthDataPointImpl) then) =
      __$$SimpleHealthDataPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String type,
      dynamic value,
      String unit,
      String dateFrom,
      String dateTo});
}

/// @nodoc
class __$$SimpleHealthDataPointImplCopyWithImpl<$Res>
    extends _$AppHealthDataPointCopyWithImpl<$Res, _$SimpleHealthDataPointImpl>
    implements _$$SimpleHealthDataPointImplCopyWith<$Res> {
  __$$SimpleHealthDataPointImplCopyWithImpl(_$SimpleHealthDataPointImpl _value,
      $Res Function(_$SimpleHealthDataPointImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? value = freezed,
    Object? unit = null,
    Object? dateFrom = null,
    Object? dateTo = null,
  }) {
    return _then(_$SimpleHealthDataPointImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      dateFrom: null == dateFrom
          ? _value.dateFrom
          : dateFrom // ignore: cast_nullable_to_non_nullable
              as String,
      dateTo: null == dateTo
          ? _value.dateTo
          : dateTo // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SimpleHealthDataPointImpl implements SimpleHealthDataPoint {
  const _$SimpleHealthDataPointImpl(
      {required this.type,
      required this.value,
      required this.unit,
      required this.dateFrom,
      required this.dateTo,
      final String? $type})
      : $type = $type ?? 'raw';

  factory _$SimpleHealthDataPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$SimpleHealthDataPointImplFromJson(json);

  @override
  final String type;
  @override
  final dynamic value;
  @override
  final String unit;
  @override
  final String dateFrom;
  @override
  final String dateTo;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'AppHealthDataPoint.raw(type: $type, value: $value, unit: $unit, dateFrom: $dateFrom, dateTo: $dateTo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SimpleHealthDataPointImpl &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other.value, value) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.dateFrom, dateFrom) ||
                other.dateFrom == dateFrom) &&
            (identical(other.dateTo, dateTo) || other.dateTo == dateTo));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type,
      const DeepCollectionEquality().hash(value), unit, dateFrom, dateTo);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SimpleHealthDataPointImplCopyWith<_$SimpleHealthDataPointImpl>
      get copyWith => __$$SimpleHealthDataPointImplCopyWithImpl<
          _$SimpleHealthDataPointImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String type, dynamic value, String unit,
            String dateFrom, String dateTo)
        raw,
    required TResult Function(String type, double value, String unit,
            String dateFrom, String dateTo)
        aggregated,
  }) {
    return raw(type, value, unit, dateFrom, dateTo);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String type, dynamic value, String unit, String dateFrom,
            String dateTo)?
        raw,
    TResult? Function(String type, double value, String unit, String dateFrom,
            String dateTo)?
        aggregated,
  }) {
    return raw?.call(type, value, unit, dateFrom, dateTo);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String type, dynamic value, String unit, String dateFrom,
            String dateTo)?
        raw,
    TResult Function(String type, double value, String unit, String dateFrom,
            String dateTo)?
        aggregated,
    required TResult orElse(),
  }) {
    if (raw != null) {
      return raw(type, value, unit, dateFrom, dateTo);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SimpleHealthDataPoint value) raw,
    required TResult Function(AggregatedHealthDataPoint value) aggregated,
  }) {
    return raw(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SimpleHealthDataPoint value)? raw,
    TResult? Function(AggregatedHealthDataPoint value)? aggregated,
  }) {
    return raw?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SimpleHealthDataPoint value)? raw,
    TResult Function(AggregatedHealthDataPoint value)? aggregated,
    required TResult orElse(),
  }) {
    if (raw != null) {
      return raw(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SimpleHealthDataPointImplToJson(
      this,
    );
  }
}

abstract class SimpleHealthDataPoint implements AppHealthDataPoint {
  const factory SimpleHealthDataPoint(
      {required final String type,
      required final dynamic value,
      required final String unit,
      required final String dateFrom,
      required final String dateTo}) = _$SimpleHealthDataPointImpl;

  factory SimpleHealthDataPoint.fromJson(Map<String, dynamic> json) =
      _$SimpleHealthDataPointImpl.fromJson;

  @override
  String get type;
  @override
  dynamic get value;
  @override
  String get unit;
  @override
  String get dateFrom;
  @override
  String get dateTo;
  @override
  @JsonKey(ignore: true)
  _$$SimpleHealthDataPointImplCopyWith<_$SimpleHealthDataPointImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AggregatedHealthDataPointImplCopyWith<$Res>
    implements $AppHealthDataPointCopyWith<$Res> {
  factory _$$AggregatedHealthDataPointImplCopyWith(
          _$AggregatedHealthDataPointImpl value,
          $Res Function(_$AggregatedHealthDataPointImpl) then) =
      __$$AggregatedHealthDataPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String type, double value, String unit, String dateFrom, String dateTo});
}

/// @nodoc
class __$$AggregatedHealthDataPointImplCopyWithImpl<$Res>
    extends _$AppHealthDataPointCopyWithImpl<$Res,
        _$AggregatedHealthDataPointImpl>
    implements _$$AggregatedHealthDataPointImplCopyWith<$Res> {
  __$$AggregatedHealthDataPointImplCopyWithImpl(
      _$AggregatedHealthDataPointImpl _value,
      $Res Function(_$AggregatedHealthDataPointImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? value = null,
    Object? unit = null,
    Object? dateFrom = null,
    Object? dateTo = null,
  }) {
    return _then(_$AggregatedHealthDataPointImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      dateFrom: null == dateFrom
          ? _value.dateFrom
          : dateFrom // ignore: cast_nullable_to_non_nullable
              as String,
      dateTo: null == dateTo
          ? _value.dateTo
          : dateTo // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AggregatedHealthDataPointImpl implements AggregatedHealthDataPoint {
  const _$AggregatedHealthDataPointImpl(
      {required this.type,
      required this.value,
      required this.unit,
      required this.dateFrom,
      required this.dateTo,
      final String? $type})
      : $type = $type ?? 'aggregated';

  factory _$AggregatedHealthDataPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$AggregatedHealthDataPointImplFromJson(json);

  @override
  final String type;
  @override
  final double value;
  @override
  final String unit;
  @override
  final String dateFrom;
  @override
  final String dateTo;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'AppHealthDataPoint.aggregated(type: $type, value: $value, unit: $unit, dateFrom: $dateFrom, dateTo: $dateTo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AggregatedHealthDataPointImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.dateFrom, dateFrom) ||
                other.dateFrom == dateFrom) &&
            (identical(other.dateTo, dateTo) || other.dateTo == dateTo));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, type, value, unit, dateFrom, dateTo);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AggregatedHealthDataPointImplCopyWith<_$AggregatedHealthDataPointImpl>
      get copyWith => __$$AggregatedHealthDataPointImplCopyWithImpl<
          _$AggregatedHealthDataPointImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String type, dynamic value, String unit,
            String dateFrom, String dateTo)
        raw,
    required TResult Function(String type, double value, String unit,
            String dateFrom, String dateTo)
        aggregated,
  }) {
    return aggregated(type, value, unit, dateFrom, dateTo);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String type, dynamic value, String unit, String dateFrom,
            String dateTo)?
        raw,
    TResult? Function(String type, double value, String unit, String dateFrom,
            String dateTo)?
        aggregated,
  }) {
    return aggregated?.call(type, value, unit, dateFrom, dateTo);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String type, dynamic value, String unit, String dateFrom,
            String dateTo)?
        raw,
    TResult Function(String type, double value, String unit, String dateFrom,
            String dateTo)?
        aggregated,
    required TResult orElse(),
  }) {
    if (aggregated != null) {
      return aggregated(type, value, unit, dateFrom, dateTo);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SimpleHealthDataPoint value) raw,
    required TResult Function(AggregatedHealthDataPoint value) aggregated,
  }) {
    return aggregated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SimpleHealthDataPoint value)? raw,
    TResult? Function(AggregatedHealthDataPoint value)? aggregated,
  }) {
    return aggregated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SimpleHealthDataPoint value)? raw,
    TResult Function(AggregatedHealthDataPoint value)? aggregated,
    required TResult orElse(),
  }) {
    if (aggregated != null) {
      return aggregated(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AggregatedHealthDataPointImplToJson(
      this,
    );
  }
}

abstract class AggregatedHealthDataPoint implements AppHealthDataPoint {
  const factory AggregatedHealthDataPoint(
      {required final String type,
      required final double value,
      required final String unit,
      required final String dateFrom,
      required final String dateTo}) = _$AggregatedHealthDataPointImpl;

  factory AggregatedHealthDataPoint.fromJson(Map<String, dynamic> json) =
      _$AggregatedHealthDataPointImpl.fromJson;

  @override
  String get type;
  @override
  double get value;
  @override
  String get unit;
  @override
  String get dateFrom;
  @override
  String get dateTo;
  @override
  @JsonKey(ignore: true)
  _$$AggregatedHealthDataPointImplCopyWith<_$AggregatedHealthDataPointImpl>
      get copyWith => throw _privateConstructorUsedError;
}
