part of recipe;

/// This class implements the abstract model of [Recipe].
///
/// In BakeCode, a custom [Recipe] may be implemented using one more [Recpie]s.
/// [Recipe] provides the required abstraction for performing [Recipe.bake]
/// while being able to work with the BakeCode Ecosystem.
abstract class Recipe {
  /// The name of this [Recipe].
  String get name;

  /// The author of this [Recipe].
  String get author;

  /// The version of this [Recipe].
  String get version;

  /// The description of this [Recipe].
  String get description;

  const Recipe();

  /// Parse [Recipe] from YAML source.
  factory Recipe.parse(String source, {Uri? url}) {
    Recipe fromMap(map) {
      if (map == null) {
        throw NullThrownError();
      } else {
        return _ParsedRecipe.fromMap(map);
      }
    }

    return checkedYamlDecode(source, fromMap, sourceUrl: url, allowNull: true);
  }

  /// Bake's the [Recipe].
  /// [context] is the [BakeContext] provided by [RecipeDriver.drive] method.
  ///
  /// [bake] shall not be invoked, other than by [RecipeDriver].
  ///
  /// **Returns**
  /// [Stream] of [BakeState].
  @protected
  Stream<BakeState> bake(BakeContext context);

  /// The string representation of the [Recipe] instance.
  ///
  /// Format: `Recipe($name $version)`
  @override
  String toString() => 'Recipe($name $version)';
}
