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
    verbose('Baking $recipe');
    final startsAt = DateTime.now();

    final context = BakeContext(recipe, parentContext);
    yield* recipe.bake(context);

    final duration = DateTime.now().difference(startsAt);
    verbose('Baked $recipe in ${duration.inMilliseconds} ms');
  }

  Stream<BakeContext> bakeAll(
    List<Recipe> recipes, {
    BakeStrategy strategy = BakeStrategy.sequential,
  }) async* {
    trace('Baking $recipes');
    final startsAt = DateTime.now();

    final total = recipes.length;
    final indexedRecipes = recipes.asMap().entries;

    var context = parentContext;

    if (strategy == BakeStrategy.sequential) {
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
        return await bake(recipe).length;
      }

      await Future.wait(indexedRecipes.map(bakeAsFuture));

      context =
          recipes.fold<BakeContext?>(context, (c, r) => BakeContext(r, c));

      if (context != null) {
        yield context;
      }
    }

    final duration = DateTime.now().difference(startsAt);

    verbose(
        'Baked $total/$total recipes in ${duration.inMilliseconds} ms, using strategy=$strategy. Yields context: $context');
  }
}

enum BakeStrategy { sequential, parallel }
