import 'package:meta/meta.dart';
import 'package:fhir_yaml/fhir_yaml.dart';
import 'package:recipe/recipe.dart';
import 'package:recipe/src/ports/ports.dart';
import 'package:recipe/src/utils.dart';

mixin FrameworkEntity {
  String get name => runtimeType.toString();

  @protected
  void log(String message, {String level = 'I'}) =>
      FrameworkUtils.log(message, module: '$name#$hashCode', level: level);

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

    if (entity is Recipe) {
      verbose('registering as recipe');
      return SketchRegistry.recipes.add(entity);
    }

    if (entity is Port) {
      verbose('registering as port');
      return SketchRegistry.ports.add(entity);
    }

    if (entity is Connection) {
      verbose('registering as connection');
      return SketchRegistry.connections.add(entity);
    }

    throw UnsupportedError(
        '${this.runtimeType} is not a supported type that can be registered.');
  }

  @override
  String toString() => '$runtimeType#$hashCode';
}
