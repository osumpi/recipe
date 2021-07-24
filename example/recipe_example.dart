import 'package:recipe/recipe.dart';

main() => bake(Coffee());

@PublicRecipe(name: 'Coffee')
class Coffee extends Recipe {
  bake(context) async* {
    yield Provider.value(
      // Wait until you get a coffee cup
      await CoffeeCup.request(),

      // then runs the following.
      recipe: Parallel([
        DispenseSugar('2 teaspoon'),
        DispenseCoffeePowder('1 teaspoon'),
      ]),
      // TODO: add builder and recipe
    );
  }
}

class CoffeeCup {
  static Future<CoffeeCup> request() async => CoffeeCup();
}

class DispenseSugar extends Recipe {
  const DispenseSugar(String qty);

  bake(context) async* {}
}

class DispenseCoffeePowder extends Recipe {
  const DispenseCoffeePowder(String qty);
  bake(context) async* {}
}
