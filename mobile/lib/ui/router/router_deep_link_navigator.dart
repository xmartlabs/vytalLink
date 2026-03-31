import 'package:flutter_template/core/common/logger.dart';
import 'package:flutter_template/core/service/installed_plugin_registry_service.dart';
import 'package:flutter_template/ui/router/app_router.dart';
import 'package:flutter_template/ui/router/deep_link_coordinator.dart';
import 'package:flutter_template/ui/router/deep_link_parser.dart';

class RouterDeepLinkNavigator implements DeepLinkNavigator {
  RouterDeepLinkNavigator(
    this.router,
    this.installedPluginRegistryService,
  );

  final AppRouter router;
  final InstalledPluginRegistryService installedPluginRegistryService;

  @override
  Future<void> open(ParsedDeepLink link) async {
    final manifestUri = link.manifestUri;
    if (manifestUri != null) {
      try {
        await installedPluginRegistryService.installPluginFromManifestUri(
          manifestUri,
        );
      } catch (error, stackTrace) {
        Logger.w(
          'Failed to install plugin manifest from $manifestUri',
          error,
          stackTrace,
        );
      }
    }

    switch (link.action) {
      case DeepLinkAction.pluginInstall:
        if (link.pluginId == 'chatgpt') {
          return router.navigate(
            const AuthenticatedSectionRoute(
              children: [
                ChatGptIntegrationRoute(),
              ],
            ),
          );
        }
        return router.navigate(
          const AuthenticatedSectionRoute(
            children: [
              McpIntegrationRoute(),
            ],
          ),
        );
      case DeepLinkAction.pluginConnect:
        return router.navigate(
          const AuthenticatedSectionRoute(
            children: [
              HomeRoute(),
            ],
          ),
        );
    }
  }
}
