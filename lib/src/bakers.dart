part of recipe;

@sealed
abstract class Baker extends _InbuiltRecipe {
  final Iterable<Recipe> recipes;

  Baker(this.recipes);

  factory Baker.sequential({
    required Iterable<Recipe> bakes,
    bool isAbortive = true,
  }) =>
      SequentialBaker._(bakes, isAbortive: isAbortive);

  factory Baker.simultaneous({required Iterable<Recipe> bakes}) =>
      SimultaneousBaker._(bakes);

  bool get isConcurrent => this is SimultaneousBaker;
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
    yield BakeState.Baking;

    yield BakeState.combine({
      ...await Future.wait([
        for (final recipe in recipes) recipe.bake(context).last,
      ])
    });
  }
}

class SequentialBaker extends Baker {
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

  bool _isPaused = false;

  bool get isPaused => _isPaused;

  void pause() => _isPaused = true;
  void resume() => _isPaused = false;

  @override
  Stream<BakeState> bake(BakeContext context) async* {
    yield BakeState.Baking;

    var result = BakeState.Awaiting;

    for (final recipe in recipes) {
      if (isPaused) {
        yield BakeState.Paused;
        await Future.doWhile(() => isPaused);

        yield BakeState.Baking;
      }

      result |= await recipe.bake(context).last;

      if (isAbortive && result == BakeState.Abortive) break;
    }

    yield result;
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
          maskedWith != BakeState.Abortive,
          "Avoid using Isolated to relay ${BakeState.Abortive}."
          "maskedWith: ${BakeState.Abortive} diminishes the intended usage of"
          "Isolated. Additionally, it adds an unnecessary propogation layer.",
        ),
        assert(
          recipe is! Baker,
          "Avoid wrapping Baker with Isolated as it has no effect."
          "Baker.parallel is by nature an isolated recipe. "
          "Baker.sequential can be made isolated by setting abortive: false"
          "in it's factory constructor.",
        );

  @override
  Stream<BakeState> bake(BakeContext context) {
    return recipe
        .bake(context)
        .map((event) => event == BakeState.Abortive ? maskedWith : event);
  }
}
