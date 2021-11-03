import 'package:recipe/recipe.dart';

void main() async {
  FrameworkUtils.setLoggingLevel(LogLevels.verbose);

  bake(MyRecipe()).listen((_) {});
}

class MyRecipe extends Recipe {
  @override
  Stream<BakeContext> bake(BakeContext context) async* {
    info(
        "oh! I'm running??? Okay, basic things didn't break if this is being printed.");

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
