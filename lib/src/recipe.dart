import 'package:meta/meta.dart';

import 'package:recipe/src/bake_context.dart';
import 'package:recipe/src/framework_entity.dart';
import 'package:recipe/src/utils.dart';

abstract class Recipe with FrameworkEntity, EntityLogging {
  const Recipe();

  @protected
  @mustCallSuper
  Stream<BakeContext> bake(BakeContext context);

  @override
  JsonMap toJson() {
    return {
      ...super.toJson(),
    };
  }
}

class Baker {
  const Baker.of(BakeContext? context) : parentContext = context;

  @internal
  final BakeContext? parentContext;

  Stream<BakeContext> bake(Recipe recipe) async* {
    final childContext = BakeContext(recipe, parentContext);

    yield* recipe.bake(childContext);
  }
}
