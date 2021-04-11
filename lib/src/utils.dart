part of recipe;

extension RecipeListExtension on Iterable<Recipe> {
  Baker get simultaneous => Baker.simultaneous(this);
  Baker get sequential => Baker.sequential(this);
}
