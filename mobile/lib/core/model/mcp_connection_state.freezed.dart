// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mcp_connection_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$McpConnectionState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() connecting,
    required TResult Function(
            ({String connectionPin, String connectionWord}) credentials,
            String message)
        connected,
    required TResult Function(String? errorMessage, bool lostConnection)
        disconnected,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? connecting,
    TResult? Function(
            ({String connectionPin, String connectionWord}) credentials,
            String message)?
        connected,
    TResult? Function(String? errorMessage, bool lostConnection)? disconnected,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? connecting,
    TResult Function(
            ({String connectionPin, String connectionWord}) credentials,
            String message)?
        connected,
    TResult Function(String? errorMessage, bool lostConnection)? disconnected,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(McpConnectionStateConnecting value) connecting,
    required TResult Function(McpConnectionStateConnected value) connected,
    required TResult Function(McpConnectionStateDisconnected value)
        disconnected,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(McpConnectionStateConnecting value)? connecting,
    TResult? Function(McpConnectionStateConnected value)? connected,
    TResult? Function(McpConnectionStateDisconnected value)? disconnected,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(McpConnectionStateConnecting value)? connecting,
    TResult Function(McpConnectionStateConnected value)? connected,
    TResult Function(McpConnectionStateDisconnected value)? disconnected,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $McpConnectionStateCopyWith<$Res> {
  factory $McpConnectionStateCopyWith(
          McpConnectionState value, $Res Function(McpConnectionState) then) =
      _$McpConnectionStateCopyWithImpl<$Res, McpConnectionState>;
}

/// @nodoc
class _$McpConnectionStateCopyWithImpl<$Res, $Val extends McpConnectionState>
    implements $McpConnectionStateCopyWith<$Res> {
  _$McpConnectionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$McpConnectionStateConnectingImplCopyWith<$Res> {
  factory _$$McpConnectionStateConnectingImplCopyWith(
          _$McpConnectionStateConnectingImpl value,
          $Res Function(_$McpConnectionStateConnectingImpl) then) =
      __$$McpConnectionStateConnectingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$McpConnectionStateConnectingImplCopyWithImpl<$Res>
    extends _$McpConnectionStateCopyWithImpl<$Res,
        _$McpConnectionStateConnectingImpl>
    implements _$$McpConnectionStateConnectingImplCopyWith<$Res> {
  __$$McpConnectionStateConnectingImplCopyWithImpl(
      _$McpConnectionStateConnectingImpl _value,
      $Res Function(_$McpConnectionStateConnectingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$McpConnectionStateConnectingImpl
    implements McpConnectionStateConnecting {
  const _$McpConnectionStateConnectingImpl();

  @override
  String toString() {
    return 'McpConnectionState.connecting()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$McpConnectionStateConnectingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() connecting,
    required TResult Function(
            ({String connectionPin, String connectionWord}) credentials,
            String message)
        connected,
    required TResult Function(String? errorMessage, bool lostConnection)
        disconnected,
  }) {
    return connecting();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? connecting,
    TResult? Function(
            ({String connectionPin, String connectionWord}) credentials,
            String message)?
        connected,
    TResult? Function(String? errorMessage, bool lostConnection)? disconnected,
  }) {
    return connecting?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? connecting,
    TResult Function(
            ({String connectionPin, String connectionWord}) credentials,
            String message)?
        connected,
    TResult Function(String? errorMessage, bool lostConnection)? disconnected,
    required TResult orElse(),
  }) {
    if (connecting != null) {
      return connecting();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(McpConnectionStateConnecting value) connecting,
    required TResult Function(McpConnectionStateConnected value) connected,
    required TResult Function(McpConnectionStateDisconnected value)
        disconnected,
  }) {
    return connecting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(McpConnectionStateConnecting value)? connecting,
    TResult? Function(McpConnectionStateConnected value)? connected,
    TResult? Function(McpConnectionStateDisconnected value)? disconnected,
  }) {
    return connecting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(McpConnectionStateConnecting value)? connecting,
    TResult Function(McpConnectionStateConnected value)? connected,
    TResult Function(McpConnectionStateDisconnected value)? disconnected,
    required TResult orElse(),
  }) {
    if (connecting != null) {
      return connecting(this);
    }
    return orElse();
  }
}

abstract class McpConnectionStateConnecting implements McpConnectionState {
  const factory McpConnectionStateConnecting() =
      _$McpConnectionStateConnectingImpl;
}

/// @nodoc
abstract class _$$McpConnectionStateConnectedImplCopyWith<$Res> {
  factory _$$McpConnectionStateConnectedImplCopyWith(
          _$McpConnectionStateConnectedImpl value,
          $Res Function(_$McpConnectionStateConnectedImpl) then) =
      __$$McpConnectionStateConnectedImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {({String connectionPin, String connectionWord}) credentials,
      String message});
}

/// @nodoc
class __$$McpConnectionStateConnectedImplCopyWithImpl<$Res>
    extends _$McpConnectionStateCopyWithImpl<$Res,
        _$McpConnectionStateConnectedImpl>
    implements _$$McpConnectionStateConnectedImplCopyWith<$Res> {
  __$$McpConnectionStateConnectedImplCopyWithImpl(
      _$McpConnectionStateConnectedImpl _value,
      $Res Function(_$McpConnectionStateConnectedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? credentials = null,
    Object? message = null,
  }) {
    return _then(_$McpConnectionStateConnectedImpl(
      credentials: null == credentials
          ? _value.credentials
          : credentials // ignore: cast_nullable_to_non_nullable
              as ({String connectionPin, String connectionWord}),
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$McpConnectionStateConnectedImpl implements McpConnectionStateConnected {
  const _$McpConnectionStateConnectedImpl(
      {required this.credentials, required this.message});

  @override
  final ({String connectionPin, String connectionWord}) credentials;
  @override
  final String message;

  @override
  String toString() {
    return 'McpConnectionState.connected(credentials: $credentials, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$McpConnectionStateConnectedImpl &&
            (identical(other.credentials, credentials) ||
                other.credentials == credentials) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, credentials, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$McpConnectionStateConnectedImplCopyWith<_$McpConnectionStateConnectedImpl>
      get copyWith => __$$McpConnectionStateConnectedImplCopyWithImpl<
          _$McpConnectionStateConnectedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() connecting,
    required TResult Function(
            ({String connectionPin, String connectionWord}) credentials,
            String message)
        connected,
    required TResult Function(String? errorMessage, bool lostConnection)
        disconnected,
  }) {
    return connected(credentials, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? connecting,
    TResult? Function(
            ({String connectionPin, String connectionWord}) credentials,
            String message)?
        connected,
    TResult? Function(String? errorMessage, bool lostConnection)? disconnected,
  }) {
    return connected?.call(credentials, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? connecting,
    TResult Function(
            ({String connectionPin, String connectionWord}) credentials,
            String message)?
        connected,
    TResult Function(String? errorMessage, bool lostConnection)? disconnected,
    required TResult orElse(),
  }) {
    if (connected != null) {
      return connected(credentials, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(McpConnectionStateConnecting value) connecting,
    required TResult Function(McpConnectionStateConnected value) connected,
    required TResult Function(McpConnectionStateDisconnected value)
        disconnected,
  }) {
    return connected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(McpConnectionStateConnecting value)? connecting,
    TResult? Function(McpConnectionStateConnected value)? connected,
    TResult? Function(McpConnectionStateDisconnected value)? disconnected,
  }) {
    return connected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(McpConnectionStateConnecting value)? connecting,
    TResult Function(McpConnectionStateConnected value)? connected,
    TResult Function(McpConnectionStateDisconnected value)? disconnected,
    required TResult orElse(),
  }) {
    if (connected != null) {
      return connected(this);
    }
    return orElse();
  }
}

abstract class McpConnectionStateConnected implements McpConnectionState {
  const factory McpConnectionStateConnected(
      {required final ({
        String connectionPin,
        String connectionWord
      }) credentials,
      required final String message}) = _$McpConnectionStateConnectedImpl;

  ({String connectionPin, String connectionWord}) get credentials;
  String get message;
  @JsonKey(ignore: true)
  _$$McpConnectionStateConnectedImplCopyWith<_$McpConnectionStateConnectedImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$McpConnectionStateDisconnectedImplCopyWith<$Res> {
  factory _$$McpConnectionStateDisconnectedImplCopyWith(
          _$McpConnectionStateDisconnectedImpl value,
          $Res Function(_$McpConnectionStateDisconnectedImpl) then) =
      __$$McpConnectionStateDisconnectedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? errorMessage, bool lostConnection});
}

/// @nodoc
class __$$McpConnectionStateDisconnectedImplCopyWithImpl<$Res>
    extends _$McpConnectionStateCopyWithImpl<$Res,
        _$McpConnectionStateDisconnectedImpl>
    implements _$$McpConnectionStateDisconnectedImplCopyWith<$Res> {
  __$$McpConnectionStateDisconnectedImplCopyWithImpl(
      _$McpConnectionStateDisconnectedImpl _value,
      $Res Function(_$McpConnectionStateDisconnectedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errorMessage = freezed,
    Object? lostConnection = null,
  }) {
    return _then(_$McpConnectionStateDisconnectedImpl(
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lostConnection: null == lostConnection
          ? _value.lostConnection
          : lostConnection // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$McpConnectionStateDisconnectedImpl
    implements McpConnectionStateDisconnected {
  const _$McpConnectionStateDisconnectedImpl(
      {this.errorMessage, this.lostConnection = false});

  @override
  final String? errorMessage;
  @override
  @JsonKey()
  final bool lostConnection;

  @override
  String toString() {
    return 'McpConnectionState.disconnected(errorMessage: $errorMessage, lostConnection: $lostConnection)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$McpConnectionStateDisconnectedImpl &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.lostConnection, lostConnection) ||
                other.lostConnection == lostConnection));
  }

  @override
  int get hashCode => Object.hash(runtimeType, errorMessage, lostConnection);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$McpConnectionStateDisconnectedImplCopyWith<
          _$McpConnectionStateDisconnectedImpl>
      get copyWith => __$$McpConnectionStateDisconnectedImplCopyWithImpl<
          _$McpConnectionStateDisconnectedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() connecting,
    required TResult Function(
            ({String connectionPin, String connectionWord}) credentials,
            String message)
        connected,
    required TResult Function(String? errorMessage, bool lostConnection)
        disconnected,
  }) {
    return disconnected(errorMessage, lostConnection);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? connecting,
    TResult? Function(
            ({String connectionPin, String connectionWord}) credentials,
            String message)?
        connected,
    TResult? Function(String? errorMessage, bool lostConnection)? disconnected,
  }) {
    return disconnected?.call(errorMessage, lostConnection);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? connecting,
    TResult Function(
            ({String connectionPin, String connectionWord}) credentials,
            String message)?
        connected,
    TResult Function(String? errorMessage, bool lostConnection)? disconnected,
    required TResult orElse(),
  }) {
    if (disconnected != null) {
      return disconnected(errorMessage, lostConnection);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(McpConnectionStateConnecting value) connecting,
    required TResult Function(McpConnectionStateConnected value) connected,
    required TResult Function(McpConnectionStateDisconnected value)
        disconnected,
  }) {
    return disconnected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(McpConnectionStateConnecting value)? connecting,
    TResult? Function(McpConnectionStateConnected value)? connected,
    TResult? Function(McpConnectionStateDisconnected value)? disconnected,
  }) {
    return disconnected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(McpConnectionStateConnecting value)? connecting,
    TResult Function(McpConnectionStateConnected value)? connected,
    TResult Function(McpConnectionStateDisconnected value)? disconnected,
    required TResult orElse(),
  }) {
    if (disconnected != null) {
      return disconnected(this);
    }
    return orElse();
  }
}

abstract class McpConnectionStateDisconnected implements McpConnectionState {
  const factory McpConnectionStateDisconnected(
      {final String? errorMessage,
      final bool lostConnection}) = _$McpConnectionStateDisconnectedImpl;

  String? get errorMessage;
  bool get lostConnection;
  @JsonKey(ignore: true)
  _$$McpConnectionStateDisconnectedImplCopyWith<
          _$McpConnectionStateDisconnectedImpl>
      get copyWith => throw _privateConstructorUsedError;
}
