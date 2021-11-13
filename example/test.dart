import 'dart:async';
import 'package:recipe/recipe.dart';

Future<void> main() async {
  // bake(MySimpleRecipe());
  // bake(BitComplexRecipe());
}

// Recipe that converts integer to string.
class MySimpleRecipe extends Recipe<int, String> {
  @override
  final inputPort = MultiInboundInputPort('value');

  @override
  final outputPort = OutputPort('asString');

  @override
  Stream<String> bake(final BakeContext<int> context) async* {
    yield context.data.toString();
  }
}

// TODO: PREFER num OVER int / double FOR COMPATABILITY

// Recipe block that takes two numbers, and yields their quotient and remainder.
class BitComplexRecipe extends MultiIORecipe {
  final numeratorPort = MultiInboundInputPort<int>('numerator');
  final denominatorPort = MultiInboundInputPort<int>('denominator');

  final quotientPort = OutputPort('quotient');
  final remainderPort = OutputPort('remainder');

  @override
  Set<InputPort<dynamic>> get inputPorts => {numeratorPort, denominatorPort};

  @override
  Set<OutputPort<dynamic>> get outputPorts => {quotientPort, remainderPort};

  @override
  Stream<MuxedOutput> bake(final BakeContext<MuxedInputs> context) async* {
    final numerator = numeratorPort.data;
    final denominator = denominatorPort.data;

    final quotient = (numerator / denominator).truncate();
    final remainder = numerator % denominator;

    yield MuxedOutputAdapter.of(context)
      ..writeTo(quotientPort, data: quotient)
      ..writeTo(remainderPort, data: remainder);
  }
}
