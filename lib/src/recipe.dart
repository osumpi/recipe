import 'package:meta/meta.dart';

import 'package:recipe/src/bake_context.dart';
import 'package:recipe/src/framework_entity.dart';
import 'package:recipe/src/utils.dart';

abstract class Recipe with FrameworkEntity, EntityLogging {
  const Recipe();

  @protected
  @mustCallSuper
  Stream<BakeContext> bake(BakeContext context);

  @override
  JsonMap toJson() {
    return {
      ...super.toJson(),
    };
  }
}

class Baker with FrameworkEntity, EntityLogging {
  const Baker.of(BakeContext? context) : parentContext = context;

  @internal
  final BakeContext? parentContext;

  Stream<BakeContext> bake(Recipe recipe) async* {
    verbose('Baking 1/1: $recipe');
    final childContext = BakeContext(recipe, parentContext);

    yield* recipe.bake(childContext);
  }

  Stream<BakeContext> bakeAll(
    List<Recipe> recipes, {
    BakeStrategy strategy = BakeStrategy.sequential,
  }) async* {
    final total = recipes.length;
    final indexedRecipes = recipes.asMap().entries;

    if (strategy == BakeStrategy.sequential) {
      var context = parentContext;

      for (final indexedRecipe in indexedRecipes) {
        final pos = indexedRecipe.key + 1;
        final recipe = indexedRecipe.value;

        context = BakeContext(recipe, context);

        verbose('Baking $pos/$total: $recipe, strategy=$strategy');
        yield* recipe.bake(context);
      }
    } else if (strategy == BakeStrategy.parallel) {
      bakeAsFuture(MapEntry<int, Recipe> indexedRecipe) async {
        final pos = indexedRecipe.key + 1;
        final recipe = indexedRecipe.value;

        verbose('Baking $pos/$total: $recipe, strategy=$strategy');
        return await bake(recipe);
      }

      await Future.wait(indexedRecipes.map(bakeAsFuture));
    }
  }
}

enum BakeStrategy { sequential, parallel }
