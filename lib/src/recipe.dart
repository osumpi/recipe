import 'dart:async';

import 'package:meta/meta.dart';

import 'bake_context.dart';
import 'framework_entity.dart';
import 'muxed_io.dart';
import 'ports/ports.dart';
import 'utils.dart';

abstract class Recipe<I, O> with FrameworkEntity, EntityLogging {
  Recipe({
    required final this.inputPort,
    required final this.outputPort,
  });

  final InputPort<I> inputPort;
  final OutputPort<O> outputPort;

  @mustCallSuper
  @protected
  void initialize() {}

  @mustCallSuper
  @internal
  Stream<O> bake(final BakeContext<I> context);

  @override
  JsonMap toJson() {
    return {
      ...super.toJson(),
    };
  }
}

abstract class MultiIORecipe extends Recipe<MuxedInputs, MuxedOutput> {
  MultiIORecipe()
      : super(
          inputPort: SingleInboundInputPort<MuxedInputs>(uuid.v4()),
          outputPort: OutputPort<MuxedOutput>(uuid.v4()),
        );

  Set<InputPort<dynamic>> get inputPorts;
  Set<OutputPort<dynamic>> get outputPorts;

  @override
  void initialize() {
    if (inputPorts.isEmpty && outputPorts.isEmpty) {
      // TODO: describe this error in depth and give possible solutions
      throw StateError(
        "`inputPorts.isEmpty && outputPorts.isEmpty` was evaluated to true.",
      );
    }

    // TODO: maybe consider disabling this check by overriding global parameters
    ensureUniqueInputPortLabels();
    ensureUniqueOutputPortLabels();

    super.initialize();
  }

  /// Disallows input ports with same label.
  @internal
  @protected
  @nonVirtual
  void ensureUniqueInputPortLabels() {
    final names = <String>{};

    for (final port in inputPorts) {
      if (!names.add(port.name)) {
        throw ArgumentError(
          '$name already has input port with label: ${port.name}.',
          'label',
        );
      }
    }
  }

  /// Disallows output ports with same label.
  @internal
  @protected
  @nonVirtual
  void ensureUniqueOutputPortLabels() {
    final names = <String>{};

    for (final port in outputPorts) {
      if (!names.add(port.name)) {
        throw ArgumentError(
          '$name already has output port with label: ${port.name}.',
          'label',
        );
      }
    }
  }

  @mustCallSuper
  @internal
  @override
  Stream<MuxedOutput> bake(final BakeContext<MuxedInputs> context);
}
