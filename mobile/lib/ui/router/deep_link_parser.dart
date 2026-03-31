enum DeepLinkAction {
  pluginInstall,
  pluginConnect,
}

class ParsedDeepLink {
  const ParsedDeepLink({
    required this.action,
    required this.uri,
    this.pluginId,
    this.manifestUri,
  });

  final DeepLinkAction action;
  final Uri uri;
  final String? pluginId;
  final Uri? manifestUri;
}

class DeepLinkParser {
  const DeepLinkParser({
    required this.allowedHosts,
  });

  final Set<String> allowedHosts;

  ParsedDeepLink? parse(Uri uri) {
    if (!_supports(uri)) return null;

    final action = _parseAction(uri);
    if (action == null) return null;
    final pluginId = _parsePluginId(uri);

    return ParsedDeepLink(
      action: action,
      uri: uri,
      pluginId: pluginId,
      manifestUri: _parseManifestUri(
        uri: uri,
        pluginId: pluginId,
      ),
    );
  }

  bool _supports(Uri uri) {
    if (uri.scheme.toLowerCase() == 'vytallink') return true;

    final scheme = uri.scheme.toLowerCase();
    if (scheme != 'https' && scheme != 'http') return false;

    return allowedHosts.contains(uri.host.toLowerCase());
  }

  DeepLinkAction? _parseAction(Uri uri) {
    final explicitAction = _parseExplicitAction(uri);
    if (explicitAction != null) return explicitAction;

    final tokens = _collectTokens(uri);
    if (tokens.isEmpty) return null;

    final hasCallbackContext = uri.scheme.toLowerCase() == 'vytallink' ||
        tokens.contains('plugin') ||
        tokens.contains('callback') ||
        tokens.contains('return') ||
        tokens.contains('install') ||
        tokens.contains('connect');

    if (!hasCallbackContext) return null;

    if (tokens.contains('install') || tokens.contains('installed')) {
      return DeepLinkAction.pluginInstall;
    }

    if (tokens.contains('connect') || tokens.contains('connected')) {
      return DeepLinkAction.pluginConnect;
    }

    return null;
  }

  DeepLinkAction? _parseExplicitAction(Uri uri) {
    final queryValues = [
      uri.queryParameters['action'],
      uri.queryParameters['plugin_action'],
      uri.queryParameters['callback'],
      uri.queryParameters['type'],
    ];

    for (final value in queryValues) {
      final action = _matchAction(value);
      if (action != null) return action;
    }

    return null;
  }

  DeepLinkAction? _matchAction(String? value) {
    if (value == null || value.isEmpty) return null;

    final tokens = _tokenize(value);
    if (tokens.contains('install') || tokens.contains('installed')) {
      return DeepLinkAction.pluginInstall;
    }
    if (tokens.contains('connect') || tokens.contains('connected')) {
      return DeepLinkAction.pluginConnect;
    }

    return null;
  }

  Set<String> _collectTokens(Uri uri) => {
        ...uri.pathSegments.expand(_tokenize),
        ...uri.queryParametersAll.entries.expand(
          (entry) => [
            ..._tokenize(entry.key),
            ...entry.value.expand(_tokenize),
          ],
        ),
        ..._tokenize(uri.fragment),
        ..._tokenize(uri.host),
      };

  Iterable<String> _tokenize(String value) => value
      .toLowerCase()
      .split(RegExp('[^a-z0-9]+'))
      .where((token) => token.isNotEmpty);

  String? _parsePluginId(Uri uri) {
    for (final key in const ['plugin_id', 'pluginId', 'plugin']) {
      final value = uri.queryParameters[key];
      if (value != null && value.isNotEmpty) {
        return value;
      }
    }

    final pathSegments = uri.pathSegments
        .where((segment) => segment.isNotEmpty)
        .toList(growable: false);

    for (final marker in const ['install', 'connect']) {
      final markerIndex = pathSegments.indexOf(marker);
      if (markerIndex == -1) continue;

      final pluginIndex = markerIndex + 1;
      if (pluginIndex < pathSegments.length) {
        final candidate = pathSegments[pluginIndex];
        if (candidate != 'callback' && candidate != 'return') {
          return candidate;
        }
      }
    }

    return null;
  }

  Uri? _parseManifestUri({
    required Uri uri,
    required String? pluginId,
  }) {
    for (final key in const ['manifest', 'manifest_url', 'manifestUrl']) {
      final manifest = uri.queryParameters[key];
      if (manifest != null && manifest.isNotEmpty) {
        return uri.resolve(manifest);
      }
    }

    final scheme = uri.scheme.toLowerCase();
    if ((scheme != 'http' && scheme != 'https') || pluginId == null) {
      return null;
    }

    final pathSegments = uri.pathSegments
        .where((segment) => segment.isNotEmpty)
        .toList(growable: false);
    final installIndex = pathSegments.indexOf('install');
    final connectIndex = pathSegments.indexOf('connect');
    final markerIndex = installIndex >= 0 ? installIndex : connectIndex;
    if (markerIndex < 0) return null;

    return Uri(
      scheme: uri.scheme,
      userInfo: uri.userInfo,
      host: uri.host,
      port: uri.hasPort ? uri.port : null,
      pathSegments: [
        ...pathSegments.take(markerIndex),
        'install',
        pluginId,
        'manifest.json',
      ],
    );
  }
}
