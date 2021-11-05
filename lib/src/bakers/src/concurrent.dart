part of recipe.bakers;

mixin _ConcurrentBakeHandler on Baker {
  @override
  @nonVirtual
  final concurrencyAllowed = true;

  final Map<String, DateTime> beingBaked = {};

  @override
  Stream<BakeContext> bake(BakeContext inputContext) async* {
    uptimeStopwatch.start();

    final key = uuid.v4();
    beingBaked[key] = DateTime.now();

    yield* recipe.bake(inputContext);

    final report = BakeReport(
      startedOn: beingBaked.remove(key)!,
      stoppedOn: DateTime.now(),
      inputContext: inputContext,
    );

    bakeLog.add(report);
  }

  @override
  bool get canBake => true;

  @override
  void requestBake(BakeContext inputContext) {
    bake(inputContext);
  }
}

mixin _NonConcurrentBakerMixin on Baker {
  @override
  @nonVirtual
  final concurrencyAllowed = false;
}

// mixin _LazyBakeHandler on FirstInFirstOutBaker {}
// mixin _RandomBakeHandler on NonConcurrentBaker {}

// mixin IncapacitatedBaker on Baker {}
// mixin _FIFOBakeHandler on NonConcurrentBaker {}
// mixin _AngryBakeHandler on NonConcurrentBaker {}
// mixin _SingleRunBakeHandler on NonConcurrentBaker {}
