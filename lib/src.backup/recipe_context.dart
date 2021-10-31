part of recipe.old;

@immutable
class RecipeContext with _RecipeFrameworkEntity {
  RecipeContext(this.id, this._data);

  final String id;

  final JsonMap _data;

  get(String key) => _data[key];

  @override
  JsonMap toJson() => _data;
}
