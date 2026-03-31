import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_template/ui/router/deep_link_coordinator.dart';
import 'package:flutter_template/ui/router/deep_link_parser.dart';

void main() {
  group('DeepLinkParser', () {
    const parser = DeepLinkParser(
      allowedHosts: {
        'vytallink.web.app',
        'vytallink.xmartlabs.com',
      },
    );

    test('parses custom scheme install callbacks', () {
      final result = parser.parse(
        Uri.parse('vytallink://plugin/install?source=claude'),
      );

      expect(result, isNotNull);
      expect(result!.action, DeepLinkAction.pluginInstall);
      expect(result.pluginId, isNull);
      expect(result.manifestUri, isNull);
    });

    test('parses universal link connect callbacks from action query', () {
      final result = parser.parse(
        Uri.parse(
          'https://vytallink.web.app/connect/chatgpt/callback?action=connect&code=123',
        ),
      );

      expect(result, isNotNull);
      expect(result!.action, DeepLinkAction.pluginConnect);
      expect(result.pluginId, 'chatgpt');
      expect(
        result.manifestUri,
        Uri.parse('https://vytallink.web.app/install/chatgpt/manifest.json'),
      );
    });

    test('parses explicit manifest query from install links', () {
      final result = parser.parse(
        Uri.parse(
          'https://vytallink.web.app/install/chatgpt?manifest=%2Finstall%2Fchatgpt%2Fmanifest.json',
        ),
      );

      expect(result, isNotNull);
      expect(result!.action, DeepLinkAction.pluginInstall);
      expect(result.pluginId, 'chatgpt');
      expect(
        result.manifestUri,
        Uri.parse('https://vytallink.web.app/install/chatgpt/manifest.json'),
      );
    });

    test('ignores unrelated urls even on allowed hosts', () {
      expect(
        parser.parse(Uri.parse('https://vytallink.web.app/about')),
        isNull,
      );
    });

    test('ignores urls from unsupported hosts', () {
      expect(
        parser.parse(
          Uri.parse('https://example.com/plugin/callback?action=install'),
        ),
        isNull,
      );
    });
  });

  group('DeepLinkCoordinator', () {
    late _FakeDeepLinkSource source;
    late _RecordingDeepLinkNavigator navigator;
    late DeepLinkCoordinator coordinator;

    setUp(() {
      source = _FakeDeepLinkSource(
        pendingLinks: [
          Uri.parse('vytallink://plugin/install?source=claude'),
        ],
      );
      navigator = _RecordingDeepLinkNavigator();
      coordinator = DeepLinkCoordinator(
        parser: const DeepLinkParser(
          allowedHosts: {
            'vytallink.web.app',
            'vytallink.xmartlabs.com',
          },
        ),
        source: source,
        navigator: navigator,
      );
    });

    tearDown(() {
      coordinator.dispose();
      source.dispose();
    });

    test('routes pending links on startup and listens for later ones',
        () async {
      await coordinator.start();

      expect(navigator.links.map((link) => link.action), [
        DeepLinkAction.pluginInstall,
      ]);

      source.emit(
        Uri.parse(
          'https://vytallink.web.app/connect/chatgpt/callback?action=connect',
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(
        navigator.links.map((link) => link.action),
        [
          DeepLinkAction.pluginInstall,
          DeepLinkAction.pluginConnect,
        ],
      );
      expect(navigator.links.last.pluginId, 'chatgpt');
    });

    test('ignores links that do not match the callback contract', () async {
      source = _FakeDeepLinkSource(
        pendingLinks: [
          Uri.parse('https://vytallink.web.app/about'),
        ],
      );
      navigator = _RecordingDeepLinkNavigator();
      coordinator = DeepLinkCoordinator(
        parser: const DeepLinkParser(
          allowedHosts: {
            'vytallink.web.app',
            'vytallink.xmartlabs.com',
          },
        ),
        source: source,
        navigator: navigator,
      );

      await coordinator.start();

      expect(navigator.links, isEmpty);
    });
  });
}

class _FakeDeepLinkSource implements DeepLinkSource {
  _FakeDeepLinkSource({
    List<Uri>? pendingLinks,
  }) : _pendingLinks = pendingLinks ?? const [];

  final List<Uri> _pendingLinks;
  final StreamController<Uri> _controller = StreamController<Uri>.broadcast();

  @override
  Future<List<Uri>> activate() async => List<Uri>.of(_pendingLinks);

  @override
  Stream<Uri> get links => _controller.stream;

  void emit(Uri uri) => _controller.add(uri);

  @override
  void dispose() {
    unawaited(_controller.close());
  }
}

class _RecordingDeepLinkNavigator implements DeepLinkNavigator {
  final List<ParsedDeepLink> links = <ParsedDeepLink>[];

  @override
  Future<void> open(ParsedDeepLink link) async {
    links.add(link);
  }
}
