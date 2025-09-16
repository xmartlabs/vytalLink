import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_template/core/common/config.dart';
import 'package:logger/logger.dart';

// An example of crashlytics impl can be found https://gist.github.com/mirland/70fa48154e56ae9b16279dcffc7ac4ba
abstract interface class CrashReportTool {
  Future init();

  Future logNonFatal(LogEvent event);

  Future logFatal(dynamic error, StackTrace? stackTrace);
}

class CrashlyticsCrashReportTool extends CrashReportTool {
  @override
  Future init() async {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(Config.firebaseCollectEventsEnabled);
  }

  @override
  Future logFatal(error, StackTrace? stackTrace) =>
      FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);

  @override
  Future logNonFatal(LogEvent event) async {
    await FirebaseCrashlytics.instance.setCustomKey('level', event.level.name);
    await FirebaseCrashlytics.instance.recordError(
      event.error ?? FlutterError(event.message),
      event.stackTrace,
      reason: event.message,
      fatal: false,
    );
  }
}
