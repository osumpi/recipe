import 'package:recipe/foundation.dart';

/// Baker that permits the associated [Recipe] to be baked concurrently.
///
/// I.e., at any given moment the there maybe more than one bakes being
/// performed on the same recipe.
///
/// This baker bakes the recipe as soon as it receives an input context.
class ConcurrentBaker = Baker with _ConcurrentBakeHandler;

mixin _ConcurrentBakeHandler on Baker {
  final Map<String, DateTime> bakesInProgress = {};

  @override
  final List<BakeReport> bakeLogs = [];

  @override
  Duration get uptime => bakeLogs.fold(
        Duration.zero,
        (final value, final element) => value + element.duration,
      );

  @override
  String get bakerType => 'Concurrent Baker';

  @override
  BakerStatus get status =>
      bakesInProgress.isEmpty ? BakerStatus.idle : BakerStatus.baking;

  @override
  Future<BakeReport> startBake(final BakeContext context) async {
    final key = uuid.v4();
    bakesInProgress[key] = DateTime.now();

    await recipe.bake(context).drain();

    final report = BakeReport(
      bakeId: key,
      bakedBy: this,
      startedOn: bakesInProgress.remove(key)!,
      stoppedOn: DateTime.now(),
      inputContext: context,
    );

    bakeLogs.add(report);

    return report;
  }

  @override
  void requestBake(final BakeContext context) {
    startBake(context);
  }
}

// mixin _LazyBakeHandler on FirstInFirstOutBaker {}
// mixin _RandomBakeHandler on NonConcurrentBaker {}

// mixin IncapacitatedBaker on Baker {}
// mixin _FIFOBakeHandler on NonConcurrentBaker {}
// mixin _AngryBakeHandler on NonConcurrentBaker {}
// mixin _SingleRunBakeHandler on NonConcurrentBaker {}
