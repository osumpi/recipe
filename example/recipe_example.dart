import 'package:recipe/recipe.dart';

class ChocolateCake extends Recipe {
  @override
  String get name => 'ChocolateCake';

  @override
  String get description => 'Chocolate Cake';

  @override
  String get version => '';

  @override
  String get author => '';

  @override
  Future<BakeState> bake(BakeContext context) {
    return Baker.parallel([
      Batter(),
    ]).bake(context);
  }
}

class Batter extends Recipe {
  @override
  String get name => 'Batter';

  @override
  String get description => 'Batter';

  @override
  String get version => '';

  @override
  String get author => '';

  @override
  Future<BakeState> bake(BakeContext context) {
    throw UnimplementedError();
  }
}

class Cream extends Recipe {
  @override
  String get name => 'Cream';

  @override
  String get description => 'Cream';

  @override
  String get version => '';
  @override
  String get author => '';
  @override
  Future<BakeState> bake(BakeContext context) {
    throw UnimplementedError();
  }
}

class Cookies extends Recipe {
  @override
  String get name => 'Cookies';

  @override
  String get description => 'Cookies';

  @override
  String get version => '';
  @override
  String get author => '';
  @override
  Future<BakeState> bake(BakeContext context) {
    throw UnimplementedError();
  }
}

void main() {
  bake(
    Baker.parallel([
      ChocolateCake(),
      Baker.sequential([
        Cookies(),
        Batter(),
      ]),
      Cookies(),
    ]),
  );
}
