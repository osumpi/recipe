part of recipe;

abstract class BakeController extends Recipe {
  final Iterable<Recipe> recipes;

  BakeController(this.recipes)
      : assert(recipes.isNotEmpty),
        _currentState = BakeState.awaiting(total: recipes.length) {
    // _updateState(BakeState.awaiting(total: recipes.length));
  }

  factory BakeController.sequential(Iterable<Recipe> recipes) =>
      _SequentialBakeController(recipes);

  factory BakeController.parallel(Iterable<Recipe> recipes) =>
      _ParallelBakeController(recipes);

  final _currentStateController = StreamController<BakeState>();

  Stream<BakeState> get state => _currentStateController.stream;

  BakeState _currentState;

  void _updateState(BakeState newState) {
    _currentStateController.sink.add(newState);
  }

  // Stream<BakeState> get bakeState => _stateController.stream;

  // BakeState get currentState => _currentState;

  // void _updateState(BakeState state) {
  //   _stateController.sink.add(state);
  // }

  bool get isParallelController => this is _ParallelBakeController;
}

@sealed
class _ParallelBakeController extends BakeController {
  final BakeContext context;

  _ParallelBakeController(
    Iterable<Recipe> recipes, {
    this.context = const BakeContext(),
  }) : super(recipes);

  @override
  String get name => 'ParallelBakeController';

  @override
  String get description =>
      'BakeController that allows recipes to be executed in parallel';

  @override
  String get version => Recipe._kBuiltInVersion;

  @override
  Future<BakeResult> bake(BakeContext context) async {
    final results =
        await Future.wait([for (final recipe in recipes) recipe.bake(context)]);

    return BakeResult.combineFrom(results);
  }
}

class _SequentialBakeController extends BakeController {
  final BakeContext context;

  final bool stopOnFail;

  _SequentialBakeController(
    Iterable<Recipe> recipes, {
    this.context = const BakeContext(),
    this.stopOnFail = true,
  }) : super(recipes);

  @override
  String get name => 'SequentialBakeController';

  @override
  String get description =>
      'BakeController that allows recipes to be executed in sequence, one after another';

  @override
  String get version => Recipe._kBuiltInVersion;

  @override
  Future<BakeResult> bake(BakeContext context) async {
    Set<BakeResult> results = {};

    for (final recipe in recipes) {
      final result = await recipe.bake(context);

      results.add(result);

      if (stopOnFail &&
          (result == BakeResult.Failed || result == BakeResult.PartiallyFailed))
        break;
    }

    return BakeResult.combineFrom(results);
  }
}
