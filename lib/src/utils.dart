part of recipe;

extension RecipeListExtension on Iterable<Recipe> {
  Baker get simultaneous => Baker.simultaneous(bakes: this);
  Baker get sequential => Baker.sequential(bakes: this);
}
