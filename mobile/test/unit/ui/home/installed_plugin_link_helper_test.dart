import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_template/ui/home/helpers/installed_plugin_link_helper.dart';

void main() {
  group('InstalledPluginLinkHelper', () {
    test('builds the ChatGPT install link under the hosted install surface',
        () {
      final flow = InstalledPluginLinkHelper.chatGpt(
        landingUrl: 'https://vytallink.com',
      );

      expect(
        flow.installUri.toString(),
        'https://vytallink.com/install/chatgpt?manifest=https%3A%2F%2Fvytallink.com%2Finstall%2Fchatgpt%2Fmanifest.json&source=mobile_app',
      );
      expect(
        flow.callbackUri.toString(),
        'https://vytallink.com/connect/chatgpt/callback',
      );
      expect(
        flow.manifestUri.toString(),
        'https://vytallink.com/install/chatgpt/manifest.json',
      );
      expect(flow.pluginId, InstalledPluginLinkHelper.chatGptPluginId);
      expect(flow.fallback, InstalledPluginFallback.wordPin);
    });

    test('preserves nested landing paths when composing flow URLs', () {
      final flow = InstalledPluginLinkHelper.chatGpt(
        landingUrl: 'https://example.com/app',
      );

      expect(
        flow.installUri.toString(),
        'https://example.com/app/install/chatgpt?manifest=https%3A%2F%2Fexample.com%2Fapp%2Finstall%2Fchatgpt%2Fmanifest.json&source=mobile_app',
      );
      expect(
        flow.callbackUri.toString(),
        'https://example.com/app/connect/chatgpt/callback',
      );
      expect(
        flow.manifestUri.toString(),
        'https://example.com/app/install/chatgpt/manifest.json',
      );
    });
  });
}
