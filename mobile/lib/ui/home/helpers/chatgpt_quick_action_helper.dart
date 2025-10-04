import 'dart:async';

import 'dart:io' show Platform;

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_template/core/common/config.dart';
import 'package:flutter_template/core/service/shared_preference_service.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';
import 'package:flutter_template/ui/helpers/url_launcher_helper.dart';
import 'package:flutter_template/ui/home/home_cubit.dart';
import 'package:flutter_template/ui/home/screens/chatgpt_on_device_guidance_screen.dart';

Future<void> launchChatGptQuickAction({
  required BuildContext context,
  required McpServerStatus status,
  required String connectionWord,
  required String connectionPin,
  Future<bool> Function()? ensureConnected,
}) async {
  if (Platform.isIOS) {
    final preferenceService = SharedPreferenceService();
    final skipGuidance =
        await preferenceService.isChatGptOnDeviceGuidanceSkipped();
    if (!skipGuidance) {
      final guidanceResult = await _showOnDeviceGuidanceScreen(context);
      if (guidanceResult?.proceed != true) {
        return;
      }
      if (!context.mounted) return;
      if (guidanceResult?.dontShowAgain ?? false) {
        await preferenceService
            .setChatGptOnDeviceGuidanceSkipped(value: true);
      }
    }
  }

  final theme = context.theme;
  final messenger = ScaffoldMessenger.of(context);
  final cubit = context.read<HomeCubit>();

  bool hasCredentials() {
    final current = cubit.state;
    if (current.status != McpServerStatus.running) {
      return status == McpServerStatus.running &&
          connectionWord.isNotEmpty &&
          connectionPin.isNotEmpty;
    }
    if (current.connectionWord.isEmpty || current.connectionCode.isEmpty) {
      return status == McpServerStatus.running &&
          connectionWord.isNotEmpty &&
          connectionPin.isNotEmpty;
    }
    return true;
  }

  Future<void> showSnack({
    required String message,
    required Color background,
    Color? textColor,
    Duration duration = const Duration(seconds: 3),
  }) async {
    final effectiveTextColor = textColor ?? theme.colorScheme.onSurface;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: effectiveTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: background,
          duration: duration,
        ),
      );
    await Future.delayed(duration);
  }

  String word = connectionWord;
  String pin = connectionPin;
  bool waitedForCredentials = false;

  if (!hasCredentials()) {
    final ensure = ensureConnected;
    if (ensure == null || !await ensure()) {
      await showSnack(
        message: context.localizations.home_toast_credentials_missing,
        background: theme.colorScheme.errorContainer.withOpacity(0.95),
        textColor: theme.colorScheme.onErrorContainer,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    final readyState = await _waitForCredentials(cubit);
    if (readyState == null) {
      await showSnack(
        message: context.localizations.home_toast_credentials_missing,
        background: theme.colorScheme.errorContainer.withOpacity(0.95),
        textColor: theme.colorScheme.onErrorContainer,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    word = readyState.connectionWord;
    pin = readyState.connectionCode;
    waitedForCredentials = true;
  }

  final clipboardValue =
      context.localizations.home_clipboard_credentials_template(word, pin);
  await Clipboard.setData(ClipboardData(text: clipboardValue));

  await showSnack(
    message: context.localizations.home_snackbar_credentials_copied,
    background: theme.customColors.success ?? theme.colorScheme.primary,
    textColor: Colors.white,
    duration: const Duration(milliseconds: 500),
  );

  if (waitedForCredentials) {
    unawaited(_showCredentialNotification(context, word, pin));
  }

  await UrlLauncherHelper.launchInBrowserView(Config.gptIntegrationUrl);
}

Future<ChatGptOnDeviceGuidanceResult?> _showOnDeviceGuidanceScreen(
  BuildContext context,
) async {
  return Navigator.of(context).push<ChatGptOnDeviceGuidanceResult>(
    MaterialPageRoute(
      builder: (_) => const ChatGptOnDeviceGuidanceScreen(),
      fullscreenDialog: true,
    ),
  );
}

Future<HomeState?> _waitForCredentials(HomeCubit cubit) async {
  HomeState latest = cubit.state;
  bool hasCreds(HomeState state) =>
      state.status == McpServerStatus.running &&
      state.connectionWord.isNotEmpty &&
      state.connectionCode.isNotEmpty;

  if (hasCreds(latest)) return latest;

  final completer = Completer<HomeState?>();
  late final StreamSubscription<HomeState> subscription;
  subscription = cubit.stream.listen((state) {
    if (!completer.isCompleted && hasCreds(state)) {
      completer.complete(state);
    }
  });

  try {
    return await completer.future
        .timeout(const Duration(seconds: 12), onTimeout: () => null);
  } finally {
    await subscription.cancel();
  }
}

final FlutterLocalNotificationsPlugin _notificationsPlugin =
    FlutterLocalNotificationsPlugin();
bool _notificationsInitialized = false;
const AndroidNotificationChannel _bridgeChannel = AndroidNotificationChannel(
  'bridge-status',
  'Bridge status',
  description: 'Updates when VytalLink connects to ChatGPT bridge.',
  importance: Importance.high,
  playSound: true,
  enableLights: true,
  enableVibration: true,
);

Future<void> _showCredentialNotification(
  BuildContext context,
  String word,
  String pin,
) async {
  await _ensureNotificationsInitialized();

  final androidDetails = AndroidNotificationDetails(
    _bridgeChannel.id,
    _bridgeChannel.name,
    channelDescription: _bridgeChannel.description,
    importance: Importance.high,
    priority: Priority.high,
    ticker: 'bridge-ready',
  );
  const iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentSound: true,
  );

  await _notificationsPlugin.show(
    1024,
    context.localizations.home_notification_credentials_title,
    context.localizations.home_notification_credentials_body(word, pin),
    NotificationDetails(android: androidDetails, iOS: iosDetails),
  );
}

Future<void> _ensureNotificationsInitialized() async {
  if (_notificationsInitialized) return;

  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosInit = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  await _notificationsPlugin.initialize(
    const InitializationSettings(android: androidInit, iOS: iosInit),
  );

  final androidPlatform = _notificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
  await androidPlatform?.createNotificationChannel(_bridgeChannel);
  await androidPlatform?.requestNotificationsPermission();

  await _notificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(alert: true, badge: true, sound: true);

  _notificationsInitialized = true;
}
