import 'dart:collection' show UnmodifiableMapView;

import 'package:meta/meta.dart';
import 'package:recipe/src/framework_entity.dart';
import 'package:recipe/src/ports/ports.dart';
import 'package:recipe/src/recipe.dart' show Recipe;
import 'package:recipe/src/utils.dart';

@immutable
class BakeContext<T extends Object> with FrameworkEntity, EntityLogging {
  @internal
  BakeContext({
    required final Recipe of,
    required this.data,
    required Map<InputPort, BakeContext> inputContexts,
  })  : recipe = of,
        parentContext = UnmodifiableMapView(inputContexts);

  final T data;

  final Recipe recipe;

  final UnmodifiableMapView<InputPort, BakeContext> parentContext;

  Iterable<Recipe> get parents => parentContext.values.map((e) => e.recipe);

  bool get hasParent => parents.isNotEmpty;

  // TODO: improve json expansion
  @override
  JsonMap toJson() {
    return {
      ...super.toJson(),
      'of': recipe.hashCode,
      'parent context': {...parentContext}
    };
  }
}
