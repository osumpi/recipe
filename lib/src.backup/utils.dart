part of recipe.old;

typedef JsonMap = Map<String, dynamic>;

mixin _RecipeFrameworkEntity {
  String get name => runtimeType.toString();

  JsonMap toJson();
}

void bake(Recipe recipe) {
  throw UnimplementedError();
}
