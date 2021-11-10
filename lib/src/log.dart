import 'dart:io';

import 'package:meta/meta.dart';
import 'package:tint/tint.dart';

import 'framework_entity.dart';

@doNotStore
class Log {
  Log._(
    final this.level,
    final this.module,
    final this.object,
    final LogOptions? _logOptions,
  )   : logOptions = _logOptions ?? Log.defaultOptions,
        shouldBeep = level == LogLevels.fatal {
    // Skip remaining if it's not going to be logged.
    if (level.value < Log.loggingLevel.value) return;

    if (shouldBeep) stdout.writeCharCode(0x07);

    // TODO : format and print the message
  }

  factory Log.fatal(
    final Object? object, {
    final FrameworkEntity module = anonymous,
    final LogOptions? logOptions,
  }) =>
      Log._(LogLevels.fatal, module, object, logOptions);

  factory Log.error(
    final Object? object, {
    final FrameworkEntity module = anonymous,
    final LogOptions? logOptions,
  }) =>
      Log._(LogLevels.error, module, object, logOptions);

  factory Log.warn(
    final Object? object, {
    final FrameworkEntity module = anonymous,
    final LogOptions? logOptions,
  }) =>
      Log._(LogLevels.warning, module, object, logOptions);

  factory Log.info(
    final Object? object, {
    final FrameworkEntity module = anonymous,
    final LogOptions? logOptions,
  }) =>
      Log._(LogLevels.info, module, object, logOptions);

  factory Log.verbose(
    final Object? object, {
    final FrameworkEntity module = anonymous,
    final LogOptions? logOptions,
  }) =>
      Log._(LogLevels.verbose, module, object, logOptions);

  factory Log.trace(
    final Object? object, {
    final FrameworkEntity module = anonymous,
    final LogOptions? logOptions,
  }) =>
      Log._(LogLevels.trace, module, object, logOptions);

  static LogOptions defaultOptions = LogOptions.defaults();
  static LogLevel loggingLevel = LogLevels.info;

  final Object? object;
  final FrameworkEntity module;
  final LogLevel level;
  final LogOptions logOptions;
  final bool shouldBeep;
}

@immutable
class LogOptions {
  const LogOptions({
    final this.includeTimestamps = true,
    final this.applyColors = true,
  });

  const factory LogOptions.defaults() = LogOptions;

  final bool includeTimestamps;

  final bool applyColors;

  LogOptions copyWith({
    final bool? includeTimestamps,
    final bool? applyColors,
  }) {
    return LogOptions(
      includeTimestamps: includeTimestamps ?? this.includeTimestamps,
      applyColors: applyColors ?? this.applyColors,
    );
  }
}

class _AnonymousModule with FrameworkEntity {
  const _AnonymousModule(this.name);

  @override
  final String name;
}

const anonymous = _AnonymousModule('Anonymous');

/// Log level that is used for logging.
///
/// See [LogLevels] for all available levels.
@internal
@immutable
class LogLevel implements Comparable<LogLevel> {
  @internal
  @literal
  const LogLevel({
    required final this.label,
    required final this.labelAsSymbol,
    required final this.value,
    required final this.moduleNameFormatter,
    required final this.messageFormatter,
  });

  /// A value to compare between all [LogLevels].
  @internal
  final int value;

  /// The short symbolic representation of [label].
  final String labelAsSymbol;

  /// The name of this [LogLevel].
  final String label;

  final String Function(FrameworkEntity module) moduleNameFormatter;

  final String Function(Object? object) messageFormatter;

  @override
  int compareTo(final LogLevel other) => value.compareTo(other.value);

  @override
  String toString() => label.strip();
}
