import 'dart:io';

import 'package:fhir_yaml/fhir_yaml.dart' show json2yaml;
import 'package:meta/meta.dart';
import 'package:tint/tint.dart';
import 'package:uuid/uuid.dart';

/// Provides an instance of [Uuid].
///
/// Used by:
/// * [Baker]s for [BakeReport]s and other relevant tasks.
/// * [MultiIORecipe] to allocate random label for the the masked IO ports.
const uuid = Uuid();

// TODO: make it as Recipe<RecipeRun

typedef JsonMap = Map<String, dynamic>;

/// This mixin provides basic functionallities required by entities of the
/// recipe framework.
///
/// See more:
/// * [name] of the entity (defaults to [runtimeType]).
/// * [toJson] includes [name], [runtimeType], [hashCode] by default.
///
mixin FrameworkEntity {
  /// The name of this entity. Is [runtimeType] by default. However sub-classes
  /// may override to represent a different name.
  ///
  /// TODO: include examples of consumers, and why Ports have different.
  String get name => runtimeType.toString();

  /// Export this entity as a [JsonMap]. Includes [name], [runtimeType] and
  /// [hashCode] of this instance by default.
  ///
  /// Sub-classes [mustCallSuper] as shown in the example:
  /// ```dart
  /// class DataAcquisition with FrameworkEntity, EntityLogging {
  ///   @override
  ///   JsonMap toJson() {
  ///     return {
  ///       ...super.toJson(), // Include this to import all entries filled by super class.
  ///       'temperature': temperature,
  ///       'voltage': voltage,
  ///     };
  ///   }
  /// }
  /// ```
  @mustCallSuper
  JsonMap toJson() {
    return {
      'name': name,
      'runtime type': runtimeType.toString(),
      'ref': hashCode,
    };
  }

  /// Export this entity as a YAML formatted Map. This method is not intended
  /// to be overriden. Simply converts the result of [toJson] to YAML format.
  @nonVirtual
  String toYaml() => json2yaml(toJson());

  /// The [runtimeType] of this entity as [String].
  @override
  String toString() => runtimeType.toString();
}

@doNotStore
class Log {
  factory Log(
    final Object? object, {
    required final LogLevel level,
  }) =>
      Log._(level, null, object);

  Log._(
    final LogLevel level,
    final FrameworkEntity? module,
    final Object? object,
  ) {
    if (level.value < Log.loggingLevel.value) return;

    if (level == LogLevels.fatal) stdout.writeCharCode(0x07);

    var logMessage = [
      if (showTimestamp) DateTime.now().toString().dim().reset(),
      if (showLevelSymbolInsteadOfLabel) level.labelAsSymbol else level.label,
      _seperator,
      if (module != null) level.moduleNameFormatter(module),
      _seperator,
      level.messageFormatter(object),
    ].join(' ');

    if (!applyColors) {
      logMessage = logMessage.strip();
    }

    stdout.writeln(logMessage);
  }

  factory Log.fatal(final Object? object) =>
      Log._(LogLevels.fatal, null, object);

  factory Log.error(final Object? object) =>
      Log._(LogLevels.error, null, object);

  factory Log.warn(final Object? object) =>
      Log._(LogLevels.warning, null, object);

  factory Log.info(final Object? object) => Log._(LogLevels.info, null, object);

  factory Log.verbose(final Object? object) =>
      Log._(LogLevels.verbose, null, object);

  factory Log.trace(final Object? object) =>
      Log._(LogLevels.trace, null, object);

  /// The seperator between elements of a log message.
  ///
  /// Obtained by:
  /// ```dart
  /// jsonEncode("•".dim().reset());
  /// ```
  static const _seperator = "\u001b[0m\u001b[2m•\u001b[22m\u001b[0m";

  /// The minimum logging level to be used.
  ///
  /// All log messages with severity equal and above the specified level is
  /// logged to the output.
  ///
  /// Example:
  /// ```dart
  /// Log.loggingLevel = LogLevels.info;
  ///
  /// Log.warn("I'm hungry."); // Works
  /// Log.info("I'm having pizza."); // Works
  /// Log.verbose("I'm breathing hehe."); // Will be ignored
  /// ```
  static LogLevel loggingLevel = LogLevels.info;

  /// Whether to show [LogLevel.labelAsSymbol] instead of [LogLevel.label].
  ///
  /// If `false` (default), shows the descriptive label of the log level.
  /// If `true`, shows the short symbol representation of the log level.
  ///
  /// However, this setting has no affect for [LogLevels.fatal] as this level
  /// is meant to convey very critical faults and hence the descriptive label is
  /// used to prevent confusion.
  static bool showLevelSymbolInsteadOfLabel = false;

  /// Whether to prefix timestamps along with the log message.
  ///
  /// If `false` (default), does not include timestamp in the log message.
  /// If `true`, includes timestamp in the log message.
  static bool showTimestamp = false;

  /// Whether to apply colors when logging based on log level.
  ///
  /// If `true` (default), all ANSI sequences will be preserved when logging.
  /// If `false`, all ANSI sequences will be stripped when logging.
  static bool applyColors = true;
}

/// Log level that is used for logging.
///
/// See [LogLevels] for all available levels.
@immutable
class LogLevel implements Comparable<LogLevel> {
  @literal
  const LogLevel({
    required final this.label,
    required final this.labelAsSymbol,
    required final this.value,
    required final this.moduleNameFormatter,
    required final this.messageFormatter,
  });

  /// A value to compare between all [LogLevels].
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

/// All available [LogLevel]s as static members.
///
/// This class is not intended to be used as a super class nor be instantiated.
@sealed
abstract class LogLevels {
  /// The log level that disables logging. Use this level only for setting
  /// logging level.
  /// TODO: improve docs
  static const off = LogLevel(
    label: 'off',
    labelAsSymbol: 'OFF',
    value: 100,
    moduleNameFormatter: _cannotFormat,
    messageFormatter: _cannotFormat,
  );

  /// Log level to log fatal events.
  static const fatal = LogLevel(
    label: _fatalLabel,
    labelAsSymbol: _fatalSymbolicLabel,
    value: 80,
    moduleNameFormatter: _moduleNameFormatter,
    messageFormatter: _fatalMessageFormatter,
  );

  /// Log level to log errors.
  static const error = LogLevel(
    label: _errorLabel,
    labelAsSymbol: _errorSymbolicLabel,
    value: 70,
    moduleNameFormatter: _moduleNameFormatter,
    messageFormatter: _errorMessageFormatter,
  );

  /// Log level to log warnings.
  static const warning = LogLevel(
    label: _warningLabel,
    labelAsSymbol: _warningSymbolicLabel,
    value: 60,
    moduleNameFormatter: _moduleNameFormatter,
    messageFormatter: _warningMessageFormatter,
  );

  /// Log level to log successful events.
  static const success = LogLevel(
    label: _successLabel,
    labelAsSymbol: _successSymbolicLabel,
    value: 60,
    moduleNameFormatter: _moduleNameFormatter,
    messageFormatter: _successMessageFormatter,
  );

  /// Log level to log infos.
  static const info = LogLevel(
    label: _infoLabel,
    labelAsSymbol: _infoSymbolicLabel,
    value: 40,
    moduleNameFormatter: _moduleNameFormatter,
    messageFormatter: _noFormatting,
  );

  /// Log level to log verbose events.
  static const verbose = LogLevel(
    label: _verboseLabel,
    labelAsSymbol: _verboseSymbolicLabel,
    value: 20,
    moduleNameFormatter: _moduleNameFormatter,
    messageFormatter: _verboseFormatting,
  );

  /// Log level to trace events. Use this level to report that you inhaled and
  /// exhaled.
  static const trace = LogLevel(
    label: _traceLabel,
    labelAsSymbol: ' ',
    value: 10,
    moduleNameFormatter: _moduleNameFormatter,
    messageFormatter: _traceFormatting,
  );

  /// The log level that enables all levels to be logged. Use this level only
  /// for setting logging level.
  static const all = LogLevel(
    label: 'all',
    labelAsSymbol: 'ALL',
    value: 0,
    moduleNameFormatter: _cannotFormat,
    messageFormatter: _cannotFormat,
  );

  /// All available valid [LogLevel]s in this framework.
  static const values = [
    fatal,
    error,
    warning,
    success,
    info,
    verbose,
    trace,
  ];

  /// Obtained by the following:
  ///
  /// ```dart
  /// jsonEncode('  FATAL'.bold().brightRed().blink().reset());
  /// ```
  static const _fatalLabel =
      "\u001b[0m\u001b[5m\u001b[91m\u001b[1m  FATAL\u001b[22m\u001b[39m\u001b[25m\u001b[0m";

  /// Obtained by the following:
  ///
  /// ```dart
  /// jsonEncode(_fatalLabel);
  /// ```
  static const _fatalSymbolicLabel = _fatalLabel;

  /// Obtained by the following:
  ///
  /// ```dart
  /// jsonEncode('  error'.red().reset());
  /// ```
  static const _errorLabel = "\u001b[0m\u001b[31m  error\u001b[39m\u001b[0m";

  /// Obtained by the following:
  ///
  /// ```dart
  /// jsonEncode('✗'.brightRed().reset());
  /// ```
  static const _errorSymbolicLabel = "\u001b[0m\u001b[91m✗\u001b[39m\u001b[0m";

  /// Obtained by the following:
  ///
  /// ```dart
  /// jsonEncode('warning'.brightYellow().reset());
  /// ```
  static const _warningLabel = "\u001b[0m\u001b[93mwarning\u001b[39m\u001b[0m";

  /// Obtained by the following:
  ///
  /// ```dart
  /// jsonEncode('!'.bold().brightYellow().reset());
  /// ```
  static const _warningSymbolicLabel =
      "\u001b[0m\u001b[93m\u001b[1m!\u001b[22m\u001b[39m\u001b[0m";

  /// Obtained by the following:
  ///
  /// ```dart
  /// jsonEncode('success'.brightGreen().reset());
  /// ```
  static const _successLabel = "\u001b[0m\u001b[92msuccess\u001b[39m\u001b[0m";

  /// Obtained by the following:
  ///
  /// ```dart
  /// jsonEncode('✔'.brightGreen().reset());
  /// ```
  static const _successSymbolicLabel =
      "\u001b[0m\u001b[92m✔\u001b[39m\u001b[0m";

  /// Obtained by the following:
  ///
  /// ```dart
  /// jsonEncode('   info'.brightCyan().reset());
  /// ```
  static const _infoLabel = "\u001b[0m\u001b[96m   info\u001b[39m\u001b[0m";

  /// Obtained by the following:
  ///
  /// ```dart
  /// jsonEncode('ℹ'.brightCyan().reset());
  /// ```
  static const _infoSymbolicLabel = "\u001b[0m\u001b[96mℹ\u001b[39m\u001b[0m";

  /// Obtained by the following:
  ///
  /// ```dart
  /// jsonEncode(' info '.brightCyan().reset());
  /// ```
  ///
  /// TODO: fix this stupid doc.
  static const _verboseLabel = "\u001b[0m\u001b[2mverbose\u001b[22m\u001b[0m";

  /// Obtained by the following:
  ///
  /// ```dart
  /// jsonEncode('v'.dim().reset());
  /// ```
  static const _verboseSymbolicLabel = "\u001b[0m\u001b[2mv\u001b[22m\u001b[0m";

  /// Obtained by the following:
  ///
  /// ```dart
  /// jsonEncode('  trace'.dim().reset());
  /// ```
  static const _traceLabel = "\u001b[0m\u001b[2m  trace\u001b[22m\u001b[0m";

  /// This formatter does not allow formatting to occur and throws
  /// [UnimplementedError] when invoked.
  ///
  /// Used by [LogLevels.all] and [LogLevels.off] which is not intended to be
  /// used as a level in a log event.
  @alwaysThrows
  static String _cannotFormat(final Object? _) => throw UnimplementedError();

  /// Applies no formatting to [object.toString].
  static String _noFormatting(final Object? object) =>
      object.toString().reset();

  /// Formats the value of [module.name] as dimmed text.
  static String _moduleNameFormatter(final FrameworkEntity module) =>
      module.name.dim().reset();

  /// Formats the result of [object.toString] as per fatal message style.
  ///
  /// See implementation for exact styles applied.
  static String _fatalMessageFormatter(final Object? object) =>
      object.toString().red().bold().reset();

  /// Formats the result of [object.toString] as per error message style.
  ///
  /// See implementation for exact styles applied.
  static String _errorMessageFormatter(final Object? object) =>
      object.toString().red().reset();

  /// Formats the result of [object.toString] as per warning message style.
  ///
  /// See implementation for exact styles applied.
  static String _warningMessageFormatter(final Object? object) =>
      object.toString().brightYellow().reset();

  /// Formats the result of [object.toString] as per success message style.
  ///
  /// See implementation for exact styles applied.
  static String _successMessageFormatter(final Object? object) =>
      object.toString().brightGreen().reset();

  /// Formats the result of [object.toString] as per verbose message style.
  ///
  /// See implementation for exact styles applied.
  static String _verboseFormatting(final Object? object) =>
      object.toString().dim().reset();

  /// Formats the result of [object.toString] as per trace message style.
  ///
  /// See implementation for exact styles applied.
  static String _traceFormatting(final Object? object) =>
      object.toString().dim().italic().reset();
}

/// Allows an entity that mixins [FrameworkEntity] to inherit logging methods.
/// This simplifies invocation of logging methods as opposed to invoking
/// [FrameworkUtils.log] or other log methods included in [FrameworkUtils].
///
/// Entities using this mixin implicitly has their `moduleName` set as [name]
/// or [name] with [hashCode] in logging. See [showHashCodeOfEntities],
/// [hideHashCodeOfEntities], [shouldIncludeHashCode] for more on controlling
/// what is used as the module name.
///
/// See also:
/// * [log] allows logging on any [LogLevel]. See [LogLevels] for various
/// available [LogLevel]s.
/// * [error] to log errors.
/// * [warn] to log warnings.
/// * [statusUpdate] to log status updates. See [Statuses] for various available
/// status.
/// * [info] to log using [LogLevels.info]
/// * [verbose] to log using [LogLevels.verbose].
/// * [trace] to log using [LogLevels.trace].
mixin EntityLogging on FrameworkEntity {
  /// Whether [hashCode] should be included in the `moduleName` when logging.
  /// Set to `true` to include [hashCode].
  /// Set to `false` to exclude [hashCode].
  ///
  /// Is `false` by default.
  static bool _shouldIncludeHashCode = false;

  /// Includes [hashCode] in the `moduleName` of upcoming logs.
  /// See [hideHashCodeOfEntities] to exclude [hashCode].
  static bool showHashCodeOfEntities() => _shouldIncludeHashCode = true;

  /// Excludes [hashCode] in the `moduleName` of upcoming logs.
  /// See [showHashCodeOfEntities] to exclude [hashCode].
  static bool hideHashCodeOfEntities() => _shouldIncludeHashCode = false;

  /// Whether [hashCode] should be included in the `moduleName` when logging.
  /// Is `false` by default.
  ///
  /// To hide [hashCode] of entities of future logs:
  /// ```dart
  /// EntityLogging.hideHashCodeOfEntities();
  /// ```
  ///
  /// To show [hashCode] of entities of future logs:
  /// ```dart
  /// EntityLogging.showHashCodeOfEntities();
  /// ```
  ///
  /// See also:
  /// * [showHashCodeOfEntities] to include [hashCode] of entities.
  /// * [hideHashCodeOfEntities] to exclude [hashCode] of entities.
  static bool get shouldIncludeHashCode => _shouldIncludeHashCode;

  @protected
  void log(
    final Object? object, {
    final LogLevel level = LogLevels.info,
  }) =>
      Log._(level, this, object);

  @protected
  void fatal(final Object? object) => log(object, level: LogLevels.fatal);

  @protected
  void error(final Object? object) => log(object, level: LogLevels.error);

  @protected
  void warn(final Object? object) => log(object, level: LogLevels.warning);

  @protected
  void info(final Object? object) => log(object, level: LogLevels.info);

  @protected
  void verbose(final Object? object) => log(object, level: LogLevels.verbose);

  @protected
  void trace(final Object? object) => log(object, level: LogLevels.trace);
}
