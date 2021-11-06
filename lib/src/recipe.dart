import 'dart:async';
import 'dart:collection';

import 'package:meta/meta.dart';

import 'package:recipe/src/bake_context.dart';
import 'package:recipe/src/framework_entity.dart';
import 'package:recipe/src/ports/ports.dart';
import 'package:recipe/src/utils.dart';

abstract class Recipe<I extends Object, O extends Object>
    with FrameworkEntity, EntityLogging {
  Recipe({
    required this.inputPort,
    required this.outputPort,
  });

  final InputPort<I> inputPort;
  final OutputPort<O> outputPort;

  @mustCallSuper
  @protected
  void initialize() {}

  @mustCallSuper
  @internal
  Stream<O> bake(BakeContext<I> context);

  @override
  JsonMap toJson() {
    return {
      ...super.toJson(),
    };
  }
}

typedef MuxedInputs = UnmodifiableMapView<InputPort, Object>;
typedef MuxedOutput = UnmodifiableMapView<OutputPort, Object>;

abstract class MultiIORecipe extends Recipe<MuxedInputs, MuxedOutput> {
  MultiIORecipe()
      : super(
          inputPort: SingleInboundInputPort<MuxedInputs>(uuid.v4()),
          outputPort: OutputPort<MuxedOutput>(uuid.v4()),
        );

  final Set<InputPort> _inputPorts = {};

  UnmodifiableSetView<InputPort> get inputPorts =>
      UnmodifiableSetView(_inputPorts);

  final Set<OutputPort> _outputPorts = {};

  UnmodifiableSetView<OutputPort> get outputPorts =>
      UnmodifiableSetView(_outputPorts);

  /// Disallows input ports with same label.
  /// TODO: maybe conside disabling this check by overriding global parameters
  @internal
  @protected
  @nonVirtual
  void ensureUniqueInputPortLabel(String label) {
    if (_inputPorts.any((element) => element.name == label)) {
      throw ArgumentError(
        '$runtimeType already has input port with label: $label.',
        'label',
      );
    }
  }

  /// Disallows output ports with same label.
  /// TODO: maybe conside disabling this check by overriding global parameters
  @internal
  @protected
  @nonVirtual
  void ensureUniqueOutputPortLabel(String label) {
    if (_outputPorts.any((element) => element.name == label)) {
      throw ArgumentError(
        '$runtimeType already has output port with label: $label.',
        'label',
      );
    }
  }

  @protected
  @nonVirtual
  @useResult
  SingleInboundInputPort<T> hookSingleInboundInputPort<T extends Object>(
      String label) {
    ensureUniqueInputPortLabel(label);
    final result = SingleInboundInputPort<T>(label);
    _inputPorts.add(result);
    return result;
  }

  @protected
  @nonVirtual
  @useResult
  MultiInboundInputPort<T> hookInputPort<T extends Object>(String label) {
    ensureUniqueInputPortLabel(label);
    final result = MultiInboundInputPort<T>(label);
    _inputPorts.add(result);
    return result;
  }

  @protected
  @nonVirtual
  @useResult
  OutputPort<T> hookOutputPort<T extends Object>(String label) {
    ensureUniqueOutputPortLabel(label);
    final result = OutputPort<T>(label);
    _outputPorts.add(result);
    return result;
  }

  @mustCallSuper
  @internal
  Stream<MuxedOutput> bake(BakeContext<MuxedInputs> context);
}
