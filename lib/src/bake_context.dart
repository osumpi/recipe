part of recipe;

@sealed
abstract class BakeContext {
  /// The current configuration of the [Recipe] that is this [BakeContext].
  Recipe get recipe;

  /// The [Baker] for this context. The [Baker] is in charge of managing the
  /// execution pipeline for this context.
  Baker get baker;

  /// The [BakeContext] of the parent [Recipe] of [recipe].
  BakeContext? get _parent;

  String get path;

  bool get hasParent => _parent != null;

  RecipeStream bake(Recipe child) => Baker(child, this).run();

  toString() => 'BakeContext of $recipe';
}

class Baker extends BakeContext {
  Baker(this.recipe, this._parent) : path = _findPath(recipe, _parent);

  final recipe, _parent, path;

  get baker => this;

  /// Finds the path to [recipe] with respect to [parent].
  static String _findPath(Recipe recipe, BakeContext? parent) {
    if (parent == null) {
      return '${recipe.name}';
    } else {
      return '${parent.recipe.name}/${recipe.name}';
    }
  }

  toString() => 'Baker of $recipe';

  @protected
  RecipeStream run() async* {
    // recipe.initState();

    yield* recipe.bake(this);

    // recipe.dispose();
  }
}
