// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_template/core/common/environments.dart';
import 'package:flutter_template/core/common/extension/string_extensions.dart';
import 'package:flutter_template/core/common/helper/enum_helpers.dart';
import 'package:flutter_template/core/common/helper/env_helper.dart';
import 'package:path_provider/path_provider.dart';

interface class Config {
  // MCP Client download URLs (not from env)
  static const String claudeDesktopDownloadUrl = 'https://claude.ai/download';
  static const String cursorDownloadUrl = 'https://cursor.sh';
  static const String vscodeDownloadUrl = 'https://code.visualstudio.com';
  static const String environmentFolder = 'environments';

  static const debugMode = kDebugMode;
  static const firebaseCollectEventsEnabled = !kDebugMode;
  static bool testingMode = Platform.environment.containsKey('FLUTTER_TEST');
  static late String wsUrl;
  static late String gptIntegrationUrl;
  static late String appDirectoryPath;
  static late String landingUrl;

  static final bool useForegroundService = !kIsWeb && Platform.isAndroid;

  static String get claudeBundleSetupUri =>
      '$landingUrl/claude-bundle-setup.html';

  static String get setupMcpDocumentationUri => '$landingUrl/mcp-setup.html';

  static String get supportPrivacyUri => '$landingUrl/privacy?embed=1';

  static String get supportTermsUri => '$landingUrl/terms?embed=1';

  static String get supportContactUri => '$landingUrl/contact?embed=1';

  static String get aboutUri => '$landingUrl/about?embed=1';

  static String mcpServerName = 'health-data-server';
  static String mcpServerVersion = '1.0.0';
  static String mcpHostFallback = '0.0.0.0';
  static int mcpPort = 8080;
  static String mcpEndpoint = '/mcp';

  static final _environment = enumFromString(
        Environments.values,
        const String.fromEnvironment('ENV'),
      ) ??
      Environments.dev;

  static Future<void> initialize() async {
    await _EnvConfig._setupEnv(_environment);
    _initializeEnvVariables();
    appDirectoryPath = (await getApplicationDocumentsDirectory()).path;
  }

  static void _initializeEnvVariables() {
    wsUrl = _EnvConfig.getEnvVariable(_EnvConfig.ENV_WS_URL)!;
    gptIntegrationUrl =
        _EnvConfig.getEnvVariable(_EnvConfig.ENV_GPT_INTEGRATION_KEY)!;
    landingUrl = _EnvConfig.getEnvVariable(_EnvConfig.ENV_LANDING_URL_KEY)!;
  }
}

abstract class _EnvConfig {
  static const ENV_WS_URL = 'WS_URL';
  static const ENV_GPT_INTEGRATION_KEY = 'GPT_URL';
  static const ENV_LANDING_URL_KEY = 'LANDING_URL';
  static const ENV_REQUIRE_FOREGROUND_SESSION = 'REQUIRE_FOREGROUND_SESSION';

  static const systemEnv = {
    ENV_WS_URL: String.fromEnvironment(ENV_WS_URL),
    ENV_GPT_INTEGRATION_KEY: String.fromEnvironment(ENV_GPT_INTEGRATION_KEY),
    ENV_LANDING_URL_KEY: String.fromEnvironment(ENV_LANDING_URL_KEY),
    ENV_REQUIRE_FOREGROUND_SESSION:
        String.fromEnvironment(ENV_REQUIRE_FOREGROUND_SESSION),
  };

  static final Map<String, String> _envFileEnv = {};

  static String? getEnvVariable(String key) =>
      _EnvConfig.systemEnv[key].ifNullOrBlank(() => _envFileEnv[key]);

  static Future<void> _setupEnv(Environments env) async {
    _envFileEnv
      ..addAll(await loadEnvs('${Config.environmentFolder}/default.env'))
      ..addAll(await loadEnvs('${env.path}.env'))
      ..addAll(await loadEnvs('${env.path}.private.env'));
  }
}
