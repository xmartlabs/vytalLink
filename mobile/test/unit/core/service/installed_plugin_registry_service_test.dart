import 'package:flutter_template/core/model/installed_plugin.dart';
import 'package:flutter_template/core/service/installed_plugin_registry_service.dart';
import 'package:flutter_template/core/service/plugin_registry_storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('InstalledPluginRegistryService', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('installs a plugin from its manifest and resolves relative urls',
        () async {
      final service = InstalledPluginRegistryService(
        storageService: PluginRegistryStorageService(),
        manifestLoader: (_) async => {
          'plugin_id': 'chatgpt',
          'name': 'ChatGPT',
          'description': 'ChatGPT flow',
          'icon_url': '/favicon.svg',
          'entry_url':
              'https://chatgpt.com/g/g-68c2fb58447c8191b5af624f6b33bdd6-vytallink',
          'allowed_return_origins': [
            'https://vytallink.web.app',
            'vytallink://connect/chatgpt/callback',
          ],
          'manifest_version': '1.0.0',
          'supports_connect_flow': true,
          'supports_word_pin_fallback': true,
        },
      );

      final installedPlugin = await service.installPluginFromManifestUri(
        Uri.parse('https://vytallink.web.app/install/chatgpt/manifest.json'),
      );

      expect(installedPlugin.pluginId, 'chatgpt');
      expect(
        installedPlugin.iconUrl,
        'https://vytallink.web.app/favicon.svg',
      );
      expect(
        installedPlugin.entryUrl,
        'https://chatgpt.com/g/g-68c2fb58447c8191b5af624f6b33bdd6-vytallink',
      );
      expect(
        installedPlugin.allowedReturnOrigins,
        [
          'https://vytallink.web.app',
          'vytallink://connect/chatgpt/callback',
        ],
      );
      expect(installedPlugin.supportsConnectFlow, isTrue);
      expect(installedPlugin.supportsWordPinFallback, isTrue);

      final savedPlugin = await service.findInstalledPluginById('chatgpt');
      expect(savedPlugin, installedPlugin);
    });

    test('preserves installedAt when the manifest is reinstalled', () async {
      final storageService = PluginRegistryStorageService();
      final originalInstalledAt = DateTime.utc(2026, 3, 30, 12);
      await storageService.upsertInstalledPlugin(
        InstalledPlugin(
          pluginId: 'chatgpt',
          name: 'ChatGPT',
          description: 'Old install',
          iconUrl: 'https://vytallink.web.app/favicon.svg',
          manifestUrl:
              'https://vytallink.web.app/install/chatgpt/manifest.json',
          entryUrl:
              'https://chatgpt.com/g/g-68c2fb58447c8191b5af624f6b33bdd6-vytallink',
          allowedReturnOrigins: const ['https://vytallink.web.app'],
          installedAt: originalInstalledAt,
          updatedAt: originalInstalledAt,
        ),
      );

      final service = InstalledPluginRegistryService(
        storageService: storageService,
        manifestLoader: (_) async => {
          'plugin_id': 'chatgpt',
          'name': 'ChatGPT',
          'description': 'New install',
          'icon_url': '/favicon.svg',
          'entry_url':
              'https://chatgpt.com/g/g-68c2fb58447c8191b5af624f6b33bdd6-vytallink',
        },
      );

      final reinstalledPlugin = await service.installPluginFromManifestUri(
        Uri.parse('https://vytallink.web.app/install/chatgpt/manifest.json'),
      );

      expect(reinstalledPlugin.installedAt, originalInstalledAt);
      expect(reinstalledPlugin.updatedAt, isNot(originalInstalledAt));
      expect(reinstalledPlugin.description, 'New install');
    });
  });
}
