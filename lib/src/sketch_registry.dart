import 'package:meta/meta.dart';
import 'package:fhir_yaml/fhir_yaml.dart';

import 'recipe.dart';
import 'ports/ports.dart';
import 'utils.dart';

@sealed
@immutable
class SketchRegistry {
  /// This class is not intended to be instantiated.
  const SketchRegistry._();

  @internal
  static final recipes = <Recipe>{};

  @internal
  static final ports = <Port>{};

  @internal
  static final connections = <Connection>{};

  @internal
  static void ensureAllPortsIncluded() {
    for (final recipe in recipes) {
      ports.add(recipe.inputPort);
      ports.add(recipe.outputPort);
    }
  }

  static JsonMap exportToJsonMap({
    bool includeRecipes = true,
    bool includePorts = true,
    bool includeConnections = true,
  }) {
    ensureAllPortsIncluded();

    return {
      if (includeRecipes) 'recipes': recipes.sketchEntryGroup(),
      if (includePorts) 'ports': ports.sketchEntryGroup(),
      if (includeConnections) 'connections': connections.sketchEntryGroup(),
    };
  }

  static String exportToYaml({
    bool includeRecipes = true,
    bool includePorts = true,
    bool includeConnections = true,
  }) {
    final json = exportToJsonMap(
      includeRecipes: includeRecipes,
      includePorts: includePorts,
      includeConnections: includeConnections,
    );

    return json2yaml(json);
  }
}

extension on Set<FrameworkEntity> {
  @internal
  List<JsonMap> sketchEntryGroup() {
    return [
      for (final element in this) element.toJson(),
    ];
  }
}
