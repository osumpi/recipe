import 'dart:io';

import 'package:meta/meta.dart';

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
  static LogLevel loggingLevel = LogLevels.all;

  static void log(
    String message, {
    required String module,
    LogLevel level = LogLevels.info,
  }) {
    if (level.value < loggingLevel.value) return;

    stdout.writeln('${level.name[0]}/$module: $message');
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

typedef JsonMap = Map<String, dynamic>;
