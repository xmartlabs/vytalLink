// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'aggregation_parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HealthDataAggregationParameters {
  List<AppHealthDataPoint> get formattedData =>
      throw _privateConstructorUsedError;
  List<AggregatedHealthDataPoint> get aggregatedData =>
      throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  TimeGroupBy get groupBy => throw _privateConstructorUsedError;
  StatisticType get statisticType => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HealthDataAggregationParametersCopyWith<HealthDataAggregationParameters>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HealthDataAggregationParametersCopyWith<$Res> {
  factory $HealthDataAggregationParametersCopyWith(
          HealthDataAggregationParameters value,
          $Res Function(HealthDataAggregationParameters) then) =
      _$HealthDataAggregationParametersCopyWithImpl<$Res,
          HealthDataAggregationParameters>;
  @useResult
  $Res call(
      {List<AppHealthDataPoint> formattedData,
      List<AggregatedHealthDataPoint> aggregatedData,
      DateTime startTime,
      DateTime endTime,
      TimeGroupBy groupBy,
      StatisticType statisticType});
}

/// @nodoc
class _$HealthDataAggregationParametersCopyWithImpl<$Res,
        $Val extends HealthDataAggregationParameters>
    implements $HealthDataAggregationParametersCopyWith<$Res> {
  _$HealthDataAggregationParametersCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? formattedData = null,
    Object? aggregatedData = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? groupBy = null,
    Object? statisticType = null,
  }) {
    return _then(_value.copyWith(
      formattedData: null == formattedData
          ? _value.formattedData
          : formattedData // ignore: cast_nullable_to_non_nullable
              as List<AppHealthDataPoint>,
      aggregatedData: null == aggregatedData
          ? _value.aggregatedData
          : aggregatedData // ignore: cast_nullable_to_non_nullable
              as List<AggregatedHealthDataPoint>,
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
      statisticType: null == statisticType
          ? _value.statisticType
          : statisticType // ignore: cast_nullable_to_non_nullable
              as StatisticType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HealthDataAggregationParametersImplCopyWith<$Res>
    implements $HealthDataAggregationParametersCopyWith<$Res> {
  factory _$$HealthDataAggregationParametersImplCopyWith(
          _$HealthDataAggregationParametersImpl value,
          $Res Function(_$HealthDataAggregationParametersImpl) then) =
      __$$HealthDataAggregationParametersImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<AppHealthDataPoint> formattedData,
      List<AggregatedHealthDataPoint> aggregatedData,
      DateTime startTime,
      DateTime endTime,
      TimeGroupBy groupBy,
      StatisticType statisticType});
}

/// @nodoc
class __$$HealthDataAggregationParametersImplCopyWithImpl<$Res>
    extends _$HealthDataAggregationParametersCopyWithImpl<$Res,
        _$HealthDataAggregationParametersImpl>
    implements _$$HealthDataAggregationParametersImplCopyWith<$Res> {
  __$$HealthDataAggregationParametersImplCopyWithImpl(
      _$HealthDataAggregationParametersImpl _value,
      $Res Function(_$HealthDataAggregationParametersImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? formattedData = null,
    Object? aggregatedData = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? groupBy = null,
    Object? statisticType = null,
  }) {
    return _then(_$HealthDataAggregationParametersImpl(
      formattedData: null == formattedData
          ? _value._formattedData
          : formattedData // ignore: cast_nullable_to_non_nullable
              as List<AppHealthDataPoint>,
      aggregatedData: null == aggregatedData
          ? _value._aggregatedData
          : aggregatedData // ignore: cast_nullable_to_non_nullable
              as List<AggregatedHealthDataPoint>,
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
      statisticType: null == statisticType
          ? _value.statisticType
          : statisticType // ignore: cast_nullable_to_non_nullable
              as StatisticType,
    ));
  }
}

/// @nodoc

class _$HealthDataAggregationParametersImpl
    implements _HealthDataAggregationParameters {
  const _$HealthDataAggregationParametersImpl(
      {required final List<AppHealthDataPoint> formattedData,
      required final List<AggregatedHealthDataPoint> aggregatedData,
      required this.startTime,
      required this.endTime,
      required this.groupBy,
      required this.statisticType})
      : _formattedData = formattedData,
        _aggregatedData = aggregatedData;

  final List<AppHealthDataPoint> _formattedData;
  @override
  List<AppHealthDataPoint> get formattedData {
    if (_formattedData is EqualUnmodifiableListView) return _formattedData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_formattedData);
  }

  final List<AggregatedHealthDataPoint> _aggregatedData;
  @override
  List<AggregatedHealthDataPoint> get aggregatedData {
    if (_aggregatedData is EqualUnmodifiableListView) return _aggregatedData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_aggregatedData);
  }

  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final TimeGroupBy groupBy;
  @override
  final StatisticType statisticType;

  @override
  String toString() {
    return 'HealthDataAggregationParameters(formattedData: $formattedData, aggregatedData: $aggregatedData, startTime: $startTime, endTime: $endTime, groupBy: $groupBy, statisticType: $statisticType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthDataAggregationParametersImpl &&
            const DeepCollectionEquality()
                .equals(other._formattedData, _formattedData) &&
            const DeepCollectionEquality()
                .equals(other._aggregatedData, _aggregatedData) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.groupBy, groupBy) || other.groupBy == groupBy) &&
            (identical(other.statisticType, statisticType) ||
                other.statisticType == statisticType));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_formattedData),
      const DeepCollectionEquality().hash(_aggregatedData),
      startTime,
      endTime,
      groupBy,
      statisticType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthDataAggregationParametersImplCopyWith<
          _$HealthDataAggregationParametersImpl>
      get copyWith => __$$HealthDataAggregationParametersImplCopyWithImpl<
          _$HealthDataAggregationParametersImpl>(this, _$identity);
}

abstract class _HealthDataAggregationParameters
    implements HealthDataAggregationParameters {
  const factory _HealthDataAggregationParameters(
          {required final List<AppHealthDataPoint> formattedData,
          required final List<AggregatedHealthDataPoint> aggregatedData,
          required final DateTime startTime,
          required final DateTime endTime,
          required final TimeGroupBy groupBy,
          required final StatisticType statisticType}) =
      _$HealthDataAggregationParametersImpl;

  @override
  List<AppHealthDataPoint> get formattedData;
  @override
  List<AggregatedHealthDataPoint> get aggregatedData;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  TimeGroupBy get groupBy;
  @override
  StatisticType get statisticType;
  @override
  @JsonKey(ignore: true)
  _$$HealthDataAggregationParametersImplCopyWith<
          _$HealthDataAggregationParametersImpl>
      get copyWith => throw _privateConstructorUsedError;
}
