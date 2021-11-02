import 'dart:async';

import 'package:meta/meta.dart';

import 'package:recipe/src/utils.dart';
import 'package:recipe/src/bake_context.dart';
import 'package:recipe/src/ports/ports.dart';

abstract class Recipe<Input extends BakeContext, Output extends BakeContext>
    with FrameworkEntity {
  InputPort<Input> get inputPort;
  OutputPort<Output> get outputPort;

  bool isInitialized = false;

  Recipe() {
    register();
  }

  /// Initializes the recipe.
  // @mustCallSuper
  // void initialize() {
  //   if (isInitialized) {
  //     warn('Already initialized');
  //   }

  //   isInitialized = true;
  // }

  @protected
  Stream<Output> bake(Input context);

  @override
  JsonMap toJson() {
    return {
      'recipe': runtimeType.toString(),
      'input port': inputPort.hashCode,
      'output port': outputPort.hashCode,
    };
  }
}
