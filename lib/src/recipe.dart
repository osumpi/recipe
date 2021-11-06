import 'dart:async';
import 'dart:collection';

import 'package:meta/meta.dart';

import 'package:recipe/src/bake_context.dart';
import 'package:recipe/src/framework_entity.dart';
import 'package:recipe/src/ports/ports.dart';
import 'package:recipe/src/utils.dart';

abstract class Recipe with FrameworkEntity, EntityLogging {
  Recipe();

  @mustCallSuper
  @protected
  void initialize() {}

  final Set<InputPort> _inputPorts = {};

  UnmodifiableSetView<InputPort> get inputPorts =>
      UnmodifiableSetView(_inputPorts);

  final Set<OutputPort> _outputPorts = {};

  UnmodifiableSetView<OutputPort> get outputPorts =>
      UnmodifiableSetView(_outputPorts);

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
