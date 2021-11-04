import 'package:duration/duration.dart';
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
    final stopwatch = Stopwatch()..start();

    verbose('Baking $recipe');

    final context = BakeContext(recipe, parentContext);
    yield* recipe.bake(context);

    final duration = _composeDuration((stopwatch..stop()).elapsed);

    verbose('Baked $recipe in $duration');
  }

  Stream<BakeContext> bakeAll(
    List<Recipe> recipes, {
    BakeStrategy strategy = BakeStrategy.sequential,
  }) async* {
    final stopwatch = Stopwatch()..start();

    final total = recipes.length;
    final indexedRecipes = recipes.asMap().entries;

    var context = parentContext;

    if (strategy == BakeStrategy.sequential) {
      verbose('Sequentially baking $total recipes');

      for (final indexedRecipe in indexedRecipes) {
        final pos = indexedRecipe.key + 1;
        final recipe = indexedRecipe.value;

        context = BakeContext(recipe, context);

        trace('Baking $pos/$total: $recipe');
        yield* recipe.bake(context);
      }

      final duration = _composeDuration((stopwatch..stop()).elapsed);

      verbose('Sequentially baked $total recipes in $duration');
    } else if (strategy == BakeStrategy.parallel) {
      verbose('Parallelly baking $total recipes');

      bakeAsFuture(MapEntry<int, Recipe> indexedRecipe) async {
        final pos = indexedRecipe.key + 1;
        final recipe = indexedRecipe.value;

        trace('Baking $pos/$total: $recipe');
        return await bake(recipe).length;
      }

      await Future.wait(indexedRecipes.map(bakeAsFuture));

      context =
          recipes.fold<BakeContext?>(context, (c, r) => BakeContext(r, c));

      if (context != null) {
        yield context;
      }

      final duration = _composeDuration((stopwatch..stop()).elapsed);

      verbose('Parallelly baked $total recipes in $duration');
    }

    trace('Yields context: $context');
  }

  static String _composeDuration(Duration duration) => prettyDuration(
        duration,
        tersity: DurationTersity.millisecond,
        abbreviated: true,
        delimiter: ' ',
        spacer: '',
      );
}

enum BakeStrategy { sequential, parallel }
