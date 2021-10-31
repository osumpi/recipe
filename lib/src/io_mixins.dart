import 'package:recipe/src/bake_context.dart';
import 'package:recipe/src/ports/ports.dart';

mixin InputMixin<I extends BakeContext> {
  InputPort<I> get inputPort;
}

mixin OutputMixin<O extends BakeContext> {
  OutputPort<O> get outputPort;
}
