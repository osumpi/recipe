part of recipe;

abstract class Recipe {
  String get name;

  static const _kBuiltInVersion = 'built-in';

  String get version;

  String get description;

  const Recipe();

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

  @protected
  Future<BakeResult> bake(BakeContext context);

  @override
  String toString() => 'Instance of Recipe($name $version)';
}
