import 'dart:io';

import 'package:meta/meta.dart';
import 'package:tint/tint.dart';
import 'package:uuid/uuid.dart';

import 'recipe.dart';

/// Log level that is used for logging.
///
/// See [LogLevels] for all available levels.
@internal
@immutable
class LogLevel implements Comparable<LogLevel> {
  @internal
  @literal
  const LogLevel(this.name, this.value);

  /// A value to compare between all [LogLevels].
  @internal
  final int value;

  /// The name of this [LogLevel].
  final String name;

  @override
  int compareTo(final LogLevel other) => value.compareTo(other.value);

  @override
  String toString() => name;
}

/// All available [LogLevel]s.
@sealed
abstract class LogLevels {
  /// The log level that disables logging. Use this level only for setting
  /// logging level.
  /// TODO: improve docs
  static const off = LogLevel('off', 100);

  /// Log level to log fatal events.
  static const fatal = LogLevel('fatal', 80);

  /// Log level to log errors.
  static const error = LogLevel('error', 70);

  /// Log level to log warnings.
  static const warning = LogLevel('warning', 60);

  static const status = LogLevel('status', 50); // TODO: remove this.

  /// Log level to log infos.
  static const info = LogLevel('info', 40);

  /// Log level to log verbose events.
  static const verbose = LogLevel('verbose', 20);

  /// Log level to trace events. Use this level to report that you inhaled and
  /// exhaled.
  static const trace = LogLevel('trace', 10);

  /// The log level that enables all levels to be logged. Use this level only
  /// for setting logging level.
  static const all = LogLevel('all', 0);

  /// All available [LogLevel]s in this framework.
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

/// Abstract class that contains all utility tools for use in recipe framework
/// as static members.
///
/// This class is not intended to be used as a super type or have instances.
@sealed
abstract class FrameworkUtils {
  /// Provides an instance of [Uuid].
  ///
  /// Used by:
  /// * [Baker]s for [BakeReport]s and other relevant tasks.
  /// * [MultiIORecipe] to allocate random label for the the masked IO ports.
  static const uuid = Uuid();

  static LogLevel loggingLevel = LogLevels.all;
  static bool showTimestampInLogs = true;

  static void log(
    final Object? obj, {
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

// TODO: make it as Recipe<RecipeRun
void bake(final Recipe<dynamic, dynamic> recipe) {
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
