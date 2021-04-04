part of recipe;

class BakeContext {
  const BakeContext();
}

@immutable
class BakeResult {
  static const Unknown = BakeResult._('Unknown');
  static const Success = BakeResult._('Success');
  static const Failed = BakeResult._('Failed');
  static const PartiallyFailed = BakeResult._('PartiallyFailed');

  static const values = [Unknown, Success, Failed, PartiallyFailed];

  const BakeResult._(final String value) : _value = value;

  factory BakeResult.combineFrom(Iterable<BakeResult> results) {
    try {
      return Set.from(results).single;
    } on StateError {
      return BakeResult.PartiallyFailed;
    }
  }

  final String _value;

  @override
  String toString() => 'BakeResult.$_value';
}

extension RecipeListExtension on Iterable<Recipe> {
  void bakeParallel(BakeContext context) =>
      BakeController.parallel(this).bake(context);

  void bakeSeries(BakeContext context) =>
      BakeController.sequential(this).bake(context);
}

Future<BakeResult> bake(Recipe recipe) {
  return recipe.bake(BakeContext());
}
