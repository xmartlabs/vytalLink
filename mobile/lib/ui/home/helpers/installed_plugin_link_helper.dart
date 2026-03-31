enum InstalledPluginFallback {
  wordPin,
}

class InstalledPluginFlow {
  final String pluginId;
  final Uri installUri;
  final Uri callbackUri;
  final Uri manifestUri;
  final InstalledPluginFallback fallback;

  const InstalledPluginFlow({
    required this.pluginId,
    required this.installUri,
    required this.callbackUri,
    required this.manifestUri,
    required this.fallback,
  });
}

class InstalledPluginLinkHelper {
  static const String chatGptPluginId = 'chatgpt';

  static InstalledPluginFlow chatGpt({
    required String landingUrl,
  }) {
    final baseUri = Uri.parse(landingUrl);
    final baseSegments = baseUri.pathSegments
        .where((segment) => segment.isNotEmpty)
        .toList(growable: false);
    final manifestUri = baseUri.replace(
      pathSegments: [...baseSegments, 'install', 'chatgpt', 'manifest.json'],
      queryParameters: null,
    );

    return InstalledPluginFlow(
      pluginId: chatGptPluginId,
      installUri: baseUri.replace(
        pathSegments: [...baseSegments, 'install', 'chatgpt'],
        queryParameters: {
          'manifest': manifestUri.toString(),
          'source': 'mobile_app',
        },
      ),
      callbackUri: baseUri.replace(
        pathSegments: [...baseSegments, 'connect', 'chatgpt', 'callback'],
        queryParameters: null,
      ),
      manifestUri: manifestUri,
      fallback: InstalledPluginFallback.wordPin,
    );
  }
}
