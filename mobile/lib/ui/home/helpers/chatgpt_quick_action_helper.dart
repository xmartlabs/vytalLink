import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/common/config.dart';
import 'package:flutter_template/core/di/di_provider.dart';
import 'package:flutter_template/core/model/mcp_connection_state.dart';
import 'package:flutter_template/core/service/installed_plugin_registry_service.dart';
import 'package:flutter_template/core/service/shared_preference_service.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';
import 'package:flutter_template/ui/home/helpers/installed_plugin_link_helper.dart';
import 'package:flutter_template/ui/home/helpers/plugin_launcher_helper.dart';
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

Future<void> launchChatGptInstalledPluginFlow({
  required BuildContext context,
  required BridgeCredentials? credentials,
  Future<BridgeCredentials?> Function()? connectCallback,
}) async {
  final BridgeCredentials? activeCredentials = await _loadActiveCredentials(
    context: context,
    initialCredentials: credentials,
    connectCallback: connectCallback,
  );

  if (!context.mounted || activeCredentials == null) return;

  final installFlow = InstalledPluginLinkHelper.chatGpt(
    landingUrl: Config.landingUrl,
  );
  final installedPlugin = await DiProvider.get<InstalledPluginRegistryService>()
      .findInstalledPluginById(
    installFlow.pluginId,
  );
  if (!context.mounted) return;

  await _copyCredentialsAndLaunch(
    context,
    activeCredentials,
    destinationUrl:
        installedPlugin?.entryUrl ?? installFlow.installUri.toString(),
  );
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
  if (connectCallback == null) {
    if (!context.mounted) return null;
    await _showMissingCredentialsSnack(context);
    return null;
  }

  if (initialCredentials != null) {
    return connectCallback();
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
  BridgeCredentials credentials, {
  String? destinationUrl,
}) async {
  final localizations = context.localizations;
  await launchPluginInBrowserView(
    context: context,
    url: destinationUrl ?? Config.gptIntegrationUrl,
    clipboardValue: localizations.home_clipboard_credentials_template(
      credentials.connectionWord,
      credentials.connectionPin,
    ),
    copiedMessage: localizations.home_snackbar_credentials_copied,
  );
}

Future<void> _showMissingCredentialsSnack(BuildContext context) =>
    showPluginLaunchErrorSnack(
      context,
      context.localizations.home_toast_credentials_missing,
    );
