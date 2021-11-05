import 'package:meta/meta.dart';

import 'package:recipe/src/bake_context.dart';

@immutable
class BakeReport {
  BakeReport({
    required this.startedOn,
    required this.stoppedOn,
    required this.inputContext,
  });

  final DateTime startedOn;

  final DateTime stoppedOn;

  Duration get duration => stoppedOn.difference(startedOn);

  final BakeContext inputContext;

  Map<String, dynamic> toJson() {
    return {
      'started on': startedOn,
      'stopped on': stoppedOn,
      'input context': inputContext,
    };
  }
}
