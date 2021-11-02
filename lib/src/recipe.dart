import 'dart:async';

import 'package:meta/meta.dart';

import 'package:recipe/src/utils.dart';
import 'package:recipe/src/bake_context.dart';
import 'package:recipe/src/io_mixins.dart';
import 'package:recipe/src/sketch_registry.dart';

abstract class Recipe<I extends BakeContext, O extends BakeContext>
    with FrameworkEntity, InputMixin<I>, OutputMixin<O> {
  bool isInitialized = false;

  /// Initializes the recipe.
  @mustCallSuper
  void initialize() {
    if (isInitialized) {
      warn('Already initialized');
    }

    SketchRegistry.registerRecipe(this);

    isInitialized = true;
  }

  @protected
  Stream<O> bake(I context);

  @override
  JsonMap toJson() {
    return {
      'recipe': runtimeType.toString(),
      'input port': inputPort.hashCode,
      'output port': outputPort.hashCode,
    };
  }
}
