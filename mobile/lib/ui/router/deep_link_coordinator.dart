import 'dart:async';

import 'package:flutter_template/ui/router/deep_link_parser.dart';

abstract interface class DeepLinkSource {
  Future<List<Uri>> activate();

  Stream<Uri> get links;

  void dispose();
}

abstract interface class DeepLinkNavigator {
  Future<void> open(ParsedDeepLink link);
}

class DeepLinkCoordinator {
  DeepLinkCoordinator({
    required this.parser,
    required this.source,
    required this.navigator,
  });

  final DeepLinkParser parser;
  final DeepLinkSource source;
  final DeepLinkNavigator navigator;

  StreamSubscription<Uri>? _linkSubscription;
  bool _started = false;

  Future<void> start() async {
    if (_started) return;
    _started = true;

    _linkSubscription = source.links.listen((uri) {
      unawaited(_handle(uri));
    });

    final pendingLinks = await source.activate();
    for (final uri in pendingLinks) {
      await _handle(uri);
    }
  }

  void dispose() {
    unawaited(_linkSubscription?.cancel() ?? Future<void>.value());
    source.dispose();
  }

  Future<void> _handle(Uri uri) async {
    final parsedLink = parser.parse(uri);
    if (parsedLink == null) return;

    await navigator.open(parsedLink);
  }
}
