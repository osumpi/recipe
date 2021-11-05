part of recipe.baker;

mixin _NonConcurrentBakerMixin on Baker {
  @override
  @nonVirtual
  final concurrencyAllowed = false;
}
