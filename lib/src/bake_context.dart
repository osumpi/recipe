part of recipe;

@sealed
class BakeContext {
  final Recipe recipe;

  BakeState state = BakeState.awaiting();

  final BakeContext? ancestor;

  List<BakeContext> descendants = List<BakeContext>.empty(growable: true);

  BakeContext._for(this.recipe, {required this.ancestor});

  BakeContext adopt(Recipe recipe) {
    final context = BakeContext._for(recipe, ancestor: this);
    descendants.add(context);
    return context;
  }

  bool get isRoot => ancestor == null;
  bool get hasAncestor => !isRoot;
  bool get hasDescendants => descendants.isNotEmpty;
}
