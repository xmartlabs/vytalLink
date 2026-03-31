// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installed_plugin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InstalledPluginImpl _$$InstalledPluginImplFromJson(
        Map<String, dynamic> json) =>
    _$InstalledPluginImpl(
      pluginId: json['plugin_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconUrl: json['icon_url'] as String,
      manifestUrl: json['manifest_url'] as String,
      entryUrl: json['entry_url'] as String,
      installedAt: DateTime.parse(json['installed_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      allowedReturnOrigins: (json['allowed_return_origins'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      manifestVersion: json['manifest_version'] as String?,
      supportsConnectFlow: json['supports_connect_flow'] as bool? ?? false,
      supportsWordPinFallback:
          json['supports_word_pin_fallback'] as bool? ?? true,
    );

Map<String, dynamic> _$$InstalledPluginImplToJson(
        _$InstalledPluginImpl instance) =>
    <String, dynamic>{
      'plugin_id': instance.pluginId,
      'name': instance.name,
      'description': instance.description,
      'icon_url': instance.iconUrl,
      'manifest_url': instance.manifestUrl,
      'entry_url': instance.entryUrl,
      'installed_at': instance.installedAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'allowed_return_origins': instance.allowedReturnOrigins,
      'manifest_version': instance.manifestVersion,
      'supports_connect_flow': instance.supportsConnectFlow,
      'supports_word_pin_fallback': instance.supportsWordPinFallback,
    };
