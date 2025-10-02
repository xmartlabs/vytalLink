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
    
    // Special handling for ChatGPT URLs to force browser opening
    if (_isChatGptUrl(url)) {
      await _launchChatGptInBrowser(uri);
      return;
    }
    
    try {
      // First try with inAppBrowserView which should force Chrome Custom Tab
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.inAppBrowserView,
        browserConfiguration: const BrowserConfiguration(
          showTitle: true,
        ),
        webOnlyWindowName: '_blank',
      );
      if (launched) return;

      // If that fails, try external browser with specific browser configuration
      Logger.w('Falling back to external browser for $url');
      await launchUrl(
        uri, 
        mode: LaunchMode.externalApplication,
        browserConfiguration: const BrowserConfiguration(
          showTitle: true,
        ),
      );
    } catch (error, stackTrace) {
      Logger.e(
        'Failed to launch URL for $url',
        error,
        stackTrace,
      );
      // Last fallback - try platform default
      try {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } catch (e2) {
        Logger.e('All launch methods failed for $url', e2);
      }
    }
  }

  static bool _isChatGptUrl(String url) {
    return url.contains('chatgpt.com') || url.contains('vytallink.web.app/gpt');
  }

  static Future<void> _launchChatGptInBrowser(Uri uri) async {
    try {
      // Force external browser to avoid app interception
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.inAppBrowserView,
        browserConfiguration: const BrowserConfiguration(
          showTitle: true,
        ),
      );
      
      if (!launched) {
        Logger.w('External browser launch failed, trying inAppBrowserView for ${uri.toString()}');
        await launchUrl(
          uri,
          mode: LaunchMode.inAppBrowserView,
          browserConfiguration: const BrowserConfiguration(
            showTitle: true,
          ),
        );
      }
    } catch (error, stackTrace) {
      Logger.e(
        'Failed to launch ChatGPT URL ${uri.toString()}',
        error,
        stackTrace,
      );
      // Final fallback
      try {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } catch (e2) {
        Logger.e('All ChatGPT launch methods failed for ${uri.toString()}', e2);
      }
    }
  }
}
