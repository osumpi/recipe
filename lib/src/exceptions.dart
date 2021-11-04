import 'package:meta/meta.dart';

import 'package:recipe/src/recipe.dart' show Recipe;

@immutable
class RecipeNotFound<T extends Recipe> implements Exception {
  final List<Recipe> visitedRecipes;

  const RecipeNotFound(this.visitedRecipes);

  @override
  String toString() {
    return """
Recipe of type "$T" not found in ancestors.
Visited: ${visitedRecipes.join(' -> ')}

This is possibly because there was no recipe of the specified type that was executed before the recipe that requested it.
Try adding `$T` in the visitation route, or by specifying `onNotFound`.""";
  }
}
