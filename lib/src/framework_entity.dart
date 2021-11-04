import 'package:meta/meta.dart';
import 'package:fhir_yaml/fhir_yaml.dart';

import 'package:recipe/src/utils.dart';

mixin FrameworkEntity {
  String get name => runtimeType.toString();

  @mustCallSuper
  JsonMap toJson() {
    return {
      'name': name,
      'runtime type': runtimeType.toString(),
      'ref': hashCode,
    };
  }

  @nonVirtual
  String toYaml() => json2yaml(toJson());

  @override
  String toString() => '$runtimeType';
}

mixin EntityLogging on FrameworkEntity {
  static bool _shouldIncludeHash = false;

  static showHashCodeOfEntities() => _shouldIncludeHash = true;
  static hideHashCodeOfEntities() => _shouldIncludeHash = false;

  @protected
  void log(
    Object? object, {
    LogLevel level = LogLevels.info,
    Statuses? status,
  }) {
    final moduleName = _shouldIncludeHash ? '$name#$hashCode' : name;

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
