part of recipe.baker;

@immutable
abstract class BakerOptions {}

class DefaultBakerOptions implements BakerOptions {
  @literal
  const DefaultBakerOptions();
}
