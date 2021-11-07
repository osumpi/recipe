import 'dart:io';

import 'package:meta/meta.dart';
import 'package:recipe/recipe.dart';
import 'package:recipe/src/bake_context.dart';
import 'package:recipe/src/recipe.dart';
import 'package:tint/tint.dart';
import 'package:uuid/uuid.dart';

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
  int compareTo(final LogLevel other) => value.compareTo(other.value);

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

const uuid = Uuid();

@sealed
abstract class FrameworkUtils {
  static var loggingLevel = LogLevels.all;
  static var showTimestampInLogs = true;

  static void log(
    Object? obj, {
    String? module,
    final LogLevel level = LogLevels.info,
    Statuses? status,
  }) {
    if (level.value < loggingLevel.value) return;

    assert(
      (level == LogLevels.status && status == null) == false,
      "Specify status, when using `LogLevels.status` as the logging level. Consider using `status(...)` or `FrameworkUtils.status(...)`.",
    );

    module ??= 'Anonymous';

    var message = obj.toString();

    if (level == LogLevels.status) {
      status ??= Statuses.successful;
      message = status.format(message);
    }

    message = '${level.name[0].toUpperCase()}/$module: $message';

    if (level.value <= LogLevels.verbose.value) {
      message = message.dim();
    }

    switch (level) {
      case LogLevels.fatal:
        FrameworkUtils.beep();
        message =
            '${message.brightRed().bold()} ${' FATAL '.bold().white().onRed().blink()}';
        break;
      case LogLevels.error:
        message = message.red();
        break;
      case LogLevels.warning:
        message = message.yellow();
        break;
      case LogLevels.trace:
        message = message.italic();
    }

    if (showTimestampInLogs) {
      message = '${'[${DateTime.now()}]'.dim()} $message';
    }

    stdout.writeln(message);
  }

  static void fatal(final String message, {final String? module}) =>
      log(message, module: module, level: LogLevels.fatal);

  static void error(final String message, {final String? module}) =>
      log(message, module: module, level: LogLevels.error);

  static void warn(final String message, {final String? module}) =>
      log(message, module: module, level: LogLevels.warning);

  static void info(final String message, {final String? module}) =>
      log(message, module: module);

  static void statusUpdate(
    final String message, {
    final String? module,
    required final Statuses status,
  }) =>
      log(message, module: module, level: LogLevels.status, status: status);

  static void verbose(final String message, {final String? module}) =>
      log(message, module: module, level: LogLevels.verbose);

  static void trace(final String message, {final String? module}) =>
      log(message, module: module, level: LogLevels.trace);

  static void beep() => stdout.writeCharCode(0x07);
}

Stream<BakeContext> bake(final Recipe recipe) {
  throw UnimplementedError();
  // return Baker.of(null).bake(recipe);
}

typedef JsonMap = Map<String, dynamic>;

@immutable
class Statuses {
  const Statuses._(this.prefix, this._format);

  final String prefix;
  final String Function(String message) _format;

  static const successful = Statuses._('✓', _successfulFormatter);
  static const failed = Statuses._('✗', _failedFormatter);
  static const warning = Statuses._('!', _warningFormatter);
  static const fatal = Statuses._('✗', _fatalFormatter);

  static String _successfulFormatter(final String message) => message.green();
  static String _failedFormatter(final String message) => message.red();
  static String _warningFormatter(final String message) => message.yellow();
  static String _fatalFormatter(final String message) {
    FrameworkUtils.beep();
    return '${' FATAL '.bold().white().onRed().blink()} ${message.toUpperCase().bold().red()}';
  }

  String format(final String message) => _format('$prefix $message');
}
