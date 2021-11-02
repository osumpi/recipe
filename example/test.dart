import 'package:recipe/recipe.dart';

void main() async {
  final a = RecipeA(), b = RecipeB();
  a.outputPort.connectTo(b.inputPort, wireless: true);

  // await SketchRegistry.exportToSketchFile(recipeName: 'my_recipe');

  SketchRegistry.initializeAllRecipes();

  a.inputPort.events.sink.add(MyContext());
}

class MyContext extends BakeContext {}

class RecipeA extends Recipe<MyContext, BakeContext> {
  final inputPort = InputPort('input of A');

  final outputPort = OutputPort('output of A');

  @override
  Stream<BakeContext> bake(MyContext context) async* {
    print('$name baked!');
    yield BakeContext();
  }
}

class RecipeB extends Recipe {
  final inputPort = InputPort('input of B');

  final outputPort = OutputPort('output of B');

  @override
  Stream<BakeContext> bake(BakeContext context) async* {
    print('$name baked!');
    yield BakeContext();
  }
}
