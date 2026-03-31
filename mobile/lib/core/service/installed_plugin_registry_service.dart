import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_template/core/common/logger.dart';
import 'package:flutter_template/core/model/installed_plugin.dart';
import 'package:flutter_template/core/model/plugin_manifest.dart';
import 'package:flutter_template/core/service/plugin_registry_storage_service.dart';

typedef PluginManifestLoader = Future<Map<String, dynamic>> Function(
  Uri manifestUri,
);

class InstalledPluginRegistryService {
  InstalledPluginRegistryService({
    PluginRegistryStorageService? storageService,
    PluginManifestLoader? manifestLoader,
  })  : _storageService = storageService ?? PluginRegistryStorageService(),
        _manifestLoader = manifestLoader ?? _defaultManifestLoader;

  final PluginRegistryStorageService _storageService;
  final PluginManifestLoader _manifestLoader;

  Future<InstalledPlugin?> findInstalledPluginById(String pluginId) =>
      _storageService.findInstalledPluginById(pluginId);

  Future<List<InstalledPlugin>> loadInstalledPlugins() =>
      _storageService.loadInstalledPlugins();

  Future<InstalledPlugin> installPluginFromManifestUri(Uri manifestUri) async {
    final manifestJson = await _manifestLoader(manifestUri);
    final manifest = PluginManifest.fromJson(manifestJson);
    final existingPlugin = await _storageService.findInstalledPluginById(
      manifest.pluginId,
    );
    final now = DateTime.now().toUtc();

    final installedPlugin = InstalledPlugin(
      pluginId: manifest.pluginId,
      name: manifest.name,
      description: manifest.description,
      iconUrl: _resolveUrl(manifestUri, manifest.iconUrl),
      manifestUrl: manifestUri.toString(),
      entryUrl: _resolveUrl(manifestUri, manifest.entryUrl),
      allowedReturnOrigins: manifest.allowedReturnOrigins
          .map((origin) => _normalizeOrigin(manifestUri, origin))
          .toList(growable: false),
      manifestVersion: manifest.manifestVersion,
      supportsConnectFlow: manifest.supportsConnectFlow,
      supportsWordPinFallback: manifest.supportsWordPinFallback,
      installedAt: existingPlugin?.installedAt ?? now,
      updatedAt: now,
    );

    await _storageService.upsertInstalledPlugin(installedPlugin);
    Logger.i('Installed plugin ${installedPlugin.pluginId} from $manifestUri');

    return installedPlugin;
  }

  static Future<Map<String, dynamic>> _defaultManifestLoader(
    Uri manifestUri,
  ) async {
    final response = await Dio().getUri<dynamic>(manifestUri);
    final data = response.data;

    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is String) {
      return jsonDecode(data) as Map<String, dynamic>;
    }

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    throw const FormatException('Unsupported plugin manifest payload.');
  }

  static String _resolveUrl(Uri manifestUri, String value) =>
      manifestUri.resolve(value).toString();

  static String _normalizeOrigin(Uri manifestUri, String value) {
    final resolvedUri = manifestUri.resolve(value);

    if (resolvedUri.scheme == 'http' || resolvedUri.scheme == 'https') {
      return Uri(
        scheme: resolvedUri.scheme,
        host: resolvedUri.host,
        port: resolvedUri.hasPort ? resolvedUri.port : null,
      ).toString();
    }

    return resolvedUri.toString();
  }
}
