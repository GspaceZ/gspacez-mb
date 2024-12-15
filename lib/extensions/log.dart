import 'package:flutter/foundation.dart';

class Log {
  static void info(String message) {
    debugPrint("INFO: $message");
  }

  static void warning(String message) {
    debugPrint("WARNING: $message");
  }

  static void error(String message) {
    debugPrint("ERROR: $message");
  }

  static void debug(String message) {
    if (kDebugMode) {
      debugPrint("DEBUG: $message");
    }
  }
}
