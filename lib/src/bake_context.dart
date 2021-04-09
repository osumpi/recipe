part of recipe;

@sealed
@immutable
abstract class BakeContext {
  Recipe get recipe;

  const BakeContext();

  bool get isRoot;
  bool get hasAncestor => !isRoot;
}

class _RootContext extends BakeContext {
  final Baker recipe;

  const _RootContext(this.recipe);

  @override
  bool get isRoot => true;
}

class _InheritedContext extends BakeContext {
  final Recipe recipe;

  final BakeContext ancestor;

  const _InheritedContext(this.ancestor, this.recipe);

  bool get isRoot => false;
}
