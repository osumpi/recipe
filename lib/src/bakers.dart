part of recipe;

mixin Pausable {
  bool _isPaused = false;

  bool get isPaused => _isPaused;

  void pause() => _isPaused = true;
  void resume() => _isPaused = false;

  Stream<BakeState> handlePause(double progress) async* {
    yield BakeState.paused(progress);

    await Future.doWhile(() => isPaused);

    yield BakeState.baking(progress);
  }
}

@sealed
abstract class Baker extends _InbuiltRecipe {
  final Map<Recipe, BakeState> _recipeStates;

  static Map<Recipe, BakeState> _transformRecipeStates(
      Iterable<Recipe> recipes) {
    return Map.fromIterable(recipes,
        key: (r) => r, value: (_) => BakeState.awaiting);
  }

  Iterable<Recipe> get recipes => _recipeStates.keys;

  Baker(Iterable<Recipe> recipes)
      : assert(
            recipes.isNotEmpty,
            "Baker's don't grown on trees. "
            "Avoid using a `Baker` without allocating atleast one recipe to them."),
        _recipeStates = _transformRecipeStates(recipes);

  factory Baker.sequential(
    Iterable<Recipe> bakes, {
    bool isAbortive = true,
  }) =>
      SequentialBaker._(bakes, isAbortive: isAbortive);

  factory Baker.simultaneous(Iterable<Recipe> bakes) =>
      SimultaneousBaker._(bakes);

  bool get isConcurrent => this is SimultaneousBaker;

  double computeProgress() {
    return _recipeStates.values.fold<double>(0.0, (p, e) => p + e.progress) /
        _recipeStates.length;
  }
}

@sealed
class SimultaneousBaker extends Baker {
  SimultaneousBaker._(Iterable<Recipe> recipes) : super(recipes);

  @override
  String get name => 'Baker.simultaneous';

  @override
  String get description => 'Baker that bakes recipes concurrently.';

  @override
  Stream<BakeState> bake(BakeContext context) async* {
    yield BakeState.baking(0.0);

    yield BakeState.combine({
      ...await Future.wait([
        for (final recipe in recipes) recipe.bake(context).last,
      ])
    });
  }
}

class SequentialBaker extends Baker with Pausable {
  final bool isAbortive;

  SequentialBaker._(
    Iterable<Recipe> recipes, {
    required this.isAbortive,
  }) : super(recipes);

  @override
  String get name => 'Baker.sequential';

  @override
  String get description =>
      'Baker that bakes recipes in sequence, one after another.';

  @override
  Stream<BakeState> bake(BakeContext context) async* {
    yield BakeState.awaiting;

    bool aborted = false;
    double progress = computeProgress();

    for (final recipe in recipes) {
      // handle pause
      if (isPaused) {
        yield* handlePause(progress);
      }

      await for (final state in recipe.bake(context)) {
        _recipeStates[recipe] = state;

        progress = computeProgress();

        yield BakeState.baking(progress);

        // whether recipe.bake was abortive and baker is abortive.
        aborted = state.isAbortive;
      }

      if (aborted &= isAbortive) break;
    }

    yield aborted ? BakeState.abortive : BakeState.baked;
  }
}

class Isolated extends _InbuiltRecipe {
  final Recipe recipe;
  final BakeState maskedWith;

  @override
  String get name => 'IsolatedRecipe';

  @override
  String get description =>
      "Isolate a Recipe that may return BakeState.Abortive after it's bake completed.";

  Isolated({
    required this.maskedWith,
    required this.recipe,
  })   : assert(
          !maskedWith.isAbortive,
          "Avoid using Isolated to relay abortive bake state."
          "maskedWith: `BakeState.abortive` diminishes the intended usage of"
          "Isolated. Additionally, it adds an unnecessary propogation layer.",
        ),
        assert(
          recipe is! Baker,
          "Avoid wrapping Baker with Isolated as it has no effect."
          "Baker.simultaneous is by nature an isolated recipe. "
          "Baker.sequential can be made isolated by setting abortive: false"
          "in it's factory constructor.",
        );

  @override
  Stream<BakeState> bake(BakeContext context) {
    return recipe
        .bake(context)
        .map((state) => state.isAbortive ? maskedWith : state);
  }
}
