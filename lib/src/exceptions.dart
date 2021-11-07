import 'package:meta/meta.dart';

import 'package:recipe/src/recipe.dart' show Recipe;

/// Recipe of type [T] was not found in the [visitedRecipes].
@immutable
class RecipeNotFound<T extends Recipe> implements Exception {
  const RecipeNotFound(this.visitedRecipes);

  /// The recipes that were visited and checked against if it was of type [T].
  /// This shall include all the recipes passed by the requester.
  final List<Recipe> visitedRecipes;

  @override
  String toString() {
    return """
Recipe of type "$T" not found in ancestors.
Visited: ${visitedRecipes.join(' -> ')}

This is possibly because there was no recipe of the specified type that was executed before the recipe that requested it.
Try adding `$T` in the visitation route, or by specifying `onNotFound`.""";
  }
}
