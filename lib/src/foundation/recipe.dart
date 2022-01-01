import 'dart:async';

import 'package:meta/meta.dart';
import 'package:recipe/bakers.dart';

import 'bake_context.dart';
import 'bake_state.dart';
import 'baker.dart';
import 'port.dart';
import 'utils.dart';

abstract class Recipe with FrameworkEntity, EntityLogging {
  Recipe();

  final _inputPorts = <InputPort<dynamic>>{};

  final _outputPorts = <OutputPort<dynamic>>{};

  @nonVirtual
  @internal
  late final Baker baker;

  void registerPort(final Port<dynamic> port) {
    if (port is InputPort) {
      _inputPorts.add(port);
      // Initialize the port
    } else if (port is OutputPort) {
      _outputPorts.add(port);
      // Initialize the port
    }
  }

  @mustCallSuper
  @protected
  Future<void> initialize() async {
    ensureUniqueInputPortLabels();
    ensureUniqueOutputPortLabels();

    baker = createBaker()..bind(this);

    // TODO: access all output ports and initialize their target recipes.
  }

  /// Disallows input ports with same label.
  @internal
  @protected
  @nonVirtual
  void ensureUniqueInputPortLabels() {
    final duplicates = _findPortWithDuplicateNamesIn(_inputPorts);

    assert(
      duplicates.isEmpty,
      'Recipe contains input ports with non-unique labels',
    );

    if (duplicates.isNotEmpty) {
      warn(
        'Recipe contains ${duplicates.length} input ports with non-unique '
        'labels: $duplicates.',
      );
    }
  }

  /// Disallows output ports with same label.
  @internal
  @protected
  @nonVirtual
  void ensureUniqueOutputPortLabels() {
    final duplicates = _findPortWithDuplicateNamesIn(_outputPorts);

    assert(
      duplicates.isEmpty,
      'Recipe contains output ports with non-unique labels',
    );

    if (duplicates.isNotEmpty) {
      warn(
        'Recipe contains ${duplicates.length} output ports with non-unique '
        'labels: $duplicates.',
      );
    }
  }

  @protected
  Baker createBaker() => ConcurrentBaker();

  @mustCallSuper
  @internal
  Stream<BakeState> bake(final BakeContext context);
}

Iterable<String> _findPortWithDuplicateNamesIn(
  final Iterable<Port<dynamic>> ports,
) {
  final duplicates = <String>{}, names = <String>{};

  for (final port in ports) {
    if (!names.add(port.name)) {
      duplicates.add(port.name);
    }
  }

  return duplicates;
}
