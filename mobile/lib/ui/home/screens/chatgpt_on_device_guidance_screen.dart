import 'package:design_system/design_system.dart';
import 'package:flutter/foundation.dart';
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
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;
    final bool isSmallScreen = screenHeight < 720 || screenWidth < 380;
    final bool isVeryLargeScreen = screenHeight > 900 || screenWidth > 500;
    final bool isLargeScreen = !isSmallScreen;

    double responsive(double small, double medium, double large) {
      if (isSmallScreen) return small;
      if (isVeryLargeScreen) return large;
      return medium;
    }

    final double scrollTopPadding = responsive(4, 8, 16);
    final double introSpacing = responsive(12, 18, 26);
    final double bulletSpacing = responsive(8, 12, 18);
    final double afterBulletsSpacing = responsive(12, 16, 22);
    final double checkboxGap = responsive(4, 6, 10);
    final double betweenButtons = responsive(10, 12, 16);
    final double bottomPadding = responsive(16, 20, 28);
    final double primaryVerticalPadding = responsive(10, 12, 14);
    final double secondaryVerticalPadding = responsive(8, 10, 12);
    final bool placeCheckboxBelow = isLargeScreen;

    final double introFontBump = isLargeScreen ? (isVeryLargeScreen ? 3 : 1.5) : 0;
    final double bulletFontBump = isLargeScreen ? (isVeryLargeScreen ? 2 : 1) : 0;
    final double checkboxFontBump = placeCheckboxBelow ? bulletFontBump : 0;

    final baseBodyStyle = theme.textTheme.bodyMedium;
    final baseBulletStyle = theme.textTheme.bodyMedium;
    final introStyle = baseBodyStyle?.copyWith(
      fontSize: (baseBodyStyle?.fontSize ?? 14) + introFontBump,
      color: theme.colorScheme.onSurface,
      height: 1.4,
    );
    final bulletStyle = baseBulletStyle?.copyWith(
      fontSize: (baseBulletStyle?.fontSize ?? 14) + bulletFontBump,
      color: theme.colorScheme.onSurfaceVariant,
      height: 1.4,
    );

    final primaryButtonStyle = FilledButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: primaryVerticalPadding),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      textStyle: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      minimumSize: const Size.fromHeight(44),
      foregroundColor: Colors.white,
      backgroundColor: theme.colorScheme.primary,
      disabledBackgroundColor: theme.colorScheme.primary.withOpacity(0.3),
      disabledForegroundColor: theme.colorScheme.onSurface.withOpacity(0.65),
    );

    final secondaryButtonStyle = TextButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: secondaryVerticalPadding),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      textStyle: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      foregroundColor: theme.colorScheme.primary,
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
          onPressed: () => Navigator.of(context).pop(
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
                padding: EdgeInsets.fromLTRB(24.w, scrollTopPadding, 24.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BoldTagText(
                      text: localizations.home_on_device_guidance_intro,
                      baseStyle: introStyle,
                    ),
                    SizedBox(height: introSpacing),
                    _GuidanceBullet(
                      index: 1,
                      text: localizations.home_on_device_guidance_bullet_browser,
                      textStyle: bulletStyle,
                    ),
                    SizedBox(height: bulletSpacing),
                    _GuidanceBullet(
                      index: 2,
                      text:
                          localizations.home_on_device_guidance_bullet_no_external_app,
                      textStyle: bulletStyle,
                    ),
                    SizedBox(height: bulletSpacing),
                    _GuidanceBullet(
                      index: 3,
                      text: localizations.home_on_device_guidance_bullet_keyboard,
                      textStyle: bulletStyle,
                    ),
                    SizedBox(height: bulletSpacing),
                    _GuidanceBullet(
                      index: 4,
                      text: localizations.home_on_device_guidance_bullet_clipboard,
                      textStyle: bulletStyle,
                    ),
                    if (!placeCheckboxBelow) ...[
                      SizedBox(height: afterBulletsSpacing),
                      _CheckboxBlock(
                        acknowledged: _acknowledged,
                        dontShowAgain: _dontShowAgain,
                        onAcknowledgeChanged: (value) =>
                            setState(() => _acknowledged = value ?? false),
                        onDontShowChanged: (value) =>
                            setState(() => _dontShowAgain = value ?? false),
                        checkboxGap: checkboxGap,
                        bulletStyle: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: (theme.textTheme.bodyMedium?.fontSize ?? 14) +
                              checkboxFontBump,
                          color: theme.colorScheme.onSurface,
                          height: 1.4,
                        ),
                      ),
                    ] else
                      SizedBox(height: afterBulletsSpacing),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, bottomPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (placeCheckboxBelow)
                    Padding(
                      padding: EdgeInsets.only(bottom: betweenButtons),
                      child: _CheckboxBlock(
                        acknowledged: _acknowledged,
                        dontShowAgain: _dontShowAgain,
                        onAcknowledgeChanged: (value) =>
                            setState(() => _acknowledged = value ?? false),
                        onDontShowChanged: (value) =>
                            setState(() => _dontShowAgain = value ?? false),
                        checkboxGap: checkboxGap,
                        bulletStyle: theme.textTheme.bodyMedium?.copyWith(
                          fontSize:
                              (theme.textTheme.bodyMedium?.fontSize ?? 14) + checkboxFontBump,
                          color: theme.colorScheme.onSurface,
                          height: 1.4,
                        ),
                      ),
                    ),
                  FilledButton(
                    onPressed: _acknowledged
                        ? () => Navigator.of(context).pop(
                              ChatGptOnDeviceGuidanceResult(
                                proceed: true,
                                dontShowAgain: _dontShowAgain,
                              ),
                            )
                        : null,
                    style: primaryButtonStyle,
                    child: Text(
                      localizations.home_on_device_guidance_primary,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: betweenButtons),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(
                      const ChatGptOnDeviceGuidanceResult(
                        proceed: false,
                        dontShowAgain: false,
                      ),
                    ),
                    style: secondaryButtonStyle,
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
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return theme.colorScheme.primary;
            }
            return Colors.transparent;
          }),
          checkColor: MaterialStateProperty.all<Color>(Colors.white),
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
