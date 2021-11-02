import 'dart:io';

import 'package:fhir_yaml/fhir_yaml.dart';
import 'package:meta/meta.dart';
import 'package:recipe/recipe.dart';
import 'package:recipe/src/ports/ports.dart';

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

  @protected
  void verbose(String message) => log(message, level: 'V');

  JsonMap toJson();

  @nonVirtual
  String toYaml() => json2yaml(toJson());

  @protected
  @mustCallSuper
  bool register() {
    final entity = this;

    if (entity is Recipe) return SketchRegistry.recipes.add(entity);
    if (entity is Port) return SketchRegistry.ports.add(entity);
    if (entity is Connection) return SketchRegistry.connections.add(entity);

    throw UnsupportedError(
        '${this.runtimeType} is not a supported type that can be registered.');
  }
}

typedef JsonMap = Map<String, dynamic>;
