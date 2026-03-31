import 'dart:async';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/ui/helpers/url_launcher_helper.dart';

Future<void> launchPluginInBrowserView({
  required BuildContext context,
  required String url,
  String? clipboardValue,
  String? copiedMessage,
  Duration copiedMessageDuration = const Duration(milliseconds: 300),
}) async {
  if (clipboardValue != null) {
    await Clipboard.setData(ClipboardData(text: clipboardValue));
  }

  if (!context.mounted) return;

  if (copiedMessage != null) {
    final theme = context.theme;
    await _showLaunchSnack(
      context: context,
      options: (
        message: copiedMessage,
        background: theme.customColors.success ?? theme.colorScheme.primary,
        textColor: Colors.white,
        duration: copiedMessageDuration,
      ),
    );
  }

  await UrlLauncherHelper.launchInBrowserView(url);
}

Future<void> showPluginLaunchErrorSnack(BuildContext context, String message) =>
    _showLaunchSnack(
      context: context,
      options: (
        message: message,
        background:
            context.theme.colorScheme.errorContainer.withValues(alpha: 0.95),
        textColor: context.theme.colorScheme.onErrorContainer,
        duration: const Duration(seconds: 3),
      ),
    );

Future<void> _showLaunchSnack({
  required BuildContext context,
  required _SnackOptions options,
}) async {
  final theme = context.theme;
  final messenger = ScaffoldMessenger.of(context);
  final effectiveTextColor = options.textColor ?? theme.colorScheme.onSurface;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          options.message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: effectiveTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: options.background,
        duration: options.duration,
      ),
    );
  await Future.delayed(options.duration);
}

typedef _SnackOptions = ({
  String message,
  Color background,
  Color? textColor,
  Duration duration,
});
