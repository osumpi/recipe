import 'package:meta/meta.dart';
import 'package:fhir_yaml/fhir_yaml.dart' show json2yaml;

import 'package:recipe/src/utils.dart';

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
/// * [status] to log status updates. See [Statuses] for various available
/// status.
/// * [info] to log using [LogLevels.info]
/// * [verbose] to log using [LogLevels.verbose].
/// * [trace] to log using [LogLevels.trace].
mixin EntityLogging on FrameworkEntity {
  static bool _shouldIncludeHashCode = false;

  static showHashCodeOfEntities() => _shouldIncludeHashCode = true;
  static hideHashCodeOfEntities() => _shouldIncludeHashCode = false;

  /// Whether [hashCode] should be included in the `moduleName` when logging.
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
  static get shouldIncludeHashCode => _shouldIncludeHashCode;

  @protected
  void log(
    Object? object, {
    LogLevel level = LogLevels.info,
    Statuses? status,
  }) {
    final moduleName = _shouldIncludeHashCode ? '$name#$hashCode' : name;

    return FrameworkUtils.log(
      object,
      module: moduleName,
      level: level,
      status: status,
    );
  }

  @protected
  void fatal(String message) => log(message, level: LogLevels.fatal);

  @protected
  void error(String message) => log(message, level: LogLevels.error);

  @protected
  void warn(String message) => log(message, level: LogLevels.warning);

  @protected
  void status(String message, {required Statuses status}) =>
      log(message, level: LogLevels.status, status: status);

  @protected
  void info(String message) => log(message, level: LogLevels.info);

  @protected
  void verbose(String message) => log(message, level: LogLevels.verbose);

  @protected
  void trace(String message) => log(message, level: LogLevels.trace);
}
