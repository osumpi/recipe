part of recipe;

@sealed
abstract class Baker extends _InbuiltRecipe {
  final Iterable<Recipe> recipes;

  int get steps => recipes.length;

  int get totalActions =>
      steps + recipes.whereType<Baker>().fold(0, (p, c) => p + c.totalActions);

  int completedSteps = 0;

  int completedActions = 0;

  Baker(this.recipes) {
    _updateState(BakeState.Awaiting);
  }

  factory Baker.sequential(Iterable<Recipe> recipes) =>
      _SequentialBakeController(recipes);

  factory Baker.parallel(Iterable<Recipe> recipes) =>
      _ParallelBakeController(recipes);

  final _currentStateController = StreamController<BakeState>();

  Stream<BakeState> get currentState => _currentStateController.stream;

  void _updateState(BakeState newState) {
    _currentStateController.sink.add(newState);
  }

  bool get isParallelController => this is _ParallelBakeController;
}

@sealed
class _ParallelBakeController extends Baker {
  _ParallelBakeController(Iterable<Recipe> recipes) : super(recipes);

  @override
  String get name => 'ParallelBakeController';

  @override
  String get description =>
      'BakeController that allows recipes to be executed in parallel';

  @override
  Future<BakeState> bake(BakeContext context) async {
    final results =
        await Future.wait([for (final recipe in recipes) recipe.bake(context)]);

    return BakeState.combine(results);
  }
}

class _SequentialBakeController extends Baker {
  final bool abortive;

  _SequentialBakeController(
    Iterable<Recipe> recipes, {
    this.abortive = true,
  }) : super(recipes);

  @override
  String get name => 'SequentialBakeController';

  @override
  String get description =>
      'BakeController that allows recipes to be executed in sequence, one after another';

  @override
  Future<BakeState> bake(BakeContext context) async {
    Set<BakeState> results = {};

    for (final recipe in recipes) {
      final result = await recipe.bake(context);

      results.add(result);

      if (abortive && result == BakeState.Abortive) {
        return BakeState.Abortive;
      }
    }

    return BakeState.combine(results);
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
