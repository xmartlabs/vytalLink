import 'package:freezed_annotation/freezed_annotation.dart';

part 'mcp_transport_event.freezed.dart';

@freezed
class McpTransportEvent with _$McpTransportEvent {
  const factory McpTransportEvent.connecting() = _Connecting;

  const factory McpTransportEvent.connected() = _Connected;

  const factory McpTransportEvent.disconnected({
    String? errorMessage,
    @Default(false) bool lostConnection,
  }) = _Disconnected;
}
