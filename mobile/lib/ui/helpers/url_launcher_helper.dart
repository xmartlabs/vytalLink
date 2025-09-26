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
}
