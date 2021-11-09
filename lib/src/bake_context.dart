import 'dart:collection' show UnmodifiableMapView;

import 'package:meta/meta.dart';
import 'package:recipe/src/typedefs.dart';
import 'package:recipe/src/framework_entity.dart';
import 'package:recipe/src/utils.dart';

@immutable
class BakeContext<T> with FrameworkEntity, EntityLogging {
  @internal
  BakeContext({
    required final this.recipe,
    required final this.data,
    required final Map<AnyInputPort, AnyBakeContext> parentContexts,
  }) : parentContexts = UnmodifiableMapView(parentContexts);

  final T data;

  final AnyRecipe recipe;

  final Map<AnyInputPort, AnyBakeContext> parentContexts;

  Iterable<AnyRecipe> get parents =>
      parentContexts.values.map((final e) => e.recipe);

  bool get hasParent => parents.isNotEmpty;

  // TODO: improve json expansion
  @override
  JsonMap toJson() {
    return {
      ...super.toJson(),
      'of': recipe.hashCode,
      'parent context': {...parentContexts}
    };
  }
}
