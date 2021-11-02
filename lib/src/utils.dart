import 'dart:io';

import 'package:meta/meta.dart';

@sealed
abstract class FrameworkUtils {
  static void log(
    String message, {
    required String module,
    String level = 'I',
  }) {
    stdout.writeln('$level/$module: $message');
  }

  static void warn(String message, {required String module}) =>
      log(message, module: module, level: 'W');

  static void error(String message, {required String module}) =>
      log(message, module: module, level: 'E');

  static void info(String message, {required String module}) =>
      log(message, module: module, level: 'I');

  static void verbose(String message, {required String module}) =>
      log(message, module: module, level: 'V');
}

typedef JsonMap = Map<String, dynamic>;
