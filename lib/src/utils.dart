part of recipe;

@sealed
class BakeState {
  final String description;
  final int _value;

  @literal
  const BakeState._(this.description, this._value);

  static const Awaiting = const BakeState._('Awaiting', 0);
  static const Baking = const BakeState._('Baking', 0);
  static const Paused = const BakeState._('Paused', 0);
  static const Baked = const BakeState._('Baked', 1);
  static const PartiallyBaked = const BakeState._('Partially Baked', 2);
  static const Abortive = const BakeState._('Abortive', 3);

  BakeState operator |(BakeState state) =>
      state._value < this._value ? this : state;

  static BakeState combine(Iterable<BakeState> s) => s.reduce((a, b) => a | b);

  @override
  String toString() => description;
}

class BakeContext {
  const BakeContext();
}

extension RecipeListExtension on Iterable<Recipe> {
  Baker get simultaneous => Baker.simultaneous(bakes: this);
  Baker get sequential => Baker.sequential(bakes: this);
}
