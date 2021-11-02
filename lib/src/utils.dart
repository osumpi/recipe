import 'dart:io';

import 'package:fhir_yaml/fhir_yaml.dart';
import 'package:meta/meta.dart';

mixin FrameworkEntity {
  String get name => runtimeType.toString();

  @protected
  void log(
    String message, {
    String level = 'I',
  }) {
    stdout.writeln('$level/$name#$hashCode: $message');
  }

  @protected
  void warn(String message) => log(message, level: 'W');

  @protected
  void error(String message) => log(message, level: 'E');

  @protected
  void info(String message) => log(message, level: 'I');

  void verbose(String message) => log(message, level: 'V');

  JsonMap toJson();

  String toYaml() {
    return json2yaml(toJson());
  }
}

typedef JsonMap = Map<String, dynamic>;
