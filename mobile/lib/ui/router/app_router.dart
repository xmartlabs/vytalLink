import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_template/core/service/shared_preference_service.dart';
import 'package:flutter_template/ui/ai_integration/chatgpt_integration_screen.dart';
import 'package:flutter_template/ui/ai_integration/mcp_integration_screen.dart';
import 'package:flutter_template/ui/faq/faq_screen.dart';
import 'package:flutter_template/ui/home/home_screen.dart';
import 'package:flutter_template/ui/home/screens/chatgpt_on_device_guidance_screen.dart';
import 'package:flutter_template/ui/onboarding/onboarding_screen.dart';
import 'package:flutter_template/ui/router/onboarding_guard.dart';
import 'package:flutter_template/ui/section/section_router.dart';
import 'package:flutter_template/ui/web/web_page_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Page|Screen|Router,Route',
)
class AppRouter extends _$AppRouter {
  @override
  final List<AutoRoute> routes;
  final String? initialRoute;

  AppRouter(
    SharedPreferenceService sharedPreferenceService, {
    this.initialRoute,
  }) : routes = [
          AutoRoute(page: OnboardingRoute.page),
          CustomRoute(
            page: AuthenticatedSectionRoute.page,
            path: '/',
            initial: true,
            guards: [OnboardingGuard(sharedPreferenceService)],
            transitionsBuilder: TransitionsBuilders.zoomIn,
            children: [
              CustomRoute(
                initial: true,
                page: HomeRoute.page,
              ),
              AutoRoute(page: ChatGptIntegrationRoute.page),
              CustomRoute(
                page: ChatGptOnDeviceGuidanceRoute.page,
                fullscreenDialog: true,
                transitionsBuilder: TransitionsBuilders.slideBottom,
                durationInMilliseconds: 250,
              ),
              AutoRoute(page: McpIntegrationRoute.page),
              AutoRoute(page: FaqRoute.page),
            ],
          ),
        ];
}
