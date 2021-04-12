part of recipe;

class Provider<T> extends _InbuiltRecipe {
  @override
  String get name => 'Provider';

  @override
  String get description => 'Super powers for BakeContext';

  final T value;

  final Recipe recipe;

  const Provider.value(
    this.value, {
    required this.recipe,
  });

  Stream<BakeState> bake(BakeContext context) {
    return RecipeDriver.of(context).drive(recipe);
  }

  static T? of<T>(BakeContext? context) {
    while (context != null) {
      var recipe = context.recipe;

      if (recipe is Provider<T>) return recipe.value;

      context = context.ancestor;
    }

    assert(false, "Couldn't find a Provider of $T");
  }
}
