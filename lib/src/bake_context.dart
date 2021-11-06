import 'dart:collection' show UnmodifiableMapView;

import 'package:meta/meta.dart';
import 'package:recipe/src/framework_entity.dart';
import 'package:recipe/src/utils.dart';
import 'package:recipe/src/ports/ports.dart';
import 'package:recipe/src/recipe.dart' show Recipe;

@immutable
class BakeContext with FrameworkEntity, EntityLogging {
  @internal
  BakeContext({
    required Recipe of,
    required Map<InputPort, BakeContext> inputContexts,
  })  : recipe = of,
        parentContext = UnmodifiableMapView(inputContexts);

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
