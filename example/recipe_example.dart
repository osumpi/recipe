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

void main() async {
  final recipe = Baker.sequential([
    ChocolateCake(),
    ChocolateCake(),
    ChocolateCake(),
    Baker.simultaneous([
      ChocolateCake(),
      ChocolateCake(),
    ]),
    ChocolateCake(),
  ]);

  bool completed = false;
  BakeState state = BakeState.awaiting();

  RecipeDriver().drive(recipe).listen((event) {
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
