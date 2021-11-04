import 'package:recipe/recipe.dart';
import 'package:recipe/src/recipe.dart';

void main() async {
  FrameworkUtils.loggingLevel = LogLevels.verbose;
  FrameworkUtils.showTimestampInLogs = false;

  bake(MyRecipe()).listen(FrameworkUtils.log);
}

class MyRecipe extends Recipe {
  @override
  Stream<BakeContext> bake(BakeContext context) async* {
    // Demonstrating sequential and parallel execution of recipes.

    final baker = Baker.of(context);

    status('Just one recipe.');
    yield* baker.bake(RecipeB());

    status('Multiple recipes one by one (sequential)');
    yield* baker.bake(RecipeB());
    yield* baker.bake(Delayed(RecipeB(), duration: const Duration(seconds: 1)));
    yield* baker.bake(RecipeB());

    status('Multiple recipes in sequential using Baker and BakeStrategy');
    yield* baker.bakeAll([
      RecipeB(),
      Delayed(RecipeB(), duration: const Duration(seconds: 1)),
      RecipeB(),
    ]);

    status('Multiple recipes in parallel using Baker and BakeStrategy');
    yield* baker.bakeAll(
      [
        RecipeB(),
        Delayed(RecipeB(), duration: const Duration(seconds: 1)),
        RecipeB(),
      ],
      strategy: BakeStrategy.parallel,
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
    trace('got >> $result');
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
    trace(
        'visitation route: ${context.ancestors.reversed.map((r) => r.runtimeType).join(' -> ')}');
  }
}
