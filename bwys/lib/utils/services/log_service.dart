import 'dart:developer' as developer;

import 'package:logging/logging.dart';

enum Log {
  DEBUG,
  INFO,
  ERROR,
  WARNING,

  /// [PRIVATE] logs will not be shared on crashlytics
  PRIVATE,
}

class LogService {
  /// Instance of [LogService]
  static LogService? _instance;

  /// Instance of [CrashlyticsService]
  /// TODO: Crashlytics
  /// static CrashlyticsService _crashlyticsServiceInstance;

  LogService._internal();

  /// Return the instance of [LogService]
  /// Try to call this only after initializing [CrashlyticsService]
  static LogService? getInstance() {
    if (_instance == null) {
      _instance = LogService._internal();
    }

    /// TODO: Crashlytics

    // if (_crashlyticsServiceInstance == null) {
    //   _crashlyticsServiceInstance = Application.crashlyticsService;
    // }
    return _instance;
  }

  /// try not to call this from [CrashlyticsService]
  void log(
    Object? message, {
    Log type = Log.DEBUG,
    Object? error,
    StackTrace? stackTrace,
  }) {
    String? tag;
    switch (type) {
      case Log.DEBUG:
        tag = "DEBUG";
        developer.log(
          message?.toString() ?? "NULL",
          level: Level.ALL.value,
          error: error,
          stackTrace: stackTrace,
        );
        break;
      case Log.INFO:
        tag = "INFO";
        developer.log(
          message?.toString() ?? "NULL",
          level: Level.INFO.value,
          error: error,
          stackTrace: stackTrace,
        );
        break;
      case Log.ERROR:
        tag = "ERROR";
        developer.log(
          message?.toString() ?? "NULL",
          level: Level.SHOUT.value,
          error: error,
          stackTrace: stackTrace,
        );
        break;
      case Log.WARNING:
        tag = "WARNING";
        developer.log(
          message?.toString() ?? "NULL",
          level: Level.WARNING.value,
          error: error,
          stackTrace: stackTrace,
        );
        break;
      case Log.PRIVATE:
        tag = "PRIVATE";
        developer.log(
          message?.toString() ?? "NULL",
          level: Level.ALL.value,
          error: error,
          stackTrace: stackTrace,
        );
        return;
    }
    _addLogToCrashlytics("$tag : $message");
  }

  void _addLogToCrashlytics(String message) {
    /// TODO: Crashlytics

    // _crashlyticsServiceInstance.addLog(message);
  }
}
