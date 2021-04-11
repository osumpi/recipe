part of recipe;

class RecipeDriver {
  final BakeContext _ancestorContext;

  RecipeDriver.of(BakeContext context) : _ancestorContext = context;

  Stream<BakeState> drive(Recipe recipe) async* {
    final context = _ancestorContext.adopt(recipe);

    await for (final state in recipe.bake(context)) {
      context.state = state;
      yield state;
    }

    yield* recipe.bake(_ancestorContext.adopt(recipe));
  }
}
