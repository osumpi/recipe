import 'dart:async';

import 'package:recipe/recipe.dart';
import 'package:recipe/src/ports/ports.dart';
import 'package:recipe/src/recipe.dart';

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
  final numeratorPort = MultiInboundInputPort('numerator');
  final denominatorPort = MultiInboundInputPort('denominator');

  final quotientPort = OutputPort('quotient');
  final remainderPort = OutputPort('remainder');

  @override
  Set<InputPort> get inputPorts => {numeratorPort, denominatorPort};

  @override
  Set<OutputPort> get outputPorts => {quotientPort, remainderPort};

  @override
  Stream<MuxedOutput> bake(BakeContext<MuxedInputs> context) async* {
    int numerator, denominator;

    // Input Extraction Approach 1: take inputs from context (NOT RECOMMENDED)
    numerator = context.data[numeratorPort] as int;
    denominator = context.data[denominatorPort] as int;

    // Input Extraction Approach 2: take input directly from the port (RECOMMENDED)
    numerator = numeratorPort.data;
    denominator = denominatorPort.data;

    final quotient = (numerator / denominator).truncate();
    final remainder = numerator % denominator;

    // Output Yielding Approach 1: pack and yield MuxedOutput
    yield MuxedOutput({
      quotientPort: quotient,
      remainderPort: remainder,
    });

    // Output Yielding Approach 2: asynchronously write to respective ports using context.repackWith
    quotientPort.write(context.repackWith(data: quotient));
    remainderPort.write(context.repackWith(data: remainder));

    // Output Yielding Approach 3: asynchronously write to respective ports using MuxedOutputAdapter
    yield* MuxedOutputAdapter.of(context)
      ..writeTo(quotientPort, data: quotient)
      ..writeTo(remainderPort, data: remainder);
  }
}
