import 'dart:async';

import 'package:meta/meta.dart';

import 'package:recipe/src/bake_context.dart';
import 'package:recipe/src/framework_entity.dart';
import 'package:recipe/src/utils.dart';

abstract class Recipe with FrameworkEntity, EntityLogging {
  const Recipe();

  @mustCallSuper
  @internal
  Future<void> bake(BakeContext context);

  @override
  JsonMap toJson() {
    return {
      ...super.toJson(),
    };
  }
}
