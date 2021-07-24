part of recipe;

class Provider<T extends Object> extends Recipe {
  final T value;

  final Recipe recipe;

  const Provider.value(
    this.value, {
    required this.recipe,
  });

  bake(BakeContext context) => context.bake(recipe);

  static T? of<T>(BakeContext? context) {
    // TODO: do: context.getAncestorOfExactType<Provider<T>>.value

    assert(false, "Couldn't find a Provider of $T");
  }
}
