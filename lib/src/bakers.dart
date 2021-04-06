part of recipe;

@sealed
abstract class Baker extends _InbuiltRecipe {
  final Iterable<Recipe> recipes;

  Baker(this.recipes) {
    _updateState(BakeState.Awaiting);
  }

  factory Baker.sequential({
    required Iterable<Recipe> bakes,
    bool isAbortive = true,
  }) =>
      SequentialBaker._(bakes, isAbortive: isAbortive);

  factory Baker.simultaneous({required Iterable<Recipe> bakes}) =>
      SimultaneousBaker._(bakes);

  final _currentStateController = StreamController<BakeState>();

  Stream<BakeState> get currentState => _currentStateController.stream;

  BakeState _updateState(BakeState newState) {
    _currentStateController.sink.add(newState);
    return newState;
  }

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
  Future<BakeState> bake(BakeContext context) async {
    _updateState(BakeState.Baked);

    final result = BakeState.combine({
      ...await Future.wait([
        for (final recipe in recipes) recipe.bake(context),
      ])
    });

    return _updateState(result);
  }
}

class SequentialBaker extends Baker {
  final bool isAbortive;

  SequentialBaker._(
    Iterable<Recipe> recipes, {
    this.isAbortive = true,
  }) : super(recipes);

  @override
  String get name => 'Baker.sequential';

  @override
  String get description =>
      'Baker that bakes recipes in sequence, one after another.';

  @override
  Future<BakeState> bake(BakeContext context) async {
    BakeState result = BakeState.Awaiting;

    for (final recipe in recipes) {
      result |= await recipe.bake(context);

      if (isAbortive && result == BakeState.Abortive) break;
    }

    return result;
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
  Future<BakeState> bake(BakeContext context) async {
    final result = await recipe.bake(context);
    return result == BakeState.Abortive ? maskedWith : result;
  }
}
