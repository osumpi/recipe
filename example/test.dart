import 'dart:math';

import 'package:recipe/recipe.dart';

void main() {
  final testInput = 2.0;

  final recipe1 = SineRecipe();
  final recipe2 = SineInverseRecipe();

  recipe1.yOutput.connectTo(recipe2.yInput);

  final root = RootRecipe();

  root.outputPort.connectTo(recipe1.thetaInput);

  bake(root, BakeContext(data: {'input': testInput}));
}

class RootRecipe extends Recipe {
  final outputPort = OutputPort<double>('output');

  @override
  Stream<BakeState> bake(final BakeContext context) async* {
    outputPort.write(context.data['input'] as double);
  }
}

class SineRecipe extends Recipe {
  final thetaInput = SingleInboundInputPort<double>('theta');
  final yOutput = OutputPort<double>('y');

  @override
  Stream<BakeState> bake(final BakeContext context) async* {
    warn('got ${thetaInput.data}');
    await Future.delayed(const Duration(seconds: 2));
    yOutput.write(sin(thetaInput.data));
  }
}

class SineInverseRecipe extends Recipe {
  final yInput = SingleInboundInputPort<double>('y');
  final thetaOutput = OutputPort<double>('theta');

  @override
  Stream<BakeState> bake(final BakeContext context) async* {}
}
