part of 'home_cubit.dart';

enum McpServerStatus { idle, starting, running, stopping, error }

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(McpServerStatus.idle) McpServerStatus status,
    BridgeCredentials? bridgeCredentials,
    String? errorMessage,
  }) = _HomeState;
}

extension HomeStateCredentialsX on HomeState {
  bool get isRunning =>
      status == McpServerStatus.running && bridgeCredentials != null;
}
