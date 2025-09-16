// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backend_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BackendMessage _$BackendMessageFromJson(Map<String, dynamic> json) {
  switch (json['type']) {
    case 'health_data_request':
      return HealthDataRequestMessage.fromJson(json);
    case 'connection_code':
      return ConnectionCodeMessage.fromJson(json);
    case 'unknown':
      return UnknownMessage.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'type', 'BackendMessage',
          'Invalid union type "${json['type']}"!');
  }
}

/// @nodoc
mixin _$BackendMessage {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(@JsonKey(name: 'request_id') String id,
            Map<String, dynamic> payload)
        healthDataRequest,
    required TResult Function(String code, String word, String message)
        connectionCode,
    required TResult Function(Map<String, dynamic> data) unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(@JsonKey(name: 'request_id') String id,
            Map<String, dynamic> payload)?
        healthDataRequest,
    TResult? Function(String code, String word, String message)? connectionCode,
    TResult? Function(Map<String, dynamic> data)? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(@JsonKey(name: 'request_id') String id,
            Map<String, dynamic> payload)?
        healthDataRequest,
    TResult Function(String code, String word, String message)? connectionCode,
    TResult Function(Map<String, dynamic> data)? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HealthDataRequestMessage value) healthDataRequest,
    required TResult Function(ConnectionCodeMessage value) connectionCode,
    required TResult Function(UnknownMessage value) unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HealthDataRequestMessage value)? healthDataRequest,
    TResult? Function(ConnectionCodeMessage value)? connectionCode,
    TResult? Function(UnknownMessage value)? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HealthDataRequestMessage value)? healthDataRequest,
    TResult Function(ConnectionCodeMessage value)? connectionCode,
    TResult Function(UnknownMessage value)? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BackendMessageCopyWith<$Res> {
  factory $BackendMessageCopyWith(
          BackendMessage value, $Res Function(BackendMessage) then) =
      _$BackendMessageCopyWithImpl<$Res, BackendMessage>;
}

/// @nodoc
class _$BackendMessageCopyWithImpl<$Res, $Val extends BackendMessage>
    implements $BackendMessageCopyWith<$Res> {
  _$BackendMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$HealthDataRequestMessageImplCopyWith<$Res> {
  factory _$$HealthDataRequestMessageImplCopyWith(
          _$HealthDataRequestMessageImpl value,
          $Res Function(_$HealthDataRequestMessageImpl) then) =
      __$$HealthDataRequestMessageImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {@JsonKey(name: 'request_id') String id, Map<String, dynamic> payload});
}

/// @nodoc
class __$$HealthDataRequestMessageImplCopyWithImpl<$Res>
    extends _$BackendMessageCopyWithImpl<$Res, _$HealthDataRequestMessageImpl>
    implements _$$HealthDataRequestMessageImplCopyWith<$Res> {
  __$$HealthDataRequestMessageImplCopyWithImpl(
      _$HealthDataRequestMessageImpl _value,
      $Res Function(_$HealthDataRequestMessageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? payload = null,
  }) {
    return _then(_$HealthDataRequestMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      payload: null == payload
          ? _value._payload
          : payload // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HealthDataRequestMessageImpl extends HealthDataRequestMessage {
  const _$HealthDataRequestMessageImpl(
      {@JsonKey(name: 'request_id') required this.id,
      required final Map<String, dynamic> payload,
      final String? $type})
      : _payload = payload,
        $type = $type ?? 'health_data_request',
        super._();

  factory _$HealthDataRequestMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$HealthDataRequestMessageImplFromJson(json);

  @override
  @JsonKey(name: 'request_id')
  final String id;
  final Map<String, dynamic> _payload;
  @override
  Map<String, dynamic> get payload {
    if (_payload is EqualUnmodifiableMapView) return _payload;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_payload);
  }

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'BackendMessage.healthDataRequest(id: $id, payload: $payload)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthDataRequestMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._payload, _payload));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, const DeepCollectionEquality().hash(_payload));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthDataRequestMessageImplCopyWith<_$HealthDataRequestMessageImpl>
      get copyWith => __$$HealthDataRequestMessageImplCopyWithImpl<
          _$HealthDataRequestMessageImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(@JsonKey(name: 'request_id') String id,
            Map<String, dynamic> payload)
        healthDataRequest,
    required TResult Function(String code, String word, String message)
        connectionCode,
    required TResult Function(Map<String, dynamic> data) unknown,
  }) {
    return healthDataRequest(id, payload);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(@JsonKey(name: 'request_id') String id,
            Map<String, dynamic> payload)?
        healthDataRequest,
    TResult? Function(String code, String word, String message)? connectionCode,
    TResult? Function(Map<String, dynamic> data)? unknown,
  }) {
    return healthDataRequest?.call(id, payload);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(@JsonKey(name: 'request_id') String id,
            Map<String, dynamic> payload)?
        healthDataRequest,
    TResult Function(String code, String word, String message)? connectionCode,
    TResult Function(Map<String, dynamic> data)? unknown,
    required TResult orElse(),
  }) {
    if (healthDataRequest != null) {
      return healthDataRequest(id, payload);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HealthDataRequestMessage value) healthDataRequest,
    required TResult Function(ConnectionCodeMessage value) connectionCode,
    required TResult Function(UnknownMessage value) unknown,
  }) {
    return healthDataRequest(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HealthDataRequestMessage value)? healthDataRequest,
    TResult? Function(ConnectionCodeMessage value)? connectionCode,
    TResult? Function(UnknownMessage value)? unknown,
  }) {
    return healthDataRequest?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HealthDataRequestMessage value)? healthDataRequest,
    TResult Function(ConnectionCodeMessage value)? connectionCode,
    TResult Function(UnknownMessage value)? unknown,
    required TResult orElse(),
  }) {
    if (healthDataRequest != null) {
      return healthDataRequest(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$HealthDataRequestMessageImplToJson(
      this,
    );
  }
}

abstract class HealthDataRequestMessage extends BackendMessage {
  const factory HealthDataRequestMessage(
          {@JsonKey(name: 'request_id') required final String id,
          required final Map<String, dynamic> payload}) =
      _$HealthDataRequestMessageImpl;
  const HealthDataRequestMessage._() : super._();

  factory HealthDataRequestMessage.fromJson(Map<String, dynamic> json) =
      _$HealthDataRequestMessageImpl.fromJson;

  @JsonKey(name: 'request_id')
  String get id;
  Map<String, dynamic> get payload;
  @JsonKey(ignore: true)
  _$$HealthDataRequestMessageImplCopyWith<_$HealthDataRequestMessageImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ConnectionCodeMessageImplCopyWith<$Res> {
  factory _$$ConnectionCodeMessageImplCopyWith(
          _$ConnectionCodeMessageImpl value,
          $Res Function(_$ConnectionCodeMessageImpl) then) =
      __$$ConnectionCodeMessageImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String code, String word, String message});
}

/// @nodoc
class __$$ConnectionCodeMessageImplCopyWithImpl<$Res>
    extends _$BackendMessageCopyWithImpl<$Res, _$ConnectionCodeMessageImpl>
    implements _$$ConnectionCodeMessageImplCopyWith<$Res> {
  __$$ConnectionCodeMessageImplCopyWithImpl(_$ConnectionCodeMessageImpl _value,
      $Res Function(_$ConnectionCodeMessageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? word = null,
    Object? message = null,
  }) {
    return _then(_$ConnectionCodeMessageImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      word: null == word
          ? _value.word
          : word // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConnectionCodeMessageImpl extends ConnectionCodeMessage {
  const _$ConnectionCodeMessageImpl(
      {required this.code,
      required this.word,
      required this.message,
      final String? $type})
      : $type = $type ?? 'connection_code',
        super._();

  factory _$ConnectionCodeMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConnectionCodeMessageImplFromJson(json);

  @override
  final String code;
  @override
  final String word;
  @override
  final String message;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'BackendMessage.connectionCode(code: $code, word: $word, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectionCodeMessageImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.word, word) || other.word == word) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, code, word, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConnectionCodeMessageImplCopyWith<_$ConnectionCodeMessageImpl>
      get copyWith => __$$ConnectionCodeMessageImplCopyWithImpl<
          _$ConnectionCodeMessageImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(@JsonKey(name: 'request_id') String id,
            Map<String, dynamic> payload)
        healthDataRequest,
    required TResult Function(String code, String word, String message)
        connectionCode,
    required TResult Function(Map<String, dynamic> data) unknown,
  }) {
    return connectionCode(code, word, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(@JsonKey(name: 'request_id') String id,
            Map<String, dynamic> payload)?
        healthDataRequest,
    TResult? Function(String code, String word, String message)? connectionCode,
    TResult? Function(Map<String, dynamic> data)? unknown,
  }) {
    return connectionCode?.call(code, word, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(@JsonKey(name: 'request_id') String id,
            Map<String, dynamic> payload)?
        healthDataRequest,
    TResult Function(String code, String word, String message)? connectionCode,
    TResult Function(Map<String, dynamic> data)? unknown,
    required TResult orElse(),
  }) {
    if (connectionCode != null) {
      return connectionCode(code, word, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HealthDataRequestMessage value) healthDataRequest,
    required TResult Function(ConnectionCodeMessage value) connectionCode,
    required TResult Function(UnknownMessage value) unknown,
  }) {
    return connectionCode(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HealthDataRequestMessage value)? healthDataRequest,
    TResult? Function(ConnectionCodeMessage value)? connectionCode,
    TResult? Function(UnknownMessage value)? unknown,
  }) {
    return connectionCode?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HealthDataRequestMessage value)? healthDataRequest,
    TResult Function(ConnectionCodeMessage value)? connectionCode,
    TResult Function(UnknownMessage value)? unknown,
    required TResult orElse(),
  }) {
    if (connectionCode != null) {
      return connectionCode(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ConnectionCodeMessageImplToJson(
      this,
    );
  }
}

abstract class ConnectionCodeMessage extends BackendMessage {
  const factory ConnectionCodeMessage(
      {required final String code,
      required final String word,
      required final String message}) = _$ConnectionCodeMessageImpl;
  const ConnectionCodeMessage._() : super._();

  factory ConnectionCodeMessage.fromJson(Map<String, dynamic> json) =
      _$ConnectionCodeMessageImpl.fromJson;

  String get code;
  String get word;
  String get message;
  @JsonKey(ignore: true)
  _$$ConnectionCodeMessageImplCopyWith<_$ConnectionCodeMessageImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnknownMessageImplCopyWith<$Res> {
  factory _$$UnknownMessageImplCopyWith(_$UnknownMessageImpl value,
          $Res Function(_$UnknownMessageImpl) then) =
      __$$UnknownMessageImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Map<String, dynamic> data});
}

/// @nodoc
class __$$UnknownMessageImplCopyWithImpl<$Res>
    extends _$BackendMessageCopyWithImpl<$Res, _$UnknownMessageImpl>
    implements _$$UnknownMessageImplCopyWith<$Res> {
  __$$UnknownMessageImplCopyWithImpl(
      _$UnknownMessageImpl _value, $Res Function(_$UnknownMessageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$UnknownMessageImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UnknownMessageImpl extends UnknownMessage {
  const _$UnknownMessageImpl(
      {required final Map<String, dynamic> data, final String? $type})
      : _data = data,
        $type = $type ?? 'unknown',
        super._();

  factory _$UnknownMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$UnknownMessageImplFromJson(json);

  final Map<String, dynamic> _data;
  @override
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'BackendMessage.unknown(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnknownMessageImpl &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UnknownMessageImplCopyWith<_$UnknownMessageImpl> get copyWith =>
      __$$UnknownMessageImplCopyWithImpl<_$UnknownMessageImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(@JsonKey(name: 'request_id') String id,
            Map<String, dynamic> payload)
        healthDataRequest,
    required TResult Function(String code, String word, String message)
        connectionCode,
    required TResult Function(Map<String, dynamic> data) unknown,
  }) {
    return unknown(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(@JsonKey(name: 'request_id') String id,
            Map<String, dynamic> payload)?
        healthDataRequest,
    TResult? Function(String code, String word, String message)? connectionCode,
    TResult? Function(Map<String, dynamic> data)? unknown,
  }) {
    return unknown?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(@JsonKey(name: 'request_id') String id,
            Map<String, dynamic> payload)?
        healthDataRequest,
    TResult Function(String code, String word, String message)? connectionCode,
    TResult Function(Map<String, dynamic> data)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HealthDataRequestMessage value) healthDataRequest,
    required TResult Function(ConnectionCodeMessage value) connectionCode,
    required TResult Function(UnknownMessage value) unknown,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HealthDataRequestMessage value)? healthDataRequest,
    TResult? Function(ConnectionCodeMessage value)? connectionCode,
    TResult? Function(UnknownMessage value)? unknown,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HealthDataRequestMessage value)? healthDataRequest,
    TResult Function(ConnectionCodeMessage value)? connectionCode,
    TResult Function(UnknownMessage value)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$UnknownMessageImplToJson(
      this,
    );
  }
}

abstract class UnknownMessage extends BackendMessage {
  const factory UnknownMessage({required final Map<String, dynamic> data}) =
      _$UnknownMessageImpl;
  const UnknownMessage._() : super._();

  factory UnknownMessage.fromJson(Map<String, dynamic> json) =
      _$UnknownMessageImpl.fromJson;

  Map<String, dynamic> get data;
  @JsonKey(ignore: true)
  _$$UnknownMessageImplCopyWith<_$UnknownMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
