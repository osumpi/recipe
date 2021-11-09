part of recipe.baker;

class SingleRunBakerOptions implements BakerOptions {
  const SingleRunBakerOptions({
    final this.shouldThrowWhenBakeRejected = false,
  });

  /// Whether the [SingleRunBaker] should throw when the requested bake was
  /// rejected.
  ///
  /// If set to `true`, throws [StateError] if the input [BakeContext] was
  /// rejected from being baked.
  ///
  /// If set to `false`, just logs an error if the input [BakeContext] was
  /// rejected from being baked.
  final bool shouldThrowWhenBakeRejected;
}

mixin _SingleRunBakeHandler on Baker<SingleRunBakerOptions> {
  @override
  @nonVirtual
  final concurrencyAllowed = false;

  @override
  Future<BakeReport> bake(final BakeContext<dynamic> inputContext) async {
    uptimeStopwatch.start();
    canBake = false;

    final startedOn = DateTime.now();
    final key = FrameworkUtils.uuid.v4();

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
  void requestBake(final BakeContext<dynamic> inputContext) {
    if (canBake) {
      bake(inputContext);
      canBake = false;
    } else {
      final bakeRejectReason =
          'Bake request rejected. $bakerType does not allow more than one bake requests.';

      if (bakerOptions.shouldThrowWhenBakeRejected) {
        throw StateError(bakeRejectReason);
      } else {
        error(bakeRejectReason);
      }
    }
  }
}
