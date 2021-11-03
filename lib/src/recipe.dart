import 'package:meta/meta.dart';

import 'package:recipe/src/bake_context.dart';
import 'package:recipe/src/framework_entity.dart';
import 'package:recipe/src/utils.dart';

abstract class Recipe<In extends BakeContext, Out extends BakeContext>
    with FrameworkEntity, EntityLogging {
  const Recipe();

  @protected
  @mustCallSuper
  Stream<Out> bake(In context);

  @override
  JsonMap toJson() {
    return {
      ...super.toJson(),
    };
  }
}
