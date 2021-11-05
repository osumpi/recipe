part of recipe.baker;

mixin _FIFOBakeHandler on NonConcurrentBaker {
  final requests = ListQueue<BakeContext>();

  @override
  Stream<BakeContext> bake(BakeContext inputContext) async* {
    uptimeStopwatch.start();

    final startedOn = DateTime.now();
    final key = uuid.v4();

    yield* recipe.bake(inputContext);

    final report = BakeReport(
      bakeId: key,
      bakedBy: this,
      startedOn: startedOn,
      stoppedOn: DateTime.now(),
      inputContext: inputContext,
    );

    bakeLog.add(report);

    uptimeStopwatch.stop();

    tryCompletePendingRequests();
  }

  @override
  void handleBakeRequestWhenBaking(BakeContext inputContext) {
    requests.add(inputContext);
  }

  /// Voluntarily marked as future to allow requesting bake stream to close
  /// without waiting for this to complete.
  ///
  /// Do not await this future inside [bake].
  Future<void> tryCompletePendingRequests() async {
    if (requests.isNotEmpty) {
      bake(requests.removeFirst());
    }
  }
}
