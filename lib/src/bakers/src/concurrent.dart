part of recipe.bakers;

mixin _ConcurrentBakeHandler on Baker {
  @override
  @nonVirtual
  final concurrencyAllowed = true;

  final Map<String, DateTime> bakesInProgress = {};

  @override
  Stream<BakeContext> bake(BakeContext inputContext) async* {
    uptimeStopwatch.start();

    final key = uuid.v4();
    bakesInProgress[key] = DateTime.now();

    yield* recipe.bake(inputContext);

    final report = BakeReport(
      bakeId: key,
      startedOn: bakesInProgress.remove(key)!,
      stoppedOn: DateTime.now(),
      inputContext: inputContext,
    );

    bakeLog.add(report);

    if (bakesInProgress.isEmpty) {
      uptimeStopwatch.stop();
    }
  }

  @override
  bool get canBake => true;

  @override
  void requestBake(BakeContext inputContext) {
    if (canBake) {
      bake(inputContext);
    } else {
      throw UnimplementedError(
        '[$runtimeType.canBake] was evaluated to false. However no implementation was given to handle this condition.',
      );
    }
  }
}

// mixin _LazyBakeHandler on FirstInFirstOutBaker {}
// mixin _RandomBakeHandler on NonConcurrentBaker {}

// mixin IncapacitatedBaker on Baker {}
// mixin _FIFOBakeHandler on NonConcurrentBaker {}
// mixin _AngryBakeHandler on NonConcurrentBaker {}
// mixin _SingleRunBakeHandler on NonConcurrentBaker {}
