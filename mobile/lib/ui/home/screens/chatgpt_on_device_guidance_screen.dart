import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  bool _acknowledged = false;
  bool _dontShowAgain = false;

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

    final spacing12 = SizedBox(height: dimens.spacing12.h);

    final bulletTexts = [
      localizations.home_on_device_guidance_bullet_browser,
      localizations.home_on_device_guidance_bullet_no_external_app,
      if (Platform.isIOS) localizations.home_on_device_guidance_bullet_keyboard,
      localizations.home_on_device_guidance_bullet_charts,
      localizations.home_on_device_guidance_bullet_clipboard,
    ];

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  dimens.spacing24.w,
                  dimens.spacing8.h,
                  dimens.spacing24.w,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BoldTagText(
                      text: localizations.home_on_device_guidance_intro,
                      baseStyle: introStyle,
                    ),
                    SizedBox(height: dimens.spacing20.h),
                    for (int i = 0; i < bulletTexts.length; i++) ...[
                      _GuidanceBullet(
                        index: i + 1,
                        text: bulletTexts[i],
                        textStyle: bulletStyle,
                      ),
                      spacing12,
                    ],
                    SizedBox(height: dimens.spacing16.h),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                dimens.spacing24.w,
                0,
                dimens.spacing24.w,
                dimens.spacing20.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _CheckboxBlock(
                    acknowledged: _acknowledged,
                    dontShowAgain: _dontShowAgain,
                    onAcknowledgeChanged: (value) =>
                        setState(() => _acknowledged = value ?? false),
                    onDontShowChanged: (value) =>
                        setState(() => _dontShowAgain = value ?? false),
                    checkboxGap: 0,
                    bulletStyle: bulletStyle,
                  ),
                  spacing12,
                  FilledButton(
                    onPressed: _acknowledged
                        ? () => context.router.maybePop(
                              ChatGptOnDeviceGuidanceResult(
                                proceed: true,
                                dontShowAgain: _dontShowAgain,
                              ),
                            )
                        : null,
                    child: Text(
                      localizations.home_on_device_guidance_primary,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  spacing12,
                  TextButton(
                    onPressed: () => context.router.maybePop(
                      const ChatGptOnDeviceGuidanceResult(
                        proceed: false,
                        dontShowAgain: false,
                      ),
                    ),
                    child: Text(
                      localizations.home_on_device_guidance_secondary,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuidanceBullet extends StatelessWidget {
  final int index;
  final String text;
  final TextStyle? textStyle;

  const _GuidanceBullet({
    required this.index,
    required this.text,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            '$index.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: BoldTagText(
            text: text,
            baseStyle: textStyle ??
                theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
          ),
        ),
      ],
    );
  }
}

class _CheckboxBlock extends StatelessWidget {
  final bool? acknowledged;
  final bool? dontShowAgain;
  final ValueChanged<bool?> onAcknowledgeChanged;
  final ValueChanged<bool?> onDontShowChanged;
  final double checkboxGap;
  final TextStyle? bulletStyle;

  const _CheckboxBlock({
    required this.acknowledged,
    required this.dontShowAgain,
    required this.onAcknowledgeChanged,
    required this.onDontShowChanged,
    required this.checkboxGap,
    this.bulletStyle,
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
        ),
      ),
      child: Column(
        children: [
          CheckboxListTile(
            value: acknowledged,
            onChanged: onAcknowledgeChanged,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            dense: true,
            title: Text(
              context.localizations.home_on_device_guidance_acknowledge,
              style: bulletStyle ??
                  theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    height: 1.4,
                  ),
            ),
          ),
          SizedBox(height: checkboxGap),
          CheckboxListTile(
            value: dontShowAgain,
            onChanged: onDontShowChanged,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            dense: true,
            title: Text(
              context.localizations.home_on_device_guidance_skip_checkbox,
              style: bulletStyle ??
                  theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    height: 1.4,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
