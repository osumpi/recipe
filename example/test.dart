import 'package:recipe/recipe.dart';

void main() async {
  bake(RecipeA()).listen((event) {
    print(event);
  });
}

class RecipeA extends Recipe {
  @override
  Stream<BakeContext> bake(BakeContext context) async* {
    print('baking A');

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
    print('starting delay for $duration');
    await Future.delayed(duration);
    print('$duration over');

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
    print('some extra decoration');

    return super.bake(context);
  }
}

class RecipeB extends Recipe {
  @override
  Stream<BakeContext> bake(BakeContext context) async* {
    print('baking B');
    print('visitation route: ${context.ancestors.reversed.join(' -> ')}');
  }
}
