import 'package:recipe/recipe.dart';

void main() async {
  FrameworkUtils.setLoggingLevel(LogLevels.verbose);

  bake(MyRecipe()).listen((_) {});
}

class MyRecipe extends Recipe {
  @override
  Stream<BakeContext> bake(BakeContext context) async* {
    yield* Baker.of(context).bake(
      DecoratedDelay(
        RecipeB(),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class Delayed extends Recipe {
  final Recipe child;

  const Delayed(
    this.child, {
    required this.duration,
  });

  final Duration duration;

  @override
  Stream<BakeContext> bake(BakeContext context) async* {
    final result = context.findNearestRecipeOfExactType<MyRecipe>();
    print('got >> $result');
    await Future.delayed(duration);

    yield* Baker.of(context).bake(child);
  }
}

class DecoratedDelay extends Delayed {
  const DecoratedDelay(
    Recipe next, {
    required Duration duration,
  }) : super(next, duration: duration);

  @override
  Stream<BakeContext> bake(BakeContext context) {
    return super.bake(context);
  }
}

class RecipeB extends Recipe {
  @override
  Stream<BakeContext> bake(BakeContext context) async* {
    info(
        'visitation route: ${context.ancestors.reversed.map((r) => r.runtimeType).join(' -> ')}');
  }
}
