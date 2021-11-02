import 'dart:async';

import 'package:meta/meta.dart';

import 'package:recipe/src/utils.dart';
import 'package:recipe/src/bake_context.dart';
import 'package:recipe/src/ports/ports.dart';
import 'package:recipe/src/framework_entity.dart';

abstract class Recipe<Input extends BakeContext, Output extends BakeContext>
    with FrameworkEntity {
  InputPort<Input> get inputPort;
  OutputPort<Output> get outputPort;

  Recipe() {
    register();
  }

  StreamSubscription<Input>? _subscription;

  void initialize() {
    if (_subscription != null) {
      return error('Failed to initialize recipe $name.');
    }

    _subscription = inputPort.events.stream.listen((context) {
      bake(context).listen(outputPort.write);
    });

    verbose('Recipe "$name" initialized.');
  }

  void dispose() {
    _subscription?.cancel();
    verbose('Recipe "$name" diposed');
  }

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
