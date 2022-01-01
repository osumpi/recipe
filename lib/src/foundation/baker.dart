import 'package:meta/meta.dart';

import 'bake_context.dart';
import 'bake_report.dart';
import 'recipe.dart';

enum BakerStatus { baking, idle }

abstract class Baker {
  late final Recipe recipe;

  @mustCallSuper
  void bind(final Recipe recipe) {
    this.recipe = recipe;
  }

  Iterable<BakeReport> get bakeLogs;

  @nonVirtual
  int get bakesCompleted => bakeLogs.length;

  BakerStatus get status;

  // @nonVirtual
  // BakerStatus get status =>
  //     uptimeStopwatch.isRunning ? BakerStatus.baking : BakerStatus.idle;

  Future<BakeReport> startBake(final BakeContext context);

  @nonVirtual
  bool get isIdle => status == BakerStatus.idle;

  Duration get uptime;

  /// Requests a bake on [recipe] for a given [inputContext].
  ///
  /// The request may be processed immediatley or be queued to be baked at a
  /// later moment or can be rejected completley.
  ///
  /// Refer baker implementation docs to see how the [requestBake] is actually
  /// handled.
  void requestBake(final BakeContext context);

  @visibleForOverriding
  String get bakerType;
}
