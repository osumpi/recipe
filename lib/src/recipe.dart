import 'dart:async';

import 'package:meta/meta.dart';
import 'package:recipe/src/bake_state.dart';

import 'bake_context.dart';
import 'framework_entity.dart';
import 'muxed_io.dart';
import 'ports/ports.dart';
import 'utils.dart';

abstract class Recipe with FrameworkEntity, EntityLogging {
  const Recipe();

  Set<InputPort<dynamic>> get inputPorts;
  Set<OutputPort<dynamic>> get outputPorts;

  @mustCallSuper
  @protected
  Future<void> initialize() async {
    if (inputPorts.isEmpty && outputPorts.isEmpty) {
      // TODO: describe this error in depth and give possible solutions like call super.initialize after initilizting ports.
      throw StateError(
        "`inputPorts.isEmpty && outputPorts.isEmpty` was evaluated to true.",
      );
    }

    // TODO: maybe consider disabling this check by overriding global parameters
    ensureUniqueInputPortLabels();
    ensureUniqueOutputPortLabels();
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
  Stream<BakeState> bake(final BakeContext context);

  @override
  JsonMap toJson() {
    return {
      ...super.toJson(),
    };
  }
}
