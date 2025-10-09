import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/gen/assets.gen.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';
import 'package:flutter_template/ui/onboarding/onboarding_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum OnboardingPageType {
  welcome,
  healthMonitoring,
  howItWorks,
  askQuestions,
  aiIntegration,
}

extension OnboardingPageTypeExtension on OnboardingPageType {
  OnboardingPage buildPage(BuildContext context) {
    switch (this) {
      case OnboardingPageType.welcome:
        return _buildWelcomePage(context);
      case OnboardingPageType.healthMonitoring:
        return _buildHealthMonitoringPage(context);
      case OnboardingPageType.howItWorks:
        return _buildHowItWorksPage(context);
      case OnboardingPageType.askQuestions:
        return _buildAskQuestionsPage(context);
      case OnboardingPageType.aiIntegration:
        return _buildAiIntegrationPage(context);
    }
  }

  OnboardingPage _buildWelcomePage(BuildContext context) => OnboardingPage(
        icon: FontAwesomeIcons.heartPulse,
        title: context.localizations.onboarding_welcome_title,
        subtitle: context.localizations.onboarding_welcome_subtitle,
        description: context.localizations.onboarding_welcome_description,
        features: [
          context.localizations.onboarding_welcome_feature_1,
          context.localizations.onboarding_welcome_feature_2,
          context.localizations.onboarding_welcome_feature_3,
        ],
      );

  OnboardingPage _buildHealthMonitoringPage(BuildContext context) =>
      OnboardingPage(
        icon: FontAwesomeIcons.stopwatch,
        iconWidget: Padding(
          padding: EdgeInsets.all(1.sw < 0.4 ? 20.w : 30.w),
          child: Assets.icons.watchVariant.svg(
            width: 32,
            height: 32,
            colorFilter: ColorFilter.mode(
              context.theme.colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
        ),
        title: context.localizations.onboarding_health_monitoring_title,
        subtitle: context.localizations.onboarding_health_monitoring_subtitle,
        description:
            context.localizations.onboarding_health_monitoring_description,
        features: [
          context.localizations.onboarding_health_monitoring_feature_1,
          context.localizations.onboarding_health_monitoring_feature_2,
          context.localizations.onboarding_health_monitoring_feature_3,
        ],
      );

  OnboardingPage _buildHowItWorksPage(BuildContext context) => OnboardingPage(
        icon: FontAwesomeIcons.robot,
        title: context.localizations.onboarding_how_it_works_title,
        subtitle: context.localizations.onboarding_how_it_works_subtitle,
        description: context.localizations.onboarding_how_it_works_description,
        features: [
          context.localizations.onboarding_how_it_works_feature_1,
          context.localizations.onboarding_how_it_works_feature_2,
          context.localizations.onboarding_how_it_works_feature_3,
        ],
      );

  OnboardingPage _buildAskQuestionsPage(BuildContext context) => OnboardingPage(
        icon: FontAwesomeIcons.chartLine,
        title: context.localizations.onboarding_ask_questions_title,
        subtitle: context.localizations.onboarding_ask_questions_subtitle,
        description: context.localizations.onboarding_ask_questions_description,
        features: [
          context.localizations.onboarding_ask_questions_feature_1,
          context.localizations.onboarding_ask_questions_feature_2,
          context.localizations.onboarding_ask_questions_feature_3,
        ],
      );

  OnboardingPage _buildAiIntegrationPage(BuildContext context) =>
      OnboardingPage(
        icon: FontAwesomeIcons.comments,
        title: context.localizations.onboarding_ai_integration_title,
        subtitle: context.localizations.onboarding_ai_integration_subtitle,
        description:
            context.localizations.onboarding_ai_integration_description,
        features: [
          context.localizations.onboarding_ai_integration_feature_1,
          context.localizations.onboarding_ai_integration_feature_2,
          context.localizations.onboarding_ai_integration_feature_3,
        ],
      );
}

List<OnboardingPage> generateOnboardingPages(BuildContext context) =>
    OnboardingPageType.values.map((e) => e.buildPage(context)).toList();
