// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backend_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BackendResponse _$BackendResponseFromJson(Map<String, dynamic> json) {
  switch (json['type']) {
    case 'health_data_response':
      return HealthDataBackendResponse.fromJson(json);
    case 'generic':
      return GenericBackendResponse.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'type', 'BackendResponse',
          'Invalid union type "${json['type']}"!');
  }
}

/// @nodoc
mixin _$BackendResponse {
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'health_data')
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id, @JsonKey(name: 'health_data') Map<String, dynamic> data)
        healthDataResponse,
    required TResult Function(String? id, Map<String, dynamic>? data) generic,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id, @JsonKey(name: 'health_data') Map<String, dynamic> data)?
        healthDataResponse,
    TResult? Function(String? id, Map<String, dynamic>? data)? generic,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id, @JsonKey(name: 'health_data') Map<String, dynamic> data)?
        healthDataResponse,
    TResult Function(String? id, Map<String, dynamic>? data)? generic,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HealthDataBackendResponse value)
        healthDataResponse,
    required TResult Function(GenericBackendResponse value) generic,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HealthDataBackendResponse value)? healthDataResponse,
    TResult? Function(GenericBackendResponse value)? generic,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HealthDataBackendResponse value)? healthDataResponse,
    TResult Function(GenericBackendResponse value)? generic,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BackendResponseCopyWith<BackendResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BackendResponseCopyWith<$Res> {
  factory $BackendResponseCopyWith(
          BackendResponse value, $Res Function(BackendResponse) then) =
      _$BackendResponseCopyWithImpl<$Res, BackendResponse>;
  @useResult
  $Res call(
      {String id, @JsonKey(name: 'health_data') Map<String, dynamic> data});
}

/// @nodoc
class _$BackendResponseCopyWithImpl<$Res, $Val extends BackendResponse>
    implements $BackendResponseCopyWith<$Res> {
  _$BackendResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id!
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data!
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HealthDataBackendResponseImplCopyWith<$Res>
    implements $BackendResponseCopyWith<$Res> {
  factory _$$HealthDataBackendResponseImplCopyWith(
          _$HealthDataBackendResponseImpl value,
          $Res Function(_$HealthDataBackendResponseImpl) then) =
      __$$HealthDataBackendResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, @JsonKey(name: 'health_data') Map<String, dynamic> data});
}

/// @nodoc
class __$$HealthDataBackendResponseImplCopyWithImpl<$Res>
    extends _$BackendResponseCopyWithImpl<$Res, _$HealthDataBackendResponseImpl>
    implements _$$HealthDataBackendResponseImplCopyWith<$Res> {
  __$$HealthDataBackendResponseImplCopyWithImpl(
      _$HealthDataBackendResponseImpl _value,
      $Res Function(_$HealthDataBackendResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? data = null,
  }) {
    return _then(_$HealthDataBackendResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HealthDataBackendResponseImpl implements HealthDataBackendResponse {
  const _$HealthDataBackendResponseImpl(
      {required this.id,
      @JsonKey(name: 'health_data') required final Map<String, dynamic> data,
      final String? $type})
      : _data = data,
        $type = $type ?? 'health_data_response';

  factory _$HealthDataBackendResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$HealthDataBackendResponseImplFromJson(json);

  @override
  final String id;
  final Map<String, dynamic> _data;
  @override
  @JsonKey(name: 'health_data')
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'BackendResponse.healthDataResponse(id: $id, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthDataBackendResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, const DeepCollectionEquality().hash(_data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthDataBackendResponseImplCopyWith<_$HealthDataBackendResponseImpl>
      get copyWith => __$$HealthDataBackendResponseImplCopyWithImpl<
          _$HealthDataBackendResponseImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id, @JsonKey(name: 'health_data') Map<String, dynamic> data)
        healthDataResponse,
    required TResult Function(String? id, Map<String, dynamic>? data) generic,
  }) {
    return healthDataResponse(id, data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id, @JsonKey(name: 'health_data') Map<String, dynamic> data)?
        healthDataResponse,
    TResult? Function(String? id, Map<String, dynamic>? data)? generic,
  }) {
    return healthDataResponse?.call(id, data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id, @JsonKey(name: 'health_data') Map<String, dynamic> data)?
        healthDataResponse,
    TResult Function(String? id, Map<String, dynamic>? data)? generic,
    required TResult orElse(),
  }) {
    if (healthDataResponse != null) {
      return healthDataResponse(id, data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HealthDataBackendResponse value)
        healthDataResponse,
    required TResult Function(GenericBackendResponse value) generic,
  }) {
    return healthDataResponse(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HealthDataBackendResponse value)? healthDataResponse,
    TResult? Function(GenericBackendResponse value)? generic,
  }) {
    return healthDataResponse?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HealthDataBackendResponse value)? healthDataResponse,
    TResult Function(GenericBackendResponse value)? generic,
    required TResult orElse(),
  }) {
    if (healthDataResponse != null) {
      return healthDataResponse(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$HealthDataBackendResponseImplToJson(
      this,
    );
  }
}

abstract class HealthDataBackendResponse implements BackendResponse {
  const factory HealthDataBackendResponse(
          {required final String id,
          @JsonKey(name: 'health_data')
          required final Map<String, dynamic> data}) =
      _$HealthDataBackendResponseImpl;

  factory HealthDataBackendResponse.fromJson(Map<String, dynamic> json) =
      _$HealthDataBackendResponseImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'health_data')
  Map<String, dynamic> get data;
  @override
  @JsonKey(ignore: true)
  _$$HealthDataBackendResponseImplCopyWith<_$HealthDataBackendResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GenericBackendResponseImplCopyWith<$Res>
    implements $BackendResponseCopyWith<$Res> {
  factory _$$GenericBackendResponseImplCopyWith(
          _$GenericBackendResponseImpl value,
          $Res Function(_$GenericBackendResponseImpl) then) =
      __$$GenericBackendResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? id, Map<String, dynamic>? data});
}

/// @nodoc
class __$$GenericBackendResponseImplCopyWithImpl<$Res>
    extends _$BackendResponseCopyWithImpl<$Res, _$GenericBackendResponseImpl>
    implements _$$GenericBackendResponseImplCopyWith<$Res> {
  __$$GenericBackendResponseImplCopyWithImpl(
      _$GenericBackendResponseImpl _value,
      $Res Function(_$GenericBackendResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? data = freezed,
  }) {
    return _then(_$GenericBackendResponseImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GenericBackendResponseImpl implements GenericBackendResponse {
  const _$GenericBackendResponseImpl(
      {this.id, final Map<String, dynamic>? data, final String? $type})
      : _data = data,
        $type = $type ?? 'generic';

  factory _$GenericBackendResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GenericBackendResponseImplFromJson(json);

  @override
  final String? id;
  final Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'BackendResponse.generic(id: $id, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GenericBackendResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, const DeepCollectionEquality().hash(_data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GenericBackendResponseImplCopyWith<_$GenericBackendResponseImpl>
      get copyWith => __$$GenericBackendResponseImplCopyWithImpl<
          _$GenericBackendResponseImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id, @JsonKey(name: 'health_data') Map<String, dynamic> data)
        healthDataResponse,
    required TResult Function(String? id, Map<String, dynamic>? data) generic,
  }) {
    return generic(id, data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id, @JsonKey(name: 'health_data') Map<String, dynamic> data)?
        healthDataResponse,
    TResult? Function(String? id, Map<String, dynamic>? data)? generic,
  }) {
    return generic?.call(id, data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id, @JsonKey(name: 'health_data') Map<String, dynamic> data)?
        healthDataResponse,
    TResult Function(String? id, Map<String, dynamic>? data)? generic,
    required TResult orElse(),
  }) {
    if (generic != null) {
      return generic(id, data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HealthDataBackendResponse value)
        healthDataResponse,
    required TResult Function(GenericBackendResponse value) generic,
  }) {
    return generic(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HealthDataBackendResponse value)? healthDataResponse,
    TResult? Function(GenericBackendResponse value)? generic,
  }) {
    return generic?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HealthDataBackendResponse value)? healthDataResponse,
    TResult Function(GenericBackendResponse value)? generic,
    required TResult orElse(),
  }) {
    if (generic != null) {
      return generic(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$GenericBackendResponseImplToJson(
      this,
    );
  }
}

abstract class GenericBackendResponse implements BackendResponse {
  const factory GenericBackendResponse(
      {final String? id,
      final Map<String, dynamic>? data}) = _$GenericBackendResponseImpl;

  factory GenericBackendResponse.fromJson(Map<String, dynamic> json) =
      _$GenericBackendResponseImpl.fromJson;

  @override
  String? get id;
  @override
  Map<String, dynamic>? get data;
  @override
  @JsonKey(ignore: true)
  _$$GenericBackendResponseImplCopyWith<_$GenericBackendResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
