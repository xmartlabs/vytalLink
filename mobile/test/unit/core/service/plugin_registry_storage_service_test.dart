import 'package:flutter_template/core/model/installed_plugin.dart';
import 'package:flutter_template/core/service/plugin_registry_storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('PluginRegistryStorageService', () {
    late PluginRegistryStorageService service;

    InstalledPlugin createPlugin({
      required String pluginId,
      required String name,
      DateTime? updatedAt,
    }) =>
        InstalledPlugin(
          pluginId: pluginId,
          name: name,
          description: '$name description',
          iconUrl: 'https://example.com/$pluginId.png',
          manifestUrl: 'https://example.com/$pluginId.json',
          entryUrl: 'https://example.com/$pluginId',
          allowedReturnOrigins: const ['https://example.com'],
          supportsConnectFlow: true,
          supportsWordPinFallback: true,
          installedAt: DateTime(2026, 3, 30, 10),
          updatedAt: updatedAt ?? DateTime(2026, 3, 30, 10),
        );

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      service = PluginRegistryStorageService();
    });

    test('returns an empty list when nothing is stored', () async {
      final plugins = await service.loadInstalledPlugins();

      expect(plugins, isEmpty);
    });

    test('persists and reloads installed plugins', () async {
      final plugins = [
        createPlugin(pluginId: 'coach', name: 'Coach'),
        createPlugin(pluginId: 'planner', name: 'Planner'),
      ];

      await service.saveInstalledPlugins(plugins);

      final reloaded = await service.loadInstalledPlugins();

      expect(reloaded, plugins);
    });

    test('upserts a new plugin into storage', () async {
      final plugin = createPlugin(pluginId: 'runner', name: 'Runner');

      await service.upsertInstalledPlugin(plugin);

      final reloaded = await service.loadInstalledPlugins();
      expect(reloaded, [plugin]);
    });

    test('replaces an existing plugin with the same id on upsert', () async {
      final original = createPlugin(pluginId: 'runner', name: 'Runner');
      final updated = createPlugin(
        pluginId: 'runner',
        name: 'Runner Pro',
        updatedAt: DateTime(2026, 3, 31, 9),
      );

      await service.saveInstalledPlugins([original]);
      await service.upsertInstalledPlugin(updated);

      final reloaded = await service.loadInstalledPlugins();
      expect(reloaded, [updated]);
    });

    test('removes a plugin by id', () async {
      final plugins = [
        createPlugin(pluginId: 'coach', name: 'Coach'),
        createPlugin(pluginId: 'planner', name: 'Planner'),
      ];

      await service.saveInstalledPlugins(plugins);
      await service.removeInstalledPlugin('coach');

      final reloaded = await service.loadInstalledPlugins();
      expect(reloaded.map((plugin) => plugin.pluginId), ['planner']);
    });

    test('returns null when plugin id is not found', () async {
      await service.saveInstalledPlugins([
        createPlugin(pluginId: 'coach', name: 'Coach'),
      ]);

      final plugin = await service.findInstalledPluginById('missing');

      expect(plugin, isNull);
    });

    test('returns a plugin when looking up by id', () async {
      final plugin = createPlugin(pluginId: 'coach', name: 'Coach');
      await service.saveInstalledPlugins([plugin]);

      final found = await service.findInstalledPluginById('coach');

      expect(found, plugin);
    });
  });
}
