part of recipe;

/// The driver for [Recipe]s that drives the [Recipe.bake] method by preparing
/// the right [BakeContext].
class RecipeDriver {
  /// Provides a [RecipeDriver] without an ancestor [BakeContext].
  /// This shall be used only to [drive] the top-most / root recipe.
  ///
  /// See also:
  /// * [RecipeDriver.drive]
  ///
  /// Example:
  /// ```dart
  /// void main() {
  ///   RecipeDriver().drive(MyRecipe());
  /// }
  /// ```
  const RecipeDriver();

  /// Provides a [RecipeDriver] for the recipe that may drive sub-recipes
  /// within it's [Recipe.bake] method.
  ///
  /// [context] of the recipe responsible for driving sub recipes.
  ///
  /// See also:
  /// * [RecipeDriver.drive]
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Stream<BakeState> bake(BakeContext) async* {
  ///   final driver = RecipeDriver.of(context);
  ///
  ///   yield BakeState.baking(0.0);
  ///   await driver.drive(MySubRecipe());
  ///
  ///   yield BakeState.baking(0.5);
  ///   await driver.drive(MySecondSubRecipe());
  ///
  ///   yield BakeState.baked();
  /// }
  /// ```
  factory RecipeDriver.of(BakeContext context) =>
      _RecipeDriverWithAncestor(context);

  /// Drives the [recipe] and propogates the [BakeState]'s received from
  /// the [recipe.bake]'s stream.
  Stream<BakeState> drive(Recipe recipe) async* {
    final context = BakeContext._for(recipe, ancestor: null);

    await for (final state in recipe.bake(context)) {
      yield context.state = state;
    }
  }
}

/// The [RecipeDriver] for the recipe that may drive sub-recipes within it's
/// [Recipe.bake] method by preparing the right [BakeContext].
///
/// Instances of this class shall be spawned by the factory [RecipeDriver.of].
///
/// See also:
/// * [RecipeDriver.of]
/// * [RecipeDriver.drive]
class _RecipeDriverWithAncestor extends RecipeDriver {
  /// The associated [BakeContext] of this [RecipeDriver].
  ///
  /// All [drive]s of this [RecipeDriver] will use this context to adopt the
  /// [Recipe] to be driven.
  ///
  /// See also:
  /// * [_RecipeDriverWithAncestor.drive]
  final BakeContext _ancestorContext;

  /// Provides a [RecipeDriver] for the recipe that may drive sub-recipes
  /// within it's [Recipe.bake] method.
  ///
  /// [context] of the recipe responsible for driving sub recipes.
  ///
  /// See also:
  /// * [RecipeDriver.drive]
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Stream<BakeState> bake(BakeContext) async* {
  ///   final driver = RecipeDriver.of(context);
  ///
  ///   yield BakeState.baking(0.0);
  ///   await driver.drive(MySubRecipe());
  ///
  ///   yield BakeState.baking(0.5);
  ///   await driver.drive(MySecondSubRecipe());
  ///
  ///   yield BakeState.baked();
  /// }
  /// ```
  const _RecipeDriverWithAncestor(BakeContext context)
      : _ancestorContext = context;

  /// Drives the [recipe] by using the adopted context of this [RecipeDriver]
  /// and propogates the [BakeState]'s received from the [recipe.bake]'s stream.
  Stream<BakeState> drive(Recipe recipe) async* {
    final context = _ancestorContext.adopt(recipe);

    await for (final state in recipe.bake(context)) {
      yield context.state = state;
    }
  }
}
