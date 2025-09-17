import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'global_event_handler_cubit.freezed.dart';
part 'global_event_handler_state.dart';

class GlobalEventHandlerCubit extends Cubit<GlobalEventHandlerState>
    implements GlobalEventHandler {
  GlobalEventHandlerCubit() : super(const GlobalEventHandlerState.idle());

  @override
  void handleError(
    Object? error, [
    StackTrace? stackTrace,
    VoidCallback? retry,
  ]) {
    if (state is GlobalEventHandlerStateError) {
      return;
    }

    final category = categorizeError(error);

    switch (category) {
      case ErrorCategory.internet:
        emit(
          const GlobalEventHandlerState.error(
            GlobalEventHandlerStateError.internetError(),
          ),
        );
        break;
      case ErrorCategory.connection:
        emit(
          GlobalEventHandlerState.error(
            GlobalEventHandlerStateError.connectionError(retry),
          ),
        );
        break;
      case ErrorCategory.server:
        emit(
          GlobalEventHandlerState.error(
            GlobalEventHandlerStateError.serverError(retry),
          ),
        );
        break;
      case ErrorCategory.unknown:
        emit(
          GlobalEventHandlerState.error(
            GlobalEventHandlerStateError.unknownError(error, retry),
          ),
        );
        break;
    }
  }

  @override
  void startLoading() => emit(const GlobalEventHandlerState.loading());

  @override
  void stopLoading() => emit(const GlobalEventHandlerState.idle());

  @override
  void clearError() => emit(const GlobalEventHandlerState.idle());
}

abstract interface class GlobalEventHandler {
  void handleError(
    Object? error, [
    StackTrace? stackTrace,
    VoidCallback? retry,
  ]);

  void startLoading();

  void stopLoading();

  void clearError();
}

//ignore: unused-code
extension GlobalEventExtension on GlobalEventHandler {
  Future<T> showLoading<T>(Future<T> action) async {
    startLoading();
    final response = await action;
    stopLoading();
    return response;
  }
}

enum ErrorCategory {
  internet,
  connection,
  server,
  unknown,
}

class CategorizedError implements Exception {
  final ErrorCategory category;
  final String message;
  final Exception? originalError;

  CategorizedError(this.category, this.message, [this.originalError]);

  @override
  String toString() => message;
}

ErrorCategory categorizeError(Object? error) {
  if (error is CategorizedError) {
    return error.category;
  }

  if (error is DioException &&
      (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout)) {
    return ErrorCategory.internet;
  }

  return ErrorCategory.unknown;
}
