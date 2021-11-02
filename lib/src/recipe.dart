import 'dart:async';

import 'package:meta/meta.dart';

import 'package:recipe/src/utils.dart';
import 'package:recipe/src/bake_context.dart';
import 'package:recipe/src/ports/ports.dart';

abstract class Recipe<Input extends BakeContext, Output extends BakeContext>
    with FrameworkEntity {
  InputPort<Input> get inputPort;
  OutputPort<Output> get outputPort;

  Recipe() {
    register();
  }

  StreamSubscription<Output>? _subscription;

  void initialize() {
    if (_subscription != null) {
      return error('Failed to initialize recipe $name.');
    }

    _subscription = inputPort.events.stream.map(bake).listen(outputPort.write);
  }

  void dispose() {
    _subscription?.cancel();
  }

  @protected
  Output bake(Input context);

  @override
  JsonMap toJson() {
    return {
      'recipe': runtimeType.toString(),
      'input port': inputPort.hashCode,
      'output port': outputPort.hashCode,
    };
  }
}
