part of recipe;

/// [_InbuiltRecipe] shall not be extended by outside this library.
///
/// [Recipe]'s implemented in this library may extend this class so as to avoid
/// redefining [Recipe.author] and [Recipe.version].
abstract class _InbuiltRecipe extends Recipe {
  const _InbuiltRecipe();

  /// The author of this [Recipe].
  /// Pre-defined as this [Recipe] is derived from [_InbuiltRecipe].
  ///
  /// Value: `bakecode-devs`
  @nonVirtual
  String get author => 'bakecode-devs';

  /// The version of this [Recipe].
  /// Pre-defined as this [Recipe] is derived from [_InbuiltRecipe].
  ///
  /// Value: `bakecode:core`
  @nonVirtual
  String get version => 'bakecode:core';
}

Stream<BakeState> bake(Recipe recipe) {
  var specifications = ZoneSpecification(
    print: (self, parent, zone, line) {
      // TOOD: do mqtt stuff
      parent.print(zone, line);
    },
  );

  return runZoned<Stream<BakeState>>(
    () => RecipeDriver().drive(recipe),
    zoneSpecification: specifications,
  );
}
