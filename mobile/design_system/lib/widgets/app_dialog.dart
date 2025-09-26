import 'package:design_system/design_system.dart';
import 'package:design_system/extensions/color_extensions.dart';
import 'package:design_system/theme/app_buttons.dart';
import 'package:flutter/material.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final String? content;
  final Widget? contentWidget;
  final String? actionButtonText;
  final VoidCallback? onActionPressed;
  final String? cancelButtonText;
  final VoidCallback? onCancelPressed;
  final bool showCloseIcon;
  final VoidCallback? onClosePressed;

  const AppDialog({
    required this.title,
    this.content,
    this.contentWidget,
    this.cancelButtonText,
    this.actionButtonText,
    this.onActionPressed,
    this.onCancelPressed,
    this.showCloseIcon = false,
    this.onClosePressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = context.theme;
    final TextStyle titleStyle =
        theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600) ??
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 20);
    final TextStyle? contentStyle = theme.textTheme.bodyMedium;

    final Widget? actions = _buildActions(context);

    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      title: showCloseIcon
          ? _DialogTitle(
              title: title,
              titleStyle: titleStyle,
              onClosePressed: onClosePressed,
            )
          : Text(title, style: titleStyle),
      content: _buildContent(contentStyle),
      actions: actions != null ? <Widget>[actions] : null,
    );
  }

  Widget? _buildContent(TextStyle? contentStyle) {
    if (content == null && contentWidget == null) return null;
    if (content != null && contentWidget == null) {
      return Text(content!, style: contentStyle);
    }
    if (content == null && contentWidget != null) return contentWidget;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(content!, style: contentStyle),
        const SizedBox(height: 12),
        contentWidget!,
      ],
    );
  }

  Widget? _buildActions(BuildContext context) {
    final bool hasCancel = cancelButtonText != null;
    final bool hasAction = actionButtonText != null;

    if (!hasCancel && !hasAction) {
      return null;
    }

    if (hasCancel && hasAction) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _PrimaryButton(
            label: actionButtonText!,
            onPressed: onActionPressed ?? () => Navigator.of(context).pop(),
          ),
          const SizedBox(height: 12),
          _CancelButton(
            label: cancelButtonText!,
            onPressed: onCancelPressed ?? () => Navigator.of(context).pop(),
          ),
        ],
      );
    }

    if (hasCancel) {
      return _CancelButton(
        label: cancelButtonText!,
        onPressed: onCancelPressed ?? () => Navigator.of(context).pop(),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: _PrimaryButton(
        label: actionButtonText!,
        onPressed: onActionPressed ?? () => Navigator.of(context).pop(),
      ),
    );
  }
}

class _DialogTitle extends StatelessWidget {
  final String title;
  final TextStyle titleStyle;
  final VoidCallback? onClosePressed;

  const _DialogTitle({
    required this.title,
    required this.titleStyle,
    this.onClosePressed,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor =
        context.theme.customColors.textColor?.getShade(200) ??
            context.theme.colorScheme.onSurfaceVariant;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: titleStyle,
          ),
        ),
        IconButton(
          onPressed: onClosePressed ?? () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.close_rounded,
            color: iconColor,
            size: 20,
          ),
          padding: EdgeInsets.zero,
          splashRadius: 20,
          constraints: const BoxConstraints.tightFor(width: 32, height: 32),
        ),
      ],
    );
  }
}

class _CancelButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _CancelButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: TextButton(
          style: context.theme.extension<AppButtonsStyle>()?.textButton,
          onPressed: onPressed,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: context.theme.customTextStyles.buttonMedium.copyWith(
              color: context.theme.customColors.textColor!.getShade(300),
            ),
          ),
        ),
      );
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _PrimaryButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: onPressed,
          style: context.theme.extension<AppButtonsStyle>()?.filledButton,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: context.theme.customTextStyles.buttonMedium.copyWith(
              color: context.theme.customColors.textColor!.getShade(100),
            ),
          ),
        ),
      );
}
