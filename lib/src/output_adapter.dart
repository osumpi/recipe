import 'package:recipe/src/bake_context.dart';
import 'package:recipe/src/ports/ports.dart';
import 'package:recipe/src/typedefs.dart';

abstract class MuxedOutputAdapter {
  static MuxedOutput of(final AnyBakeContext context) => [];
}

extension MuxedOutputExtension on MuxedOutput {
  void writeTo<T>(final OutputPort<T> outputPort, {required final T data}) {
    add(MapEntry(outputPort, data));
  }
}
