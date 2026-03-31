import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/common/analytics_manager.dart';
import 'package:flutter_template/core/common/config.dart';
import 'package:flutter_template/core/common/logger.dart';
import 'package:flutter_template/core/di/di_provider.dart';
import 'package:flutter_template/core/service/installed_plugin_registry_service.dart';
import 'package:flutter_template/core/service/server/mcp_background_service.dart';
import 'package:flutter_template/ui/router/app_router.dart';
import 'package:flutter_template/ui/router/deep_link_coordinator.dart';
import 'package:flutter_template/ui/router/deep_link_parser.dart';
import 'package:flutter_template/ui/router/platform_deep_link_source.dart';
import 'package:flutter_template/ui/router/router_deep_link_navigator.dart';
import 'package:flutter_template/ui/main/main_screen.dart';

Future main() async {
  await runZonedGuarded(
    () async {
      final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
      await initSdks();
      runApp(const MyApp());
      FlutterNativeSplash.remove();
    },
    (exception, stackTrace) =>
        Logger.fatal(error: exception, stackTrace: stackTrace),
  );
}

@visibleForTesting
Future initSdks() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Logger.init();
  await AnalyticsManager.setCollectionEnabled(
    Config.firebaseCollectEventsEnabled,
  );
  await Config.initialize();
  if (Config.useForegroundService) {
    await McpBackgroundService.ensureServiceStoppedIfStale();
  }
  await Future.wait([
    DiProvider.init(),
  ]);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final DeepLinkCoordinator _deepLinkCoordinator;

  @override
  void initState() {
    super.initState();
    final router = DiProvider.get<AppRouter>();
    final allowedHosts = {
      Uri.parse(Config.landingUrl).host.toLowerCase(),
      'vytallink.xmartlabs.com',
    };

    _deepLinkCoordinator = DeepLinkCoordinator(
      parser: DeepLinkParser(allowedHosts: allowedHosts),
      source: PlatformDeepLinkSource(),
      navigator: RouterDeepLinkNavigator(
        router,
        DiProvider.get<InstalledPluginRegistryService>(),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_deepLinkCoordinator.start());
    });
  }

  @override
  void dispose() {
    _deepLinkCoordinator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: false,
        splitScreenMode: true,
        builder: (_, __) => const WithForegroundTask(
          child: MainScreen(),
        ),
      );
}
