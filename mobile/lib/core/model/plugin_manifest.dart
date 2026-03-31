import 'package:freezed_annotation/freezed_annotation.dart';

part 'plugin_manifest.freezed.dart';
part 'plugin_manifest.g.dart';

@freezed
class PluginManifest with _$PluginManifest {
  const factory PluginManifest({
    required String pluginId,
    required String name,
    required String description,
    required String iconUrl,
    required String entryUrl,
    @Default(<String>[]) List<String> allowedReturnOrigins,
    String? manifestVersion,
    @Default(false) bool supportsConnectFlow,
    @Default(true) bool supportsWordPinFallback,
  }) = _PluginManifest;

  factory PluginManifest.fromJson(Map<String, dynamic> json) =>
      _$PluginManifestFromJson(json);
}
