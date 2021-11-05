part of recipe.bakers;

mixin _NonConcurrentBakerMixin on Baker {
  @override
  @nonVirtual
  final concurrencyAllowed = false;
}
