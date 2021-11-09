import 'dart:collection' show UnmodifiableMapView;

import 'package:meta/meta.dart';

import 'framework_entity.dart';
import 'muxed_io.dart';
import 'ports/ports.dart';
import 'recipe.dart';
import 'utils.dart';

@immutable
class BakeContext<T> with FrameworkEntity, EntityLogging {
  @internal
  BakeContext({
    required final this.recipe,
    required final this.data,
    required final Map<InputPort<dynamic>, BakeContext<dynamic>> parentContexts,
  }) : parentContexts = UnmodifiableMapView(parentContexts);

  @internal
  static BakeContext<MuxedInputs> muxFrom(
    final Map<InputPort<dynamic>, BakeContext<dynamic>> contexts, {
    required final Recipe<MuxedInputs, dynamic> recipe,
  }) {
    final data = MuxedInputs({
      for (final inputPort in contexts.keys)
        inputPort: contexts[inputPort]?.data,
    });

    return BakeContext(recipe: recipe, data: data, parentContexts: contexts);
  }

  final T data;

  final Recipe<T, dynamic> recipe;

  final Map<InputPort<dynamic>, BakeContext<dynamic>> parentContexts;

  Iterable<Recipe<dynamic, dynamic>> get parents =>
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
