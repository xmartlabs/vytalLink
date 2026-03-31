import 'dart:convert';

import 'package:flutter_template/core/model/installed_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PluginRegistryStorageService {
  static const String _installedPluginsKey = 'installed_plugins';

  Future<List<InstalledPlugin>> loadInstalledPlugins() async {
    final prefs = await SharedPreferences.getInstance();
    final storedPlugins = prefs.getStringList(_installedPluginsKey) ?? [];

    return storedPlugins
        .map(
          (plugin) => InstalledPlugin.fromJson(
            jsonDecode(plugin) as Map<String, dynamic>,
          ),
        )
        .toList(growable: false);
  }

  Future<void> saveInstalledPlugins(List<InstalledPlugin> plugins) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      _installedPluginsKey,
      plugins.map((plugin) => jsonEncode(plugin.toJson())).toList(),
    );
  }

  Future<void> upsertInstalledPlugin(InstalledPlugin plugin) async {
    final plugins = await loadInstalledPlugins();
    final updatedPlugins = [...plugins];
    final existingIndex = updatedPlugins.indexWhere(
      (installedPlugin) => installedPlugin.pluginId == plugin.pluginId,
    );

    if (existingIndex >= 0) {
      updatedPlugins[existingIndex] = plugin;
    } else {
      updatedPlugins.add(plugin);
    }

    await saveInstalledPlugins(updatedPlugins);
  }

  Future<void> removeInstalledPlugin(String pluginId) async {
    final plugins = await loadInstalledPlugins();
    await saveInstalledPlugins(
      plugins
          .where((plugin) => plugin.pluginId != pluginId)
          .toList(growable: false),
    );
  }

  Future<InstalledPlugin?> findInstalledPluginById(String pluginId) async {
    final plugins = await loadInstalledPlugins();

    for (final plugin in plugins) {
      if (plugin.pluginId == pluginId) {
        return plugin;
      }
    }

    return null;
  }
}
