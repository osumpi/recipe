part of recipe.baker;

mixin _NonConcurrentBakerMixin on Baker {
  @override
  @nonVirtual
  final concurrencyAllowed = false;

  @override
  bool get canBake => isIdle;

  @override
  void requestBake(final BakeContext<dynamic> inputContext) {
    if (canBake) {
      bake(inputContext);
    } else {
      handleBakeRequestWhenBaking(inputContext);
    }
  }

  void handleBakeRequestWhenBaking(final BakeContext<dynamic> inputContext);
}
