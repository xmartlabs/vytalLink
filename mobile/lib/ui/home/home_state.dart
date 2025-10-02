part of 'home_cubit.dart';

enum McpServerStatus { idle, starting, running, stopping, error }

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(McpServerStatus.idle) McpServerStatus status,
    @Default("") String connectionCode,
    @Default("") String connectionWord,
    @Default("") String errorMessage,
  }) = _HomeState;
}
