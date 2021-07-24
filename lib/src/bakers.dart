part of recipe;

@PublicRecipe(
  name: 'Sequential',
  description: 'Bake multiple recipes one after another.',
)
class Sequential extends Recipe {
  const Sequential(this.recipes);

  final Iterable<Recipe> recipes;

  bake(context) async* {
    for (final recipe in recipes) {
      // TODO: add pause functionallity.

      yield* context.bake(recipe);
    }
  }
}

@PublicRecipe(
  name: 'Parallel',
  description: 'Bake multiple recipes that is started all at once.',
)
class Parallel extends Recipe {
  final bool addSemanticIndexes;

  const Parallel(
    this.recipes, {
    this.addSemanticIndexes = true,
  });

  final List<Recipe> recipes;

  bake(context) async* {
    _bake(Recipe r) => context.bake(r).toList();

    await Future.wait([
      for (final recipe in recipes.asMap().entries)
        if (addSemanticIndexes)
          _bake(
            IndexedSemantics(
              index: recipe.key,
              recipe: recipe.value,
            ),
          )
        else
          _bake(recipe.value),
    ]);
  }
}

class IndexedSemantics extends Recipe {
  get name => '$index';

  const IndexedSemantics({
    required this.index,
    required this.recipe,
  });

  final int index;

  final Recipe recipe;

  bake(context) => context.bake(recipe);
}
