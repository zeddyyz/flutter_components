import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class Logging {
  static final _logger = Logger();

  static void d(String message) {
    if (kDebugMode) {
      _logger.d(message);
    }
  }

  static void i(String message) {
    if (kDebugMode) {
      _logger.d("--Info--\n$message");
    }
  }

  static void e(String message) {
    if (kDebugMode) {
      _logger.d("--Error--\n$message");
    }
  }

  static void prettyPrint(dynamic data) {
    if (kDebugMode) {
      JsonEncoder encoder = const JsonEncoder.withIndent('  '); // 2 spaces for indentation
      d(encoder.convert(data));
    }
  }

  static void print(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }
}

// final Logging = Logger(
//   level: kDebugMode ? Level.debug : Level.warning,
//   filter: kDebugMode ? null : ProductionFilter(),
// );
