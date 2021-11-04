import 'dart:io';

import 'package:meta/meta.dart';
import 'package:recipe/recipe.dart';
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
  static const fatal = LogLevel('fatal', 80);
  static const error = LogLevel('error', 70);
  static const warning = LogLevel('warning', 60);
  static const status = LogLevel('status', 50);
  static const info = LogLevel('info', 40);
  static const verbose = LogLevel('verbose', 20);
  static const trace = LogLevel('trace', 10);
  static const all = LogLevel('all', 0);

  static const values = [
    off,
    fatal,
    error,
    warning,
    status,
    info,
    verbose,
    trace,
    all,
  ];
}

@sealed
abstract class FrameworkUtils {
  static var loggingLevel = LogLevels.all;
  static var showTimestampInLogs = true;

  static void log(
    Object? obj, {
    String? module,
    LogLevel level = LogLevels.info,
  }) {
    module ??= '(anonymous)';

    if (level.value < loggingLevel.value) return;

    var message = '${level.name[0].toUpperCase()}/$module: $obj';

    if (level.value <= LogLevels.verbose.value) {
      message = message.dim();
    }

    switch (level) {
      case LogLevels.fatal:
        message = message.brightRed().bold();
        break;
      case LogLevels.error:
        message = message.red();
        break;
      case LogLevels.warning:
        message = message.yellow();
        break;
      case LogLevels.status:
        message = message.green().bold();
        break;
      case LogLevels.trace:
        message = message.italic();
    }

    if (showTimestampInLogs) {
      message = '${'[${DateTime.now()}]'.dim()} $message';
    }

    stdout.writeln(message);
  }

  static void fatal(String message, {String? module}) =>
      log(message, module: module, level: LogLevels.fatal);

  static void error(String message, {String? module}) =>
      log(message, module: module, level: LogLevels.error);

  static void warn(String message, {String? module}) =>
      log(message, module: module, level: LogLevels.warning);

  static void info(String message, {String? module}) =>
      log(message, module: module);

  static void status(String message, {String? module}) =>
      log(message, module: module, level: LogLevels.status);

  static void verbose(String message, {String? module}) =>
      log(message, module: module, level: LogLevels.verbose);

  static void trace(String message, {String? module}) =>
      log(message, module: module, level: LogLevels.trace);
}

Stream<BakeContext> bake(Recipe recipe) {
  return Baker.of(null).bake(recipe);
}

typedef JsonMap = Map<String, dynamic>;
