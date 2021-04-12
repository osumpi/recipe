part of recipe;

class RecipeDriver {
  const RecipeDriver();

  factory RecipeDriver.of(BakeContext context) =>
      _RecipeDriverWithAncestor(context);

  Stream<BakeState> drive(Recipe recipe) async* {
    final context = BakeContext._for(recipe, ancestor: null);

    await for (final state in recipe.bake(context)) {
      yield context.state = state;
    }
  }
}

class _RecipeDriverWithAncestor extends RecipeDriver {
  final BakeContext _ancestorContext;

  const _RecipeDriverWithAncestor(BakeContext context)
      : _ancestorContext = context;

  Stream<BakeState> drive(Recipe recipe) async* {
    final context = _ancestorContext.adopt(recipe);

    await for (final state in recipe.bake(context)) {
      yield context.state = state;
    }
  }
}
