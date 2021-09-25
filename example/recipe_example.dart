/// From Package: https://github.com/alexei-sintotski/json2yaml
/// https://github.com/alexei-sintotski/json2yaml/blob/master/example/main.dart

import 'package:fhir_yaml/fhir_yaml.dart';

// ignore_for_file: avoid_print

void main() {
  const developerData = {
    'name': "Martin D'vloper",
    'job': 'Developer',
    'skill': 'Elite',
    'employed': true,
    'foods': ['Apple', 'Orange', 'Strawberry', 'Mango'],
    'languages': {
      'perl': 'Elite',
      'python': 'Elite',
      'pascal': 'Lame',
    },
    'education': '4 GCSEs\n3 A-Levels\nBSc in the Internet of Things'
  };

  print(json2yaml(developerData));
}
// import 'package:recipe/recipe.dart';

// main() => bake(Coffee());

// @PublicRecipe(name: 'Coffee')
// class Coffee extends Recipe {
//   bake(context) async* {
//     yield Provider.value(
//       // Wait until you get a coffee cup
//       await CoffeeCup.request(),

//       // then runs the following.
//       recipe: Parallel([
//         DispenseSugar('2 teaspoon'),
//         DispenseCoffeePowder('1 teaspoon'),
//       ]),
//       // TODO: add builder and recipe
//     );
//   }
// }

// class CoffeeCup {
//   static Future<CoffeeCup> request() async => CoffeeCup();
// }

// class DispenseSugar extends Recipe {
//   const DispenseSugar(String qty);

//   bake(context) async* {}
// }

// class DispenseCoffeePowder extends Recipe {
//   const DispenseCoffeePowder(String qty);
//   bake(context) async* {}
// }
