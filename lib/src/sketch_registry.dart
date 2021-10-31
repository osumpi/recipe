import 'package:fhir_yaml/fhir_yaml.dart';

import 'recipe.dart';
import 'ports/ports.dart';
import 'utils.dart';

class SketchRegistry {
  static final recipes = <Recipe>{};
  static final ports = <Port>{};
  static final connections = <Connection>{};

  static void registerRecipe(Recipe recipe) {
    recipes.add(recipe);
  }

  static void _visitPorts() {
    for (final recipe in recipes) {
      ports.add(recipe.inputPort);
      ports.add(recipe.outputPort);
    }
  }

  static void registerConnection(Connection connection) {
    connections.add(connection);
  }

  static JsonMap exportToJsonMap({
    bool includeRecipes = true,
    bool includePorts = true,
    bool includeConnections = true,
  }) {
    _visitPorts();

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

extension on Set<Recipe> {
  List<JsonMap> sketchEntryGroup() {
    return [
      for (final recipe in this) recipe.toJson(),
    ];
  }
}

extension on Set<Port> {
  JsonMap sketchEntryGroup() {
    return {
      for (final port in this) '${port.hashCode}': port.toJson(),
    };
  }
}

extension on Set<Connection> {
  JsonMap sketchEntryGroup() {
    return {
      for (final connection in this)
        '${connection.hashCode}': connection.toJson(),
    };
  }
}
