part of recipe.baker;

enum BakerStatus { baking, idle }

abstract class Baker<T extends BakerOptions>
    with FrameworkEntity, EntityLogging {
  Baker(
    this.recipe, {
    required final this.bakerOptions,
  });

  @nonVirtual
  final T bakerOptions;

  @nonVirtual
  final Recipe<dynamic, dynamic> recipe;

  bool get concurrencyAllowed;

  @nonVirtual
  final List<BakeReport> bakeLog = [];

  @nonVirtual
  int get bakesCompleted => bakeLog.length;

  @protected
  @nonVirtual
  final uptimeStopwatch = Stopwatch();

  @nonVirtual
  BakerStatus get status =>
      uptimeStopwatch.isRunning ? BakerStatus.baking : BakerStatus.idle;

  @nonVirtual
  bool get isBaking => status == BakerStatus.baking;

  @nonVirtual
  bool get isIdle => status == BakerStatus.idle;

  @nonVirtual
  Duration get uptime => uptimeStopwatch.elapsed;

  bool get canBake;

  @protected
  Future<BakeReport> bake(final BakeContext<dynamic> inputContext);

  /// Requests a bake on [recipe] for a given [inputContext].
  ///
  /// The request may be processed immediatley or be queued to be baked at a
  /// later moment or can be rejected completley.
  ///
  /// Refer baker implementation docs to see how the [requestBake] is actually
  /// handled.
  void requestBake(final BakeContext<dynamic> inputContext);

  Type get bakerType => runtimeType;
}
