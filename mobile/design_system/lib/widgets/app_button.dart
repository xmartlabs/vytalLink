import 'dart:async';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class AppButtonDefaults {
  static const double height = 44;
  static const double iconSize = 18;
  static const double iconGap = 12;
  static const EdgeInsets padding =
      EdgeInsets.symmetric(horizontal: 20, vertical: 12);
}

enum AppButtonVariant { filled, outlined, text }

enum AppButtonTone { primary, danger, warning, neutral }

typedef AppButtonCallback = FutureOr<void> Function();

class AppButton extends StatelessWidget {
  final AppButtonVariant variant;
  final AppButtonTone tone;
  final String label;
  final AppButtonCallback? onPressed;
  final Widget? icon;
  final bool expand;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final double? height;

  const AppButton._({
    required this.variant,
    required this.tone,
    required this.label,
    this.onPressed,
    this.icon,
    this.expand = true,
    this.isLoading = false,
    this.padding,
    this.height,
    super.key,
  });

  const AppButton.filled({
    required String label,
    AppButtonTone tone = AppButtonTone.primary,
    AppButtonCallback? onPressed,
    Widget? icon,
    bool expand = true,
    bool isLoading = false,
    EdgeInsetsGeometry? padding,
    double? height,
    Key? key,
  }) : this._(
          variant: AppButtonVariant.filled,
          tone: tone,
          label: label,
          onPressed: onPressed,
          icon: icon,
          expand: expand,
          isLoading: isLoading,
          padding: padding,
          height: height,
          key: key,
        );

  const AppButton.outlined({
    required String label,
    AppButtonTone tone = AppButtonTone.primary,
    AppButtonCallback? onPressed,
    Widget? icon,
    bool expand = true,
    bool isLoading = false,
    EdgeInsetsGeometry? padding,
    double? height,
    Key? key,
  }) : this._(
          variant: AppButtonVariant.outlined,
          tone: tone,
          label: label,
          onPressed: onPressed,
          icon: icon,
          expand: expand,
          isLoading: isLoading,
          padding: padding,
          height: height,
          key: key,
        );

  const AppButton.text({
    required String label,
    AppButtonTone tone = AppButtonTone.primary,
    AppButtonCallback? onPressed,
    Widget? icon,
    bool expand = false,
    bool isLoading = false,
    EdgeInsetsGeometry? padding,
    double? height,
    Key? key,
  }) : this._(
          variant: AppButtonVariant.text,
          tone: tone,
          label: label,
          onPressed: onPressed,
          icon: icon,
          expand: expand,
          isLoading: isLoading,
          padding: padding,
          height: height,
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    final appearance = _resolveAppearance(context);
    final button = _buildButton(context, appearance);
    if (!expand) return button;
    return SizedBox(width: double.infinity, child: button);
  }

  ButtonStyleButton _buildButton(
    BuildContext context,
    _ButtonAppearance appearance,
  ) {
    final effectiveHeight = height ?? AppButtonDefaults.height;
    final effectivePadding = padding ?? AppButtonDefaults.padding;
    final textStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        );
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    );
    final minimumSize = WidgetStateProperty.all<Size>(
      Size.fromHeight(effectiveHeight),
    );
    final handlePressed = isLoading ? null : _wrapCallback(onPressed);
    final child = _buildContent(context, appearance.foregroundColor);

    switch (variant) {
      case AppButtonVariant.filled:
        final style = FilledButton.styleFrom(
          backgroundColor: appearance.backgroundColor,
          foregroundColor: appearance.foregroundColor,
          padding: effectivePadding,
          textStyle: textStyle,
          shape: shape,
          elevation: appearance.elevation,
          shadowColor: appearance.shadowColor,
        ).copyWith(minimumSize: minimumSize);

        return FilledButton(
          onPressed: handlePressed,
          style: style,
          child: child,
        );
      case AppButtonVariant.outlined:
        final style = OutlinedButton.styleFrom(
          foregroundColor: appearance.foregroundColor,
          padding: effectivePadding,
          textStyle: textStyle,
          shape: shape,
          side: BorderSide(
            color: appearance.borderColor ?? appearance.foregroundColor,
            width: 1.5,
          ),
        ).copyWith(minimumSize: minimumSize);

        return OutlinedButton(
          onPressed: handlePressed,
          style: style,
          child: child,
        );
      case AppButtonVariant.text:
        final style = TextButton.styleFrom(
          foregroundColor: appearance.foregroundColor,
          padding: effectivePadding,
          textStyle: textStyle,
          shape: shape,
        ).copyWith(minimumSize: minimumSize);

        return TextButton(
          onPressed: handlePressed,
          style: style,
          child: child,
        );
    }
  }

  Widget _buildContent(BuildContext context, Color textColor) {
    final text = Text(
      label,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: textColor,
          ),
    );

    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(child: text),
        ],
      );
    }

    if (icon == null) return text;

    return IconTheme(
      data: IconThemeData(color: textColor, size: AppButtonDefaults.iconSize),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          const SizedBox(width: AppButtonDefaults.iconGap),
          Flexible(child: text),
        ],
      ),
    );
  }

  _ButtonAppearance _resolveAppearance(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customColors = theme.customColors;

    Color baseColor;
    switch (tone) {
      case AppButtonTone.primary:
        baseColor = colorScheme.primary;
        break;
      case AppButtonTone.danger:
        baseColor = customColors.danger ?? colorScheme.error;
        break;
      case AppButtonTone.warning:
        baseColor = customColors.warning ?? colorScheme.tertiary;
        break;
      case AppButtonTone.neutral:
        baseColor = colorScheme.onSurfaceVariant;
        break;
    }

    switch (variant) {
      case AppButtonVariant.filled:
        final foreground = tone == AppButtonTone.neutral
            ? colorScheme.onSurface
            : Colors.white;
        return _ButtonAppearance(
          backgroundColor: baseColor,
          foregroundColor: foreground,
          elevation: 4,
          shadowColor: baseColor.withValues(alpha: 0.3),
        );
      case AppButtonVariant.outlined:
        return _ButtonAppearance(
          backgroundColor: Colors.transparent,
          foregroundColor: baseColor,
          borderColor: baseColor,
          elevation: 0,
          shadowColor: Colors.transparent,
        );
      case AppButtonVariant.text:
        return _ButtonAppearance(
          backgroundColor: Colors.transparent,
          foregroundColor: baseColor,
          elevation: 0,
          shadowColor: Colors.transparent,
        );
    }
  }

  VoidCallback? _wrapCallback(AppButtonCallback? callback) {
    if (callback == null) return null;
    return () {
      final result = callback();
      if (result is Future<void>) {
        unawaited(result);
      }
    };
  }
}

class _ButtonAppearance {
  final Color? backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final double elevation;
  final Color shadowColor;

  const _ButtonAppearance({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.elevation,
    required this.shadowColor,
    this.borderColor,
  });
}
