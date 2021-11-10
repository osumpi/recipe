part of recipe.baker;

mixin _ConcurrentBakeHandler on Baker {
  @override
  @nonVirtual
  final concurrencyAllowed = true;

  final Map<String, DateTime> bakesInProgress = {};

  @override
  Future<BakeReport> bake(final BakeContext<dynamic> inputContext) async {
    uptimeStopwatch.start();

    final key = uuid.v4();
    bakesInProgress[key] = DateTime.now();

    // TODO: listen and report recipe.bakeCompletedWithContext / hook to output
    await recipe.bake(inputContext);

    final report = BakeReport(
      bakeId: key,
      bakedBy: this,
      startedOn: bakesInProgress.remove(key)!,
      stoppedOn: DateTime.now(),
      inputContext: inputContext,
    );

    bakeLog.add(report);

    if (bakesInProgress.isEmpty) {
      uptimeStopwatch.stop();
    }

    return report;
  }

  @override
  bool get canBake => true;

  @override
  void requestBake(final BakeContext<dynamic> inputContext) {
    if (canBake) {
      bake(inputContext);
    } else {
      throw UnimplementedError(
        '[$bakerType.canBake] was evaluated to false. However no implementation was given to handle this condition.',
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
