part of recipe;

typedef RecipeStream = Stream<Recipe>;

/// Annotate a recipe with this class to be used as a constructable recipe
/// inside OsumPie's recipe maker. Shall be annoted only on [IRecipe]
/// implementations.
///
/// Example:
/// TODO: Write Recipe meta usage example.
/// ```
@immutable
class PublicRecipe {
  /// Name of the [Recipe] that will be shown in OsumPie's recipe editor.
  /// All public recipe's shall define this with a meaningful name.
  final String name;

  /// The authors of [Recipe].
  final String description;

  /// The description of the [Recipe].
  final Iterable<String> authors;

  /// Annotate a recipe with this class to be used as a constructable recipe
  /// inside OsumPie's recipe maker. Shall be annoted only on [Recipe]
  /// implementations.
  const PublicRecipe({
    this.name = 'No name',
    this.description = 'No description',
    this.authors = const [],
  });

  const PublicRecipe._core({
    required this.name,
    required this.description,
  }) : this.authors = _coreAuthors;

  static const _coreAuthors = ['BakeCode Core'];
}

/// This class implements the abstract model of [Recipe].
///
/// In BakeCode, a custom [Recipe] may be implemented using one more [Recpie]s.
/// [Recipe] provides the required abstraction for performing [Recipe.bake]
/// in the BakeCode Ecosystem.
abstract class Recipe {
  String get name => '$runtimeType';

  const Recipe();

  /// Bake's the [Recipe].
  /// [context] is the [BakeContext] provided by [RecipeDriver.drive] method.
  ///
  /// [bake] shall not be invoked, other than by [RecipeDriver].
  ///
  /// Returns [RecipeStream] that may yield multiple, single or no recipes.
  @protected
  RecipeStream bake(BakeContext context);
}
