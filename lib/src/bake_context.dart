import 'dart:io';

import 'package:meta/meta.dart';
import 'package:recipe/src/framework_entity.dart';
import 'package:recipe/src/recipe.dart';

@immutable
class BakeContext with FrameworkEntity, EntityLogging {
  @internal
  BakeContext(this.recipe, this.parentContext);

  final Recipe recipe;

  final BakeContext? parentContext;

  Recipe? get parent => parentContext?.recipe;

  bool get hasParent => parent != null;

  late final path = _findPath();

  late final ancestors = _getVisitationRouteFromRoot();

  String _findPath() {
    return parentContext == null
        ? '${recipe.name}'
        : '${parentContext?.path}/${recipe.name}';
  }

  T getRecipeOfExactTypeFromAncestors<T>() {
    for (var recipe in ancestors) {
      if (recipe is T) {
        return recipe as T;
      }
    }

    if (null is T) {
      return null as T;
    }

    error("There's no recipe of type $T in $ancestors");
    throw RecipeOfTypeNotFound<T>(ancestors);
  }

  List<Recipe> _getVisitationRouteFromRoot() {
    final result = [recipe];

    var p = this.parentContext;

    while (p != null) {
      result.add(p.recipe);
      p = p.parentContext;
    }

    return result;
  }
}

@immutable
class RecipeOfTypeNotFound<T> implements Exception {
  final List<Recipe> ancestors;

  const RecipeOfTypeNotFound(this.ancestors);

  @override
  String toString() {
    return """
Recipe of type "$T" not found in ancestors.
Visited: ${ancestors.join(' -> ')}

This is possibly because there was no recipe of the specified type that was 
executed before the recipe that requested it. Try adding the recipe of type 
$T between the above mentioned visitation route, or by allowing null type to 
handle missing case by yourself.""";
  }
}
