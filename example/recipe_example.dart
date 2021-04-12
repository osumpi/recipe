import 'dart:io';

import 'package:recipe/recipe.dart';

class ChocolateCake extends Recipe {
  @override
  String get name => 'Cake';

  @override
  String get description => 'Cake';

  @override
  String get author => 'Me';

  @override
  String get version => 'Test';

  Stream<BakeState> bake(BakeContext context) async* {
    yield BakeState.baking(0);
    await Future.delayed(const Duration(milliseconds: 1000));
    yield BakeState.baked();
  }
}

class DebugPrintQuantityRecipe extends Recipe {
  @override
  String get name => 'DebugPrintQuantityRecipe';

  @override
  String get description => 'DebugPrintQuantityRecipe';

  @override
  String get author => 'Me';

  @override
  String get version => 'Test';

  Stream<BakeState> bake(BakeContext context) async* {
    yield BakeState.baking(0);

    final map = Provider.of<Map<String, int>>(context);

    if (map != null) {
      print("\n\n${map["quantity"]}\n\n");
    }

    await Future.delayed(const Duration(milliseconds: 1000));

    yield BakeState.baked();
  }
}

void main() async {
  Map<String, int> args = {"quantity": 10};

  bool completed = false;
  BakeState state = BakeState.awaiting();

  RecipeDriver()
      .drive(
    Baker.sequential(
      [
        ChocolateCake(),
        Provider.value(
          args,
          recipe: Baker.sequential([
            ChocolateCake(),
            DebugPrintQuantityRecipe(),
          ]),
        ),
        Baker.simultaneous([
          ChocolateCake(),
          ChocolateCake(),
        ]),
        ChocolateCake(),
      ],
    ),
  )
      .listen((event) {
    state = event;
    completed = event.isBaked;
  });

  final frames = ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'];

  int i = 0;

  while (true) {
    stdout.write('\x1B[2K\x1B[1G'); // Clear line and put cursor at col 1.
    i = (i + 1) % frames.length;
    stdout.write('$state \t ${frames[i]}');
    if (completed) break;
    await Future.delayed(const Duration(milliseconds: 80));
  }

  print("");
}
