import 'package:freezed_annotation/freezed_annotation.dart';

part 'mcp_connection_state.freezed.dart';

@freezed
class McpConnectionState with _$McpConnectionState {
  const factory McpConnectionState.connecting() = McpConnectionStateConnecting;

  const factory McpConnectionState.connected({
    required BridgeCredentials credentials,
    required String message,
  }) = McpConnectionStateConnected;

  const factory McpConnectionState.disconnected({
    String? errorMessage,
    @Default(false) bool lostConnection,
  }) = McpConnectionStateDisconnected;
}

typedef BridgeCredentials = ({
  String connectionWord,
  String connectionPin,
});
