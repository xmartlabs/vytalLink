import 'package:flutter_template/core/model/installed_plugin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InstalledPlugin', () {
    test('serializes to JSON with all supported fields', () {
      final plugin = InstalledPlugin(
        pluginId: 'athletic-analyst',
        name: 'Athletic Analyst',
        description: 'Training-focused plugin',
        iconUrl: 'https://example.com/icon.png',
        manifestUrl: 'https://example.com/plugin.json',
        entryUrl: 'https://example.com/app',
        allowedReturnOrigins: const [
          'https://example.com',
          'https://staging.example.com',
        ],
        manifestVersion: '1.0.0',
        supportsConnectFlow: true,
        supportsWordPinFallback: true,
        installedAt: DateTime(2026, 3, 30, 12),
        updatedAt: DateTime(2026, 3, 31, 8, 30),
      );

      final json = plugin.toJson();

      expect(json['plugin_id'], 'athletic-analyst');
      expect(json['name'], 'Athletic Analyst');
      expect(json['description'], 'Training-focused plugin');
      expect(json['icon_url'], 'https://example.com/icon.png');
      expect(json['manifest_url'], 'https://example.com/plugin.json');
      expect(json['entry_url'], 'https://example.com/app');
      expect(
        json['allowed_return_origins'],
        ['https://example.com', 'https://staging.example.com'],
      );
      expect(json['manifest_version'], '1.0.0');
      expect(json['supports_connect_flow'], isTrue);
      expect(json['supports_word_pin_fallback'], isTrue);
      expect(json['installed_at'], '2026-03-30T12:00:00.000');
      expect(json['updated_at'], '2026-03-31T08:30:00.000');
    });

    test('deserializes from JSON', () {
      final plugin = InstalledPlugin.fromJson({
        'plugin_id': 'sleep-coach',
        'name': 'Sleep Coach',
        'description': 'Sleep-focused plugin',
        'icon_url': 'https://example.com/sleep.png',
        'manifest_url': 'https://example.com/sleep.json',
        'entry_url': 'https://example.com/sleep',
        'allowed_return_origins': ['https://example.com'],
        'supports_connect_flow': false,
        'supports_word_pin_fallback': true,
        'installed_at': '2026-03-29T10:15:00.000',
        'updated_at': '2026-03-29T10:15:00.000',
      });

      expect(plugin.pluginId, 'sleep-coach');
      expect(plugin.name, 'Sleep Coach');
      expect(plugin.allowedReturnOrigins, ['https://example.com']);
      expect(plugin.supportsConnectFlow, isFalse);
      expect(plugin.supportsWordPinFallback, isTrue);
      expect(plugin.installedAt, DateTime(2026, 3, 29, 10, 15));
      expect(plugin.updatedAt, DateTime(2026, 3, 29, 10, 15));
    });

    test('supports equality and copyWith updates', () {
      final plugin = InstalledPlugin(
        pluginId: 'training-lab',
        name: 'Training Lab',
        description: 'Coach plugin',
        iconUrl: 'https://example.com/training.png',
        manifestUrl: 'https://example.com/training.json',
        entryUrl: 'https://example.com/training',
        allowedReturnOrigins: const ['https://example.com'],
        installedAt: DateTime(2026, 3, 30, 9),
        updatedAt: DateTime(2026, 3, 30, 9),
      );

      final updated = plugin.copyWith(
        name: 'Training Lab Pro',
        updatedAt: DateTime(2026, 3, 31, 11),
      );

      expect(
        updated,
        isNot(
          plugin,
        ),
      );
      expect(updated.name, 'Training Lab Pro');
      expect(updated.updatedAt, DateTime(2026, 3, 31, 11));
      expect(
        plugin.copyWith(),
        plugin,
      );
    });
  });
}
