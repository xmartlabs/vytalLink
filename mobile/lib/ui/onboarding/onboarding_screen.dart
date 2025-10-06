import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:design_system/extensions/color_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';
import 'package:flutter_template/ui/onboarding/onboarding_cubit.dart';
import 'package:flutter_template/ui/onboarding/onboarding_pages.dart';
import 'package:flutter_template/ui/widgets/bold_tag_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const double _kSmallScreenHeightThreshold = 700;

@RoutePage()
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => OnboardingCubit(),
        child: const _OnboardingContentScreen(),
      );
}

class _OnboardingContentScreen extends StatefulWidget {
  const _OnboardingContentScreen({super.key});

  @override
  State<_OnboardingContentScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<_OnboardingContentScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _iconAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _iconAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _iconAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _iconAnimation = CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.elasticOut,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    );
    _startAnimations();
  }

  void _startAnimations() {
    _iconAnimationController.forward();
    _fadeAnimationController.forward();
  }

  void _restartAnimations() {
    _iconAnimationController.reset();
    _fadeAnimationController.reset();
    _startAnimations();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _iconAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = generateOnboardingPages(context);
    return Scaffold(
      backgroundColor: context.theme.colorScheme.surface,
      body: SafeArea(
        child: BlocBuilder<OnboardingCubit, OnboardingState>(
          builder: (context, state) => Column(
            children: [
              OnboardingHeader(onSkip: _finishOnboarding),
              _OnboardingPageIndicator(
                pages: pages,
                currentPage: state.currentPage,
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    context.read<OnboardingCubit>().setCurrentPage(index);
                  },
                  itemCount: pages.length,
                  itemBuilder: (context, index) => _OnboardingPageWidget(
                    page: pages[index],
                    iconAnimation: _iconAnimation,
                    fadeAnimation: _fadeAnimation,
                  ),
                ),
              ),
              _OnboardingNavigationSection(
                currentPage: state.currentPage,
                pageController: _pageController,
                pages: pages,
                finishOnboarding: _finishOnboarding,
                restartAnimations: _restartAnimations,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _finishOnboarding() =>
      context.read<OnboardingCubit>().completeOnboarding();
}

class OnboardingHeader extends StatelessWidget {
  final VoidCallback onSkip;

  const OnboardingHeader({required this.onSkip, super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.heartPulse,
                  color: context.theme.colorScheme.primary,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  context.localizations.app_name,
                  style: context.theme.customTextStyles.customOverline.copyWith(
                    color: context.theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: onSkip,
              child: Text(
                context.localizations.onboarding_skip,
                style: TextStyle(
                  color: context.theme.customColors.textColor!.getShade(300),
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        ),
      );
}

class _OnboardingPageIndicator extends StatelessWidget {
  const _OnboardingPageIndicator({
    required List<OnboardingPage> pages,
    required int currentPage,
    super.key,
  })  : _pages = pages,
        _currentPage = currentPage;

  final List<OnboardingPage> _pages;
  final int _currentPage;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Row(
          children: List.generate(
            _pages.length,
            (index) => Expanded(
              child: Container(
                height: 4.h,
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: BoxDecoration(
                  color: index <= _currentPage
                      ? context.theme.colorScheme.primary
                      : context.theme.customColors.textColor!.getShade(200),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
          ),
        ),
      );
}

class _OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;
  final Animation<double> iconAnimation;
  final Animation<double> fadeAnimation;

  const _OnboardingPageWidget({
    required this.page,
    required this.iconAnimation,
    required this.fadeAnimation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = _isSmallScreen(context);
    final colorScheme = context.theme.colorScheme;
    final bodyText = _composeBodyText();
    final double horizontalPadding = 35.w;
    final double availableWidth =
        MediaQuery.of(context).size.width - horizontalPadding * 2;
    final double contentMaxWidth = math.min(availableWidth, 320.w);
    final TextStyle baseTitleStyle = context.theme.textTheme.headlineMedium ??
        const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
    final double titleFontSize = (baseTitleStyle.fontSize ?? 24) + 2;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        children: [
          SizedBox(height: isSmallScreen ? 16.h : 26.h),
          ScaleTransition(
            scale: iconAnimation,
            child: Builder(
              builder: (context) {
                final double logoSize = isSmallScreen ? 72.w : 108.w;
                return Container(
                  width: logoSize,
                  height: logoSize,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(logoSize / 2),
                  ),
                  child: page.iconWidget ??
                      Icon(
                        page.icon,
                        size: isSmallScreen ? 40.sp : 44.sp,
                        color: colorScheme.primary,
                      ),
                );
              },
            ),
          ),
          SizedBox(height: isSmallScreen ? 12.h : 18.h),
          Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentMaxWidth),
              child: FadeTransition(
                opacity: fadeAnimation,
                child: Text(
                  page.title,
                  style: baseTitleStyle.copyWith(
                    color: context.theme.customColors.textColor!.getShade(500),
                    fontWeight: FontWeight.bold,
                    fontSize: titleFontSize,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          if (bodyText.isNotEmpty) ...[
            SizedBox(height: isSmallScreen ? 14.h : 18.h),
            Align(
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentMaxWidth),
                child: FadeTransition(
                  opacity: fadeAnimation,
                  child: _HighlightedDescription(text: bodyText),
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 16.h : 24.h),
          ] else
            SizedBox(height: isSmallScreen ? 16.h : 24.h),
          if (page.features.isNotEmpty)
            Flexible(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentMaxWidth),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < page.features.length; i++) ...[
                        _FeatureItem(
                          text: page.features[i],
                          isQuestion: page.features[i].startsWith('"'),
                        ),
                        if (i < page.features.length - 1)
                          SizedBox(height: isSmallScreen ? 4.h : 8.h),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          SizedBox(height: isSmallScreen ? 6.h : 16.h),
        ],
      ),
    );
  }

  bool _isSmallScreen(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return screenHeight < _kSmallScreenHeightThreshold;
  }

  String _composeBodyText() {
    final parts = <String>[];
    final subtitle = page.subtitle.trim();
    final description = page.description.trim();
    if (subtitle.isNotEmpty) {
      parts.add(subtitle);
    }
    if (description.isNotEmpty) {
      parts.add(description);
    }
    return parts.join('\n\n');
  }
}

class _HighlightedDescription extends StatelessWidget {
  final String text;

  const _HighlightedDescription({required this.text});

  @override
  Widget build(BuildContext context) {
    final bool isSmall =
        MediaQuery.of(context).size.height < _kSmallScreenHeightThreshold;
    final baseStyle = context.theme.textTheme.bodyLarge?.copyWith(
      color: context.theme.customColors.textColor!.getShade(400),
      height: 1.4,
      fontSize: isSmall ? 13.sp : null,
    );
    return BoldTagText(
      text: text,
      baseStyle: baseStyle,
      textAlign: TextAlign.center,
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String text;
  final bool isQuestion;

  const _FeatureItem({
    required this.text,
    this.isQuestion = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen =
        MediaQuery.of(context).size.height < _kSmallScreenHeightThreshold;
    if (isQuestion) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12.w : 16.w,
          vertical: isSmallScreen ? 8.h : 10.h,
        ),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: context.theme.colorScheme.primary.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: context.theme.textTheme.bodyMedium?.copyWith(
            color: context.theme.customColors.textColor!.getShade(400),
            fontStyle: FontStyle.italic,
            fontSize: isSmallScreen ? 11.5.sp : 12.5.sp,
            height: 1.3,
          ),
          textAlign: TextAlign.start,
        ),
      );
    }

    return Row(
      children: [
        Icon(
          FontAwesomeIcons.circleCheck,
          size: 16.sp,
          color: context.theme.colorScheme.primary,
        ),
        SizedBox(width: isSmallScreen ? 10.w : 12.w),
        Expanded(
          child: Text(
            text,
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: context.theme.customColors.textColor!.getShade(400),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class OnboardingPage {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final List<String> features;
  final List<String> highlights;
  final Widget? iconWidget;

  OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.features,
    this.highlights = const [],
    this.iconWidget,
  });
}

class _OnboardingNavigationSection extends StatelessWidget {
  final int currentPage;
  final PageController pageController;
  final List<OnboardingPage> pages;
  final VoidCallback finishOnboarding;
  final VoidCallback restartAnimations;

  const _OnboardingNavigationSection({
    required this.currentPage,
    required this.pageController,
    required this.pages,
    required this.finishOnboarding,
    required this.restartAnimations,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: SizedBox(
        height: 48.h,
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              width: currentPage > 0 ? (size.width - 48.w - 16.w) * 0.5 : 0,
              child: ClipRect(
                child: AnimatedOpacity(
                  opacity: currentPage > 0 ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: AnimatedScale(
                    scale: currentPage > 0 ? 1.0 : 0.8,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutBack,
                    child: currentPage > 0
                        ? AppButton.outlined(
                            label: context.localizations.onboarding_previous,
                            onPressed: () {
                              restartAnimations();
                              pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            height: AppButtonDefaults.height,
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              width: currentPage > 0 ? 16.w : 0,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              width: currentPage == 0
                  ? size.width - 48.w
                  : (size.width - 48.w - 16.w) * 0.5,
              child: AppButton.filled(
                label: currentPage == pages.length - 1
                    ? context.localizations.onboarding_get_started
                    : context.localizations.onboarding_next,
                onPressed: () {
                  if (currentPage == pages.length - 1) {
                    finishOnboarding();
                  } else {
                    restartAnimations();
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                height: AppButtonDefaults.height,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
