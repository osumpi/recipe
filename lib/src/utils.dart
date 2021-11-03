import 'dart:io';

import 'package:meta/meta.dart';
import 'package:tint/tint.dart';
import 'package:recipe/src/bake_context.dart';
import 'package:recipe/src/recipe.dart';

@internal
@immutable
class LogLevel implements Comparable<LogLevel> {
  @internal
  @literal
  const LogLevel(this.name, this.value);

  @internal
  final int value;

  final String name;

  @override
  int compareTo(LogLevel other) => value.compareTo(other.value);

  @override
  String toString() => name;
}

@sealed
abstract class LogLevels {
  static const off = LogLevel('off', 100);
  static const fatal = LogLevel('fatal', 70);
  static const error = LogLevel('error', 60);
  static const warning = LogLevel('warning', 50);
  static const info = LogLevel('info', 40);
  static const debug = LogLevel('debug', 30);
  static const verbose = LogLevel('verbose', 20);
  static const trace = LogLevel('trace', 10);
  static const all = LogLevel('all', 0);

  static const values = [
    off,
    fatal,
    error,
    warning,
    info,
    debug,
    verbose,
    trace,
    all,
  ];
}

@sealed
abstract class FrameworkUtils {
  static LogLevel _loggingLevel = LogLevels.all;

  static void setLoggingLevel(LogLevel level) {
    _loggingLevel = level;
  }

  static void log(
    String message, {
    required String module,
    LogLevel level = LogLevels.info,
  }) {
    if (level.value < _loggingLevel.value) return;

    message = '${level.name[0].toUpperCase()}/$module: $message';

    if (level.value < LogLevels.debug.value) {
      message = message.red();
    }

    stdout.writeln(message);
  }

  static void warn(String message, {required String module}) =>
      log(message, module: module, level: LogLevels.warning);

  static void error(String message, {required String module}) =>
      log(message, module: module, level: LogLevels.error);

  static void info(String message, {required String module}) =>
      log(message, module: module);

  static void verbose(String message, {required String module}) =>
      log(message, module: module, level: LogLevels.verbose);
}

Stream<BakeContext> bake(Recipe recipe) {
  return Baker.of(null).bake(recipe);
}

typedef JsonMap = Map<String, dynamic>;
