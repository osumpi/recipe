part of recipe.baker;

mixin _SingleRunBakeHandler on Baker {
  @override
  @nonVirtual
  final concurrencyAllowed = false;

  @override
  Future<BakeReport> bake(BakeContext inputContext) async {
    uptimeStopwatch.start();
    canBake = false;

    final startedOn = DateTime.now();
    final key = uuid.v4();

    // TODO: listen and report recipe.bakeCompletedWithContext / hook to output
    await recipe.bake(inputContext);

    final stoppedOn = DateTime.now();

    final report = BakeReport(
      bakeId: key,
      bakedBy: this,
      startedOn: startedOn,
      stoppedOn: stoppedOn,
      inputContext: inputContext,
    );

    bakeLog.add(report);

    uptimeStopwatch.stop();

    return report;
  }

  @override
  @nonVirtual
  bool canBake = true;

  @override
  void requestBake(BakeContext inputContext) {
    if (canBake) {
      bake(inputContext);
      canBake = false;
    } else {
      throw StateError(
        'Baker exhausted. This baker allows bake to be invoked only once.',
      );
    }
  }
}
