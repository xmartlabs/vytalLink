// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plugin_manifest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PluginManifestImpl _$$PluginManifestImplFromJson(Map<String, dynamic> json) =>
    _$PluginManifestImpl(
      pluginId: json['plugin_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconUrl: json['icon_url'] as String,
      entryUrl: json['entry_url'] as String,
      allowedReturnOrigins: (json['allowed_return_origins'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      manifestVersion: json['manifest_version'] as String?,
      supportsConnectFlow: json['supports_connect_flow'] as bool? ?? false,
      supportsWordPinFallback:
          json['supports_word_pin_fallback'] as bool? ?? true,
    );

Map<String, dynamic> _$$PluginManifestImplToJson(
        _$PluginManifestImpl instance) =>
    <String, dynamic>{
      'plugin_id': instance.pluginId,
      'name': instance.name,
      'description': instance.description,
      'icon_url': instance.iconUrl,
      'entry_url': instance.entryUrl,
      'allowed_return_origins': instance.allowedReturnOrigins,
      'manifest_version': instance.manifestVersion,
      'supports_connect_flow': instance.supportsConnectFlow,
      'supports_word_pin_fallback': instance.supportsWordPinFallback,
    };
