import 'package:auto_route/auto_route.dart';
import 'package:flutter_template/core/service/shared_preference_service.dart';
import 'package:flutter_template/ui/router/app_router.dart';

class OnboardingGuard extends AutoRouteGuard {
  final SharedPreferenceService _sharedPreferenceService;

  OnboardingGuard(this._sharedPreferenceService);

  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    if (await _sharedPreferenceService.isOnboardingCompleted()) {
      resolver.next(true);
    } else {
      await router.navigate(const OnboardingRoute());
    }
  }
}
