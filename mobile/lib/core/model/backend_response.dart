import 'package:freezed_annotation/freezed_annotation.dart';

part 'backend_response.freezed.dart';
part 'backend_response.g.dart';

@Freezed(unionKey: 'type')
sealed class BackendResponse with _$BackendResponse {
  @FreezedUnionValue('health_data_response')
  const factory BackendResponse.healthDataResponse({
    required String id,
    @JsonKey(name: 'health_data') required Map<String, dynamic> data,
  }) = HealthDataBackendResponse;

  @FreezedUnionValue('generic')
  const factory BackendResponse.generic({
    String? id,
    Map<String, dynamic>? data,
  }) = GenericBackendResponse;

  factory BackendResponse.fromJson(Map<String, dynamic> json) =>
      _$BackendResponseFromJson(json);
}
