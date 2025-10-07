// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_summary_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WorkoutSummaryData _$WorkoutSummaryDataFromJson(Map<String, dynamic> json) {
  return _WorkoutSummaryData.fromJson(json);
}

/// @nodoc
mixin _$WorkoutSummaryData {
  String get workoutType => throw _privateConstructorUsedError;
  double get totalDistance => throw _privateConstructorUsedError;
  double get totalEnergyBurned => throw _privateConstructorUsedError;
  double get totalSteps => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WorkoutSummaryDataCopyWith<WorkoutSummaryData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutSummaryDataCopyWith<$Res> {
  factory $WorkoutSummaryDataCopyWith(
          WorkoutSummaryData value, $Res Function(WorkoutSummaryData) then) =
      _$WorkoutSummaryDataCopyWithImpl<$Res, WorkoutSummaryData>;
  @useResult
  $Res call(
      {String workoutType,
      double totalDistance,
      double totalEnergyBurned,
      double totalSteps});
}

/// @nodoc
class _$WorkoutSummaryDataCopyWithImpl<$Res, $Val extends WorkoutSummaryData>
    implements $WorkoutSummaryDataCopyWith<$Res> {
  _$WorkoutSummaryDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workoutType = null,
    Object? totalDistance = null,
    Object? totalEnergyBurned = null,
    Object? totalSteps = null,
  }) {
    return _then(_value.copyWith(
      workoutType: null == workoutType
          ? _value.workoutType
          : workoutType // ignore: cast_nullable_to_non_nullable
              as String,
      totalDistance: null == totalDistance
          ? _value.totalDistance
          : totalDistance // ignore: cast_nullable_to_non_nullable
              as double,
      totalEnergyBurned: null == totalEnergyBurned
          ? _value.totalEnergyBurned
          : totalEnergyBurned // ignore: cast_nullable_to_non_nullable
              as double,
      totalSteps: null == totalSteps
          ? _value.totalSteps
          : totalSteps // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutSummaryDataImplCopyWith<$Res>
    implements $WorkoutSummaryDataCopyWith<$Res> {
  factory _$$WorkoutSummaryDataImplCopyWith(_$WorkoutSummaryDataImpl value,
          $Res Function(_$WorkoutSummaryDataImpl) then) =
      __$$WorkoutSummaryDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String workoutType,
      double totalDistance,
      double totalEnergyBurned,
      double totalSteps});
}

/// @nodoc
class __$$WorkoutSummaryDataImplCopyWithImpl<$Res>
    extends _$WorkoutSummaryDataCopyWithImpl<$Res, _$WorkoutSummaryDataImpl>
    implements _$$WorkoutSummaryDataImplCopyWith<$Res> {
  __$$WorkoutSummaryDataImplCopyWithImpl(_$WorkoutSummaryDataImpl _value,
      $Res Function(_$WorkoutSummaryDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workoutType = null,
    Object? totalDistance = null,
    Object? totalEnergyBurned = null,
    Object? totalSteps = null,
  }) {
    return _then(_$WorkoutSummaryDataImpl(
      workoutType: null == workoutType
          ? _value.workoutType
          : workoutType // ignore: cast_nullable_to_non_nullable
              as String,
      totalDistance: null == totalDistance
          ? _value.totalDistance
          : totalDistance // ignore: cast_nullable_to_non_nullable
              as double,
      totalEnergyBurned: null == totalEnergyBurned
          ? _value.totalEnergyBurned
          : totalEnergyBurned // ignore: cast_nullable_to_non_nullable
              as double,
      totalSteps: null == totalSteps
          ? _value.totalSteps
          : totalSteps // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutSummaryDataImpl implements _WorkoutSummaryData {
  const _$WorkoutSummaryDataImpl(
      {this.workoutType = 'other',
      this.totalDistance = 0,
      this.totalEnergyBurned = 0,
      this.totalSteps = 0});

  factory _$WorkoutSummaryDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutSummaryDataImplFromJson(json);

  @override
  @JsonKey()
  final String workoutType;
  @override
  @JsonKey()
  final double totalDistance;
  @override
  @JsonKey()
  final double totalEnergyBurned;
  @override
  @JsonKey()
  final double totalSteps;

  @override
  String toString() {
    return 'WorkoutSummaryData(workoutType: $workoutType, totalDistance: $totalDistance, totalEnergyBurned: $totalEnergyBurned, totalSteps: $totalSteps)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutSummaryDataImpl &&
            (identical(other.workoutType, workoutType) ||
                other.workoutType == workoutType) &&
            (identical(other.totalDistance, totalDistance) ||
                other.totalDistance == totalDistance) &&
            (identical(other.totalEnergyBurned, totalEnergyBurned) ||
                other.totalEnergyBurned == totalEnergyBurned) &&
            (identical(other.totalSteps, totalSteps) ||
                other.totalSteps == totalSteps));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, workoutType, totalDistance, totalEnergyBurned, totalSteps);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutSummaryDataImplCopyWith<_$WorkoutSummaryDataImpl> get copyWith =>
      __$$WorkoutSummaryDataImplCopyWithImpl<_$WorkoutSummaryDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutSummaryDataImplToJson(
      this,
    );
  }
}

abstract class _WorkoutSummaryData implements WorkoutSummaryData {
  const factory _WorkoutSummaryData(
      {final String workoutType,
      final double totalDistance,
      final double totalEnergyBurned,
      final double totalSteps}) = _$WorkoutSummaryDataImpl;

  factory _WorkoutSummaryData.fromJson(Map<String, dynamic> json) =
      _$WorkoutSummaryDataImpl.fromJson;

  @override
  String get workoutType;
  @override
  double get totalDistance;
  @override
  double get totalEnergyBurned;
  @override
  double get totalSteps;
  @override
  @JsonKey(ignore: true)
  _$$WorkoutSummaryDataImplCopyWith<_$WorkoutSummaryDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
