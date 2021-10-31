part of recipe.old;

abstract class _PortBase<T extends BakeContext> with _RecipeFrameworkEntity {
  String get name;

  Recipe get associatedRecipe;

  @override
  JsonMap toJson() {
    return {
      'of': associatedRecipe.hashCode,
      'name': name,
      // 'connections': connections.map((e) => e.hashCode).toList(),
      'type': T.toString(),
    };
  }

  Type get type => T;
}
