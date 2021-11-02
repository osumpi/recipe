import 'dart:async';

import 'package:recipe/recipe.dart';

void main() {
  RecipeA().outputPort.connectTo(RecipeB().inputPort, wireless: true);

  final sketch = SketchRegistry.exportToYaml();

  print(sketch);
}

class MyContext extends BakeContext {}

class RecipeA extends Recipe<MyContext, BakeContext> {
  final inputPort = InputPort('input of A');

  final outputPort = OutputPort('output of A');

  @override
  Stream<BakeContext> bake(MyContext context) {
    throw UnimplementedError();
  }
}

class RecipeB extends Recipe {
  final inputPort = InputPort('input of B');

  final outputPort = OutputPort('output of B');

  @override
  Stream<BakeContext> bake(BakeContext context) {
    throw UnimplementedError();
  }
}
