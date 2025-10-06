import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_tabs;
import 'package:flutter_template/core/common/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherHelper {
  static Future<void> launch(String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      try {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } catch (e2) {
        await launchUrl(uri, mode: LaunchMode.inAppWebView);
      }
    }
  }

  static Future<void> launchInApp(String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.inAppWebView);
    } catch (e) {
      try {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } catch (e2) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  static Future<void> launchInBrowserView(String url) async {
    final uri = Uri.parse(url);
    try {
      await custom_tabs.launchUrl(
        uri,
        customTabsOptions: custom_tabs.CustomTabsOptions(
          browser: const custom_tabs.CustomTabsBrowserConfiguration(
            prefersDefaultBrowser: true,
          ),
          colorSchemes: custom_tabs.CustomTabsColorSchemes.defaults(),
          urlBarHidingEnabled: true,
          showTitle: true,
          shareIdentityEnabled: false,
        ),
        safariVCOptions: const custom_tabs.SafariViewControllerOptions(
          barCollapsingEnabled: true,
          dismissButtonStyle:
              custom_tabs.SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (error, stackTrace) {
      Logger.e(
        'Failed to launch Custom Tabs: $url',
        error,
        stackTrace,
      );

      try {
        await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      } catch (e2) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }
}
