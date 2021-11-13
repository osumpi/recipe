library recipe.baker;

import 'dart:async';
import 'dart:collection' show ListQueue;

import 'package:meta/meta.dart';

import 'package:recipe/src/bake_context.dart';
import 'package:recipe/src/bake_report.dart';
import 'package:recipe/src/framework_entity.dart';
import 'package:recipe/src/recipe.dart';
import 'package:recipe/src/utils.dart' show uuid;

part 'src/baker_options.dart';
part 'src/single_run.dart';
part 'src/concurrent.dart';
part 'src/non_concurrent.dart';
part 'src/fifo.dart';

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

/// Baker that permits the associated [Recipe] to be baked only once in the
/// current runtime.
class SingleRunBaker = Baker<SingleRunBakerOptions> with _SingleRunBakeHandler;

/// Baker that permits the associated [Recipe] to be baked concurrently.
///
/// I.e., at any given moment the there maybe more than one bakes being
/// performed on the same recipe.
///
/// This baker bakes the recipe as soon as it receives an input context.
class ConcurrentBaker = Baker with _ConcurrentBakeHandler;

/// Baker that permits only one bake at any given moment on a recipe.
/// This baker cannot be used directly as it does not define how the bake
/// should be handled.
///
/// For all usable [NonConcurrentBaker]s, see:
/// * [FirstInFirstOutBaker]
abstract class NonConcurrentBaker = Baker with _NonConcurrentBakerMixin;

class FirstInFirstOutBaker = NonConcurrentBaker with _FIFOBakeHandler;
// class AngryBaker = NonConcurrentBaker with _AngryBakeHandler;
// class IncapacitatedConcurrentBaker = ConcurrentBaker with IncapacitatedBaker;
// class IncapacitatedFIFOBaker = FirstInFirstOutBaker with IncapacitatedBaker;
// class LazyBaker = FirstInFirstOutBaker with _LazyBakeHandler;
// class RandomBaker = NonConcurrentBaker with _RandomBakeHandler;
// class LimitedConcurrentBaker = ConcurrentBaker
//     with _LimitedConcurrencyBakeHandler;
