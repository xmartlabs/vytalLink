import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/core/di/di_provider.dart';
import 'package:flutter_template/core/service/shared_preference_service.dart';
import 'package:flutter_template/ui/router/app_router.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_cubit.freezed.dart';
part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final SharedPreferenceService _sharedPreferenceService = DiProvider.get();
  final AppRouter _router = DiProvider.get();

  OnboardingCubit() : super(const OnboardingState());

  void setCurrentPage(int page) {
    emit(state.copyWith(currentPage: page));
  }

  Future<void> completeOnboarding() async {
    await _sharedPreferenceService.setOnboardingCompleted(true);
    await _router.replace(const AuthenticatedSectionRoute());
  }
}
