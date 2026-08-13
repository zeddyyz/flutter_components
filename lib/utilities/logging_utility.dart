import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class Logging {
  static final _logger = Logger();

  static void d(String message, [StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.d(message, stackTrace: stackTrace);
    }
  }

  static void i(String message, {StackTrace? stackTrace}) {
    if (kDebugMode) {
      _logger.d("--Info--\n$message", stackTrace: stackTrace);
    }
  }

  static void e(String message, [StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.e("--Error--\n$message\n$stackTrace");
    }
  }

  static void prettyPrint(dynamic data, [StackTrace? stackTrace]) {
    if (kDebugMode) {
      JsonEncoder encoder = const JsonEncoder.withIndent('  '); // 2 spaces for indentation
      d(encoder.convert(data), stackTrace);
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
