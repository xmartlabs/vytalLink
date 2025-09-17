import 'package:freezed_annotation/freezed_annotation.dart';

part 'backend_message.freezed.dart';
part 'backend_message.g.dart';

@Freezed(unionKey: 'type')
sealed class BackendMessage with _$BackendMessage {
  const BackendMessage._();

  @FreezedUnionValue('health_data_request')
  const factory BackendMessage.healthDataRequest({
    @JsonKey(name: 'request_id') required String id,
    required Map<String, dynamic> payload,
  }) = HealthDataRequestMessage;

  @FreezedUnionValue('connection_code')
  const factory BackendMessage.connectionCode({
    required String code,
    required String word,
    required String message,
  }) = ConnectionCodeMessage;

  @FreezedUnionValue('unknown')
  const factory BackendMessage.unknown({
    required Map<String, dynamic> data,
  }) = UnknownMessage;

  factory BackendMessage.fromJson(Map<String, dynamic> json) =>
      _$BackendMessageFromJson(json);
}
