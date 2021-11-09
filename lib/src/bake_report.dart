import 'package:meta/meta.dart';

import 'package:recipe/src/bake_context.dart' show BakeContext;
import 'package:recipe/src/baker/baker.dart' show Baker;

@immutable
class BakeReport {
  const BakeReport({
    required final this.bakeId,
    required final this.bakedBy,
    required final this.startedOn,
    required final this.stoppedOn,
    required final this.inputContext,
  });

  final String bakeId;

  final Baker bakedBy;

  final DateTime startedOn;

  final DateTime stoppedOn;

  Duration get duration => stoppedOn.difference(startedOn);

  final BakeContext<dynamic> inputContext;

  Map<String, dynamic> toJson() {
    return {
      'bake id': bakeId,
      'baked by': '${bakedBy.runtimeType}#${bakedBy.hashCode}',
      'started on': startedOn,
      'stopped on': stoppedOn,
      'duration': duration,
      'input context': inputContext,
    };
  }
}
