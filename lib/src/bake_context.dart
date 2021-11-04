import 'package:meta/meta.dart';
import 'package:recipe/src/framework_entity.dart';
import 'package:recipe/src/recipe.dart' show Recipe;
import 'package:recipe/src/exceptions.dart';

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

  T findNearestRecipeOfExactType<T extends Recipe>({
    T Function()? onNotFound,
  }) {
    for (final recipe in ancestors) {
      if (recipe is T) {
        return recipe;
      }
    }

    if (onNotFound == null) {
      error("Could not find $T in $ancestors");
      throw RecipeNotFound<T>(ancestors);
    }

    return onNotFound();
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

  @override
  String toString() => ancestors.reversed.join(' -> ');
}
