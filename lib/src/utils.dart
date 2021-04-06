part of recipe;

enum BakeState {
  Ready,
  Running,
  Paused,
  Abortive,
  CompletedSuccesfully,
  CompletedPartially,
  CompletedUnsuccessfully,
}

extension _MultiBakeStateEvaluator on BakeState {
  static BakeState combineFrom(Iterable<BakeState> states) {
    return BakeState.Ready;
  }
}

class BakeContext {
  const BakeContext();
}

// @immutable
// class BakeResult {
//   static const Unknown = BakeResult._('Unknown');
//   static const Success = BakeResult._('Success');
//   static const Failed = BakeResult._('Failed');
//   static const PartiallyFailed = BakeResult._('PartiallyFailed');

//   static const values = [Unknown, Success, Failed, PartiallyFailed];

//   const BakeResult._(final String value) : _value = value;

//   factory BakeResult.combineFrom(Iterable<BakeResult> results) {
//     try {
//       return Set.from(results).single;
//     } on StateError {
//       return BakeResult.PartiallyFailed;
//     }
//   }

//   final String _value;

//   @override
//   String toString() => 'BakeResult.$_value';
// }

extension RecipeListExtension on Iterable<Recipe> {
  void bakeParallel(BakeContext context) => Baker.parallel(this).bake(context);

  void bakeSeries(BakeContext context) => Baker.sequential(this).bake(context);
}

Future<BakeState> bake(Recipe recipe) {
  return recipe.bake(BakeContext());
}
