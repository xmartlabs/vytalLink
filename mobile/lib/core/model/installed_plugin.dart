import 'package:freezed_annotation/freezed_annotation.dart';

part 'installed_plugin.freezed.dart';
part 'installed_plugin.g.dart';

@freezed
class InstalledPlugin with _$InstalledPlugin {
  const factory InstalledPlugin({
    required String pluginId,
    required String name,
    required String description,
    required String iconUrl,
    required String manifestUrl,
    required String entryUrl,
    required DateTime installedAt,
    required DateTime updatedAt,
    @Default(<String>[]) List<String> allowedReturnOrigins,
    String? manifestVersion,
    @Default(false) bool supportsConnectFlow,
    @Default(true) bool supportsWordPinFallback,
  }) = _InstalledPlugin;

  factory InstalledPlugin.fromJson(Map<String, dynamic> json) =>
      _$InstalledPluginFromJson(json);
}
