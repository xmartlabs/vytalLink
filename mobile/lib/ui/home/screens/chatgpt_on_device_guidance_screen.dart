import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/service/once_service.dart';
import 'package:flutter_template/l10n/app_localizations.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';
import 'package:flutter_template/ui/widgets/bold_tag_text.dart';

@immutable
class ChatGptOnDeviceGuidanceResult {
  final bool proceed;
  final bool dontShowAgain;

  const ChatGptOnDeviceGuidanceResult({
    required this.proceed,
    required this.dontShowAgain,
  });
}

@RoutePage<ChatGptOnDeviceGuidanceResult>()
class ChatGptOnDeviceGuidanceScreen extends StatefulWidget {
  const ChatGptOnDeviceGuidanceScreen({super.key});

  @override
  State<ChatGptOnDeviceGuidanceScreen> createState() =>
      _ChatGptOnDeviceGuidanceScreenState();
}

class _ChatGptOnDeviceGuidanceScreenState
    extends State<ChatGptOnDeviceGuidanceScreen> {
  static const _kCountdownSeconds = 10;
  static const _countdownOnceKey = 'chatgpt_guidance_timer_complete';

  List<bool> _stepsCompleted = const [];
  bool _dontShowAgain = false;
  bool _countdownRequired = true;
  bool _countdownRecorded = false;
  int _countdown = _kCountdownSeconds;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _initializeCountdown();
  }

  List<_GuidanceStepData> _buildSteps(AppLocalizations localizations) => [
        (
          title: localizations.home_on_device_guidance_step_browser_title,
          paragraphs: [
            localizations.home_on_device_guidance_bullet_no_external_app,
          ],
        ),
        (
          title: localizations.home_on_device_guidance_step_clipboard_title,
          paragraphs: [localizations.home_on_device_guidance_bullet_clipboard],
        ),
        (
          title: localizations.home_on_device_guidance_step_charts_title,
          paragraphs: [localizations.home_on_device_guidance_bullet_charts],
        ),
      ];

  Future<void> _initializeCountdown() async {
    final alreadyCompleted = await OnceService.beenDone(_countdownOnceKey);
    if (!mounted) return;
    if (alreadyCompleted) {
      setState(() {
        _countdownRequired = false;
        _countdownRecorded = true;
        _countdown = 0;
      });
      return;
    }
    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownRequired = true;
    _countdown = _kCountdownSeconds;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_countdown <= 1) {
        setState(() {
          _countdown = 0;
          _countdownRequired = false;
        });
        timer.cancel();
        return;
      }
      setState(() => _countdown -= 1);
    });
  }

  int get _completedStepsCount =>
      _stepsCompleted.where((completed) => completed).length;

  bool get _allStepsCompleted =>
      _stepsCompleted.isNotEmpty &&
      _stepsCompleted.every((completed) => completed);

  bool get _countdownFinished => _countdown == 0;

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final localizations = context.localizations;
    final dimens = theme.extension<AppDimension>()!;

    final introStyle = theme.textTheme.bodyMedium?.copyWith(
      fontSize: 14.sp,
      color: theme.colorScheme.onSurface,
      height: 1.4,
    );
    final bulletStyle = theme.textTheme.bodyMedium?.copyWith(
      fontSize: 13.sp,
      color: theme.colorScheme.onSurfaceVariant,
      height: 1.4,
    );

    final steps = _buildSteps(localizations);
    if (_stepsCompleted.length != steps.length) {
      final previous = _stepsCompleted;
      _stepsCompleted = List<bool>.generate(
        steps.length,
        (index) => index < previous.length && previous[index],
      );
    }

    final totalSteps = steps.length;
    final completedSteps = _completedStepsCount;
    final allStepsCompleted = _allStepsCompleted;
    final countdownFinished = !_countdownRequired || _countdownFinished;
    final canOpen = allStepsCompleted && countdownFinished;
    final showCountdown = _countdownRequired && !countdownFinished;
    final primaryCtaLabel = localizations.home_on_device_guidance_primary;
    final reminderTitleStyle = theme.textTheme.titleSmall?.copyWith(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.w700,
      height: 1.25,
    );
    final progressStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      height: 1.35,
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          color: theme.colorScheme.onSurface,
          onPressed: () => context.router.maybePop(
            const ChatGptOnDeviceGuidanceResult(
              proceed: false,
              dontShowAgain: false,
            ),
          ),
        ),
        title: Text(
          localizations.home_on_device_guidance_title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, _) => Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    dimens.spacing24.w,
                    dimens.spacing12.h,
                    dimens.spacing24.w,
                    dimens.spacing12.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BoldTagText(
                        text: localizations.home_on_device_guidance_intro,
                        baseStyle: introStyle,
                      ),
                      SizedBox(height: dimens.spacing20.h),
                      ...List.generate(
                        totalSteps,
                        (i) => Padding(
                          padding: EdgeInsets.only(
                            bottom: i < totalSteps - 1 ? dimens.spacing12.h : 0,
                          ),
                          child: _GuidanceChecklistItem(
                            index: i,
                            title: steps[i].title,
                            paragraphs: steps[i].paragraphs,
                            checked: _stepsCompleted[i],
                            textStyle: bulletStyle,
                            titleStyle: reminderTitleStyle,
                            onChanged: (value) => setState(
                              () => _stepsCompleted[i] = value,
                            ),
                          ),
                        ),
                      ),
                      if (totalSteps > 0) SizedBox(height: dimens.spacing20.h),
                      if (totalSteps > 0)
                        Text(
                          localizations.home_on_device_guidance_progress(
                            completedSteps,
                            totalSteps,
                          ),
                          style: progressStyle,
                        ),
                      SizedBox(height: dimens.spacing24.h),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Text(
                          allStepsCompleted
                              ? localizations.home_on_device_guidance_ready
                              : localizations
                                  .home_on_device_guidance_acknowledge,
                          key: ValueKey<bool>(allStepsCompleted),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: allStepsCompleted
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom section with checkbox, timer, and button
              Container(
                padding: EdgeInsets.fromLTRB(
                  dimens.spacing24.w,
                  dimens.spacing12.h,
                  dimens.spacing24.w,
                  dimens.spacing24.h + MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _DontShowAgainCheckbox(
                      value: _dontShowAgain,
                      onChanged: (value) =>
                          setState(() => _dontShowAgain = value ?? false),
                      textStyle: bulletStyle,
                    ),
                    SizedBox(height: dimens.spacing16.h),
                    if (showCountdown) ...[
                      FilledButton(
                        onPressed: null,
                        style: FilledButton.styleFrom(
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          backgroundColor:
                              theme.colorScheme.surfaceContainerHighest,
                          foregroundColor: theme.colorScheme.onSurfaceVariant,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 18.w,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              localizations.home_on_device_guidance_timer_text(
                                _countdown,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (!showCountdown)
                      FilledButton(
                        onPressed: canOpen
                            ? () {
                                if (!_countdownRecorded) {
                                  OnceService.markDone(_countdownOnceKey)
                                      .ignore();
                                  setState(() {
                                    _countdownRecorded = true;
                                    _countdownRequired = false;
                                  });
                                }
                                context.router.maybePop(
                                  ChatGptOnDeviceGuidanceResult(
                                    proceed: true,
                                    dontShowAgain: _dontShowAgain,
                                  ),
                                );
                              }
                            : null,
                        style: !canOpen
                            ? FilledButton.styleFrom(
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                backgroundColor:
                                    theme.colorScheme.surfaceContainerHighest,
                                foregroundColor:
                                    theme.colorScheme.onSurfaceVariant,
                              )
                            : null,
                        child: Text(
                          primaryCtaLabel,
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuidanceChecklistItem extends StatelessWidget {
  final int index;
  final String title;
  final List<String> paragraphs;
  final bool checked;
  final ValueChanged<bool> onChanged;
  final TextStyle? textStyle;
  final TextStyle? titleStyle;

  const _GuidanceChecklistItem({
    required this.index,
    required this.title,
    required this.paragraphs,
    required this.checked,
    required this.onChanged,
    this.textStyle,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Theme(
      data: theme.copyWith(
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          splashRadius: 18,
          side: BorderSide(
            color: theme.colorScheme.onSurfaceVariant,
            width: 1.5,
          ),
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return theme.colorScheme.primary;
            }
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all<Color>(Colors.white),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: checked
              ? theme.colorScheme.primary.withValues(alpha: 0.08)
              : theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.08),
          border: Border.all(
            color: checked
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
          ),
        ),
        child: CheckboxListTile(
          value: checked,
          onChanged: (value) => onChanged(value ?? false),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
          visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
          title: Text(
            '${index + 1}. $title',
            style: titleStyle ??
                theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < paragraphs.length; i++) ...[
                  BoldTagText(
                    text: paragraphs[i],
                    baseStyle: textStyle ??
                        theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                  ),
                  if (i < paragraphs.length - 1) SizedBox(height: 8.h),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DontShowAgainCheckbox extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool?> onChanged;
  final TextStyle? textStyle;

  const _DontShowAgainCheckbox({
    required this.value,
    required this.onChanged,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Theme(
      data: theme.copyWith(
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          splashRadius: 18,
          side: BorderSide(
            color: theme.colorScheme.onSurfaceVariant,
            width: 1.5,
          ),
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return theme.colorScheme.primary;
            }
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all<Color>(Colors.white),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      child: Transform.scale(
        scale: 0.9,
        alignment: Alignment.centerLeft,
        child: CheckboxListTile(
          value: value,
          onChanged: onChanged,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          dense: true,
          title: Text(
            context.localizations.home_on_device_guidance_skip_checkbox,
            style: textStyle ??
                theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.3,
                ),
          ),
        ),
      ),
    );
  }
}

typedef _GuidanceStepData = ({String title, List<String> paragraphs});
