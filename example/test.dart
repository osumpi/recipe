import 'dart:async';

import 'package:recipe/recipe.dart';

Future<void> main() async {
  FrameworkUtils.loggingLevel = LogLevels.verbose;
  FrameworkUtils.showTimestampInLogs = true;

  bake(MySimpleRecipe());
  bake(BitComplexRecipe());
}

// Recipe that converts integer to string.
class MySimpleRecipe extends Recipe<int, String> {
  MySimpleRecipe()
      : super(
          inputPort: MultiInboundInputPort<int>('value'),
          outputPort: OutputPort<String>('asString'),
        );

  @override
  Stream<String> bake(BakeContext<int> context) async* {
    yield context.data.toString();
  }
}

// Recipe block that takes two numbers, and yields their quotient and remainder.
class BitComplexRecipe extends MultiIORecipe {
  final numeratorPort = MultiInboundInputPort<int>('numerator');
  final denominatorPort = MultiInboundInputPort<int>('denominator');

  final quotientPort = OutputPort('quotient');
  final remainderPort = OutputPort('remainder');

  @override
  Set<InputPort> get inputPorts => {numeratorPort, denominatorPort};

  @override
  Set<OutputPort> get outputPorts => {quotientPort, remainderPort};

  @override
  Stream<MuxedOutput> bake(final BakeContext<MuxedInputs> context) async* {
    final numerator = numeratorPort.data;
    final denominator = denominatorPort.data;

    final quotient = (numerator / denominator).truncate();
    final remainder = numerator % denominator;

    yield* MuxedOutputAdapter.of(context)
      ..writeTo(quotientPort, data: quotient)
      ..writeTo(remainderPort, data: remainder);
  }
}
