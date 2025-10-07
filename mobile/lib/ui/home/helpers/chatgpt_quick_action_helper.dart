import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/core/common/config.dart';
import 'package:flutter_template/core/di/di_provider.dart';
import 'package:flutter_template/core/model/mcp_connection_state.dart';
import 'package:flutter_template/core/service/shared_preference_service.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';
import 'package:flutter_template/ui/helpers/url_launcher_helper.dart';
import 'package:flutter_template/ui/home/screens/chatgpt_on_device_guidance_screen.dart';
import 'package:flutter_template/ui/router/app_router.dart';

Future<void> launchChatGptQuickAction({
  required BuildContext context,
  required BridgeCredentials? credentials,
  Future<BridgeCredentials?> Function()? connectCallback,
}) async {
  if (!await _shouldProceedWithQuickAction(context)) return;

  if (!context.mounted) return;

  final BridgeCredentials? activeCredentials = await _loadActiveCredentials(
    context: context,
    initialCredentials: credentials,
    connectCallback: connectCallback,
  );

  if (!context.mounted) return;

  if (activeCredentials == null) return;

  await _copyCredentialsAndLaunch(context, activeCredentials);
}

Future<bool> _shouldProceedWithQuickAction(BuildContext context) async {
  final router = context.router;
  final SharedPreferenceService preferenceService = DiProvider.get();
  final skipGuidance =
      await preferenceService.isChatGptOnDeviceGuidanceSkipped();
  if (skipGuidance) return true;

  final guidanceResult = await router.push<ChatGptOnDeviceGuidanceResult>(
    const ChatGptOnDeviceGuidanceRoute(),
  );

  if (guidanceResult?.proceed != true) return false;
  if (!context.mounted) return false;

  if (guidanceResult?.dontShowAgain ?? false) {
    await preferenceService.setChatGptOnDeviceGuidanceSkipped(value: true);
  }

  return true;
}

Future<BridgeCredentials?> _loadActiveCredentials({
  required BuildContext context,
  required BridgeCredentials? initialCredentials,
  Future<BridgeCredentials?> Function()? connectCallback,
}) async {
  if (initialCredentials == null) {
    if (!context.mounted) return null;
    await _showMissingCredentialsSnack(context);
    return null;
  }

  if (connectCallback == null) {
    if (!context.mounted) return null;
    await _showMissingCredentialsSnack(context);
    return null;
  }

  final BridgeCredentials? refreshedCredentials = await connectCallback();
  if (!context.mounted) return null;

  if (refreshedCredentials == null) {
    await _showMissingCredentialsSnack(context);
    return null;
  }

  return refreshedCredentials;
}

Future<void> _copyCredentialsAndLaunch(
  BuildContext context,
  BridgeCredentials credentials,
) async {
  final localizations = context.localizations;

  final clipboardValue = localizations.home_clipboard_credentials_template(
    credentials.connectionWord,
    credentials.connectionPin,
  );
  await Clipboard.setData(ClipboardData(text: clipboardValue));

  if (!context.mounted) return;

  final theme = context.theme;
  await _showChatGptSnack(
    context: context,
    options: (
      message: localizations.home_snackbar_credentials_copied,
      background: theme.customColors.success ?? theme.colorScheme.primary,
      textColor: Colors.white,
      duration: const Duration(milliseconds: 300),
    ),
  );
  await UrlLauncherHelper.launchInBrowserView(Config.gptIntegrationUrl);
}

Future<void> _showChatGptSnack({
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

Future<void> _showMissingCredentialsSnack(BuildContext context) =>
    _showChatGptSnack(
      context: context,
      options: (
        message: context.localizations.home_toast_credentials_missing,
        background:
            context.theme.colorScheme.errorContainer.withValues(alpha: 0.95),
        textColor: context.theme.colorScheme.onErrorContainer,
        duration: const Duration(seconds: 3),
      ),
    );

typedef _SnackOptions = ({
  String message,
  Color background,
  Color? textColor,
  Duration duration,
});
