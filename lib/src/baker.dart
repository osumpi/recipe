import 'package:meta/meta.dart';

import 'package:recipe/src/bake_report.dart' show BakeReport;
import 'package:recipe/src/recipe.dart' show Recipe;
import 'package:recipe/src/bake_context.dart' show BakeContext;

enum BakerStatus { baking, idle }

abstract class Baker {
  Baker(this.recipe);

  @nonVirtual
  final Recipe recipe;

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
  Duration get totalUptime => uptimeStopwatch.elapsed;

  bool get canBake;

  @protected
  Stream<BakeContext> bake(BakeContext inputContext);

  void requestBake(BakeContext inputContext);
}
