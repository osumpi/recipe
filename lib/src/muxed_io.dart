import 'dart:collection';

import 'package:recipe/recipe.dart';

typedef MuxedInputs = UnmodifiableMapView<InputPort<dynamic>, dynamic>;
typedef MuxedOutput = List<MapEntry<OutputPort<dynamic>, dynamic>>;

abstract class MuxedOutputAdapter {
  static MuxedOutput of(final BakeContext<dynamic> context) => [];
}

extension MuxedOutputExtension on MuxedOutput {
  void writeTo<T>(final OutputPort<T> outputPort, {required final T data}) {
    add(MapEntry(outputPort, data));
  }
}
