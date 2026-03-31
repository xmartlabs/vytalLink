import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_template/core/common/logger.dart';
import 'package:flutter_template/ui/router/deep_link_coordinator.dart';

class PlatformDeepLinkSource implements DeepLinkSource {
  PlatformDeepLinkSource() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  static const MethodChannel _channel = MethodChannel(
    'com.xmartlabs.vytallink/deep_links',
  );

  final StreamController<Uri> _linkController =
      StreamController<Uri>.broadcast();

  @override
  Stream<Uri> get links => _linkController.stream;

  @override
  Future<List<Uri>> activate() async {
    final pendingLinks =
        await _channel.invokeListMethod<String>('activate') ?? const <String>[];

    return pendingLinks.map(_tryParse).nonNulls.toList(growable: false);
  }

  @override
  void dispose() {
    _channel.setMethodCallHandler(null);
    unawaited(_linkController.close());
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    if (call.method != 'onDeepLink') return;

    final uri = _tryParse(call.arguments as String?);
    if (uri == null) return;

    _linkController.add(uri);
  }

  Uri? _tryParse(String? rawUri) {
    if (rawUri == null || rawUri.isEmpty) return null;

    final uri = Uri.tryParse(rawUri);
    if (uri != null) return uri;

    Logger.w('Ignoring invalid deep link: $rawUri');
    return null;
  }
}
