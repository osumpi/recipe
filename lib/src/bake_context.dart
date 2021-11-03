import 'package:meta/meta.dart';
import 'package:recipe/src/recipe.dart';

@immutable
class BakeContext {
  @internal
  BakeContext(this.recipe, this.parentContext);

  final Recipe recipe;

  final BakeContext? parentContext;

  Recipe? get parent => parentContext?.recipe;

  bool get hasParent => parent != null;

  late final path = _findPath();

  late final ancestors = _computeAncestorTree();

  String _findPath() {
    return parentContext == null
        ? '${recipe.name}'
        : '${parentContext?.path}/${recipe.name}';
  }

  List<Recipe> _computeAncestorTree() {
    final result = [recipe];

    var p = this.parentContext;

    while (p != null) {
      result.add(p.recipe);
      p = p.parentContext;
    }

    return result;
  }
}
