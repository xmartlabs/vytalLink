// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomeState {
  McpServerStatus get status => throw _privateConstructorUsedError;
  String get ipAddress => throw _privateConstructorUsedError;
  String get endpoint => throw _privateConstructorUsedError;
  String get connectionCode => throw _privateConstructorUsedError;
  String get connectionWord => throw _privateConstructorUsedError;
  String get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HomeStateCopyWith<HomeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) then) =
      _$HomeStateCopyWithImpl<$Res, HomeState>;
  @useResult
  $Res call(
      {McpServerStatus status,
      String ipAddress,
      String endpoint,
      String connectionCode,
      String connectionWord,
      String errorMessage});
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res, $Val extends HomeState>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? ipAddress = null,
    Object? endpoint = null,
    Object? connectionCode = null,
    Object? connectionWord = null,
    Object? errorMessage = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as McpServerStatus,
      ipAddress: null == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String,
      endpoint: null == endpoint
          ? _value.endpoint
          : endpoint // ignore: cast_nullable_to_non_nullable
              as String,
      connectionCode: null == connectionCode
          ? _value.connectionCode
          : connectionCode // ignore: cast_nullable_to_non_nullable
              as String,
      connectionWord: null == connectionWord
          ? _value.connectionWord
          : connectionWord // ignore: cast_nullable_to_non_nullable
              as String,
      errorMessage: null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomeStateImplCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory _$$HomeStateImplCopyWith(
          _$HomeStateImpl value, $Res Function(_$HomeStateImpl) then) =
      __$$HomeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {McpServerStatus status,
      String ipAddress,
      String endpoint,
      String connectionCode,
      String connectionWord,
      String errorMessage});
}

/// @nodoc
class __$$HomeStateImplCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeStateImpl>
    implements _$$HomeStateImplCopyWith<$Res> {
  __$$HomeStateImplCopyWithImpl(
      _$HomeStateImpl _value, $Res Function(_$HomeStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? ipAddress = null,
    Object? endpoint = null,
    Object? connectionCode = null,
    Object? connectionWord = null,
    Object? errorMessage = null,
  }) {
    return _then(_$HomeStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as McpServerStatus,
      ipAddress: null == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String,
      endpoint: null == endpoint
          ? _value.endpoint
          : endpoint // ignore: cast_nullable_to_non_nullable
              as String,
      connectionCode: null == connectionCode
          ? _value.connectionCode
          : connectionCode // ignore: cast_nullable_to_non_nullable
              as String,
      connectionWord: null == connectionWord
          ? _value.connectionWord
          : connectionWord // ignore: cast_nullable_to_non_nullable
              as String,
      errorMessage: null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$HomeStateImpl implements _HomeState {
  const _$HomeStateImpl(
      {this.status = McpServerStatus.idle,
      this.ipAddress = "",
      this.endpoint = "",
      this.connectionCode = "",
      this.connectionWord = "",
      this.errorMessage = ""});

  @override
  @JsonKey()
  final McpServerStatus status;
  @override
  @JsonKey()
  final String ipAddress;
  @override
  @JsonKey()
  final String endpoint;
  @override
  @JsonKey()
  final String connectionCode;
  @override
  @JsonKey()
  final String connectionWord;
  @override
  @JsonKey()
  final String errorMessage;

  @override
  String toString() {
    return 'HomeState(status: $status, ipAddress: $ipAddress, endpoint: $endpoint, connectionCode: $connectionCode, connectionWord: $connectionWord, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.endpoint, endpoint) ||
                other.endpoint == endpoint) &&
            (identical(other.connectionCode, connectionCode) ||
                other.connectionCode == connectionCode) &&
            (identical(other.connectionWord, connectionWord) ||
                other.connectionWord == connectionWord) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, ipAddress, endpoint,
      connectionCode, connectionWord, errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      __$$HomeStateImplCopyWithImpl<_$HomeStateImpl>(this, _$identity);
}

abstract class _HomeState implements HomeState {
  const factory _HomeState(
      {final McpServerStatus status,
      final String ipAddress,
      final String endpoint,
      final String connectionCode,
      final String connectionWord,
      final String errorMessage}) = _$HomeStateImpl;

  @override
  McpServerStatus get status;
  @override
  String get ipAddress;
  @override
  String get endpoint;
  @override
  String get connectionCode;
  @override
  String get connectionWord;
  @override
  String get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
