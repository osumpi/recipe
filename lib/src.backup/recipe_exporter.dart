part of recipe.old;

final recipeExporter = _RecipeExporter();

@sealed
@immutable
class _RecipeExporter {
  _RecipeExporter();

  final _recipes = <Recipe>[];
  final _wires = <Wire>[];
  final _ports = <_PortBase>[];

  List<Recipe> get recipes => List.unmodifiable(_recipes);
  List<Wire> get wires => List.unmodifiable(_wires);
  List<_PortBase> get ports => List.unmodifiable(_ports);

  void _add(_RecipeFrameworkEntity entity) {
    if (entity is Recipe) {
      return _recipes.add(entity);
    }

    if (entity is Wire) {
      return _wires.add(entity);
    }

    if (entity is _PortBase) {
      return _ports.add(entity);
    }

    throw UnsupportedError('${entity.runtimeType} is not supported type');
  }

  List<JsonMap> _exportEntities(List<_RecipeFrameworkEntity> entities) {
    return entities.map((e) => e.toJson()).toList();
  }

  JsonMap exportToJsonMap({
    bool includeRecipes = true,
    bool includeWires = true,
    bool includePorts = false,
  }) {
    return {
      if (includeRecipes) 'recipes': _exportEntities(_recipes),
      if (includeWires) 'wires': _exportEntities(_wires),
      if (includePorts) 'ports': _exportEntities(_ports),
    };
  }

  String exportToYaml({
    bool includeRecipes = true,
    bool includeWires = true,
    bool includePorts = false,
  }) {
    final json = exportToJsonMap(
      includeRecipes: includeRecipes,
      includeWires: includeWires,
      includePorts: includePorts,
    );

    return json2yaml(json);
  }

  void initializeRecipes() {
    _recipes.forEach((recipe) {
      if (!recipe.isInitialized) {
        recipe.initialize();
      }
    });
  }
}
