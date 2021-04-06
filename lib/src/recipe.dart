part of recipe;

abstract class Recipe {
  String get name;

  String get author;

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
  Stream<BakeState> bake(BakeContext context);

  @override
  String toString() => 'Instance of Recipe($name $version)';
}

abstract class _InbuiltRecipe extends Recipe {
  @nonVirtual
  String get author => 'bakecode-devs';

  @nonVirtual
  String get version => 'bakecode:core';
}
