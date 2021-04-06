part of recipe;

@sealed
class BakeState {
  final String description;
  final int _value;

  const BakeState._(this.description, this._value);

  static const Awaiting = const BakeState._('Awaiting', 0);
  static const Baked = const BakeState._('Baked', 1);
  static const Paused = const BakeState._('Paused', 2);
  static const PartiallyBaked = const BakeState._('Partially Baked', 3);
  static const Baking = const BakeState._('Baking', 4);
  static const Abortive = const BakeState._('Abortive', 5);

  static BakeState combine(Iterable<BakeState> states) =>
      states.reduce((a, b) => a._value > b._value ? a : b);

  @override
  String toString() => description;
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
