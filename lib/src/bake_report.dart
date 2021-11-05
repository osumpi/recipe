import 'package:meta/meta.dart';

import 'package:recipe/src/bake_context.dart';
import 'package:recipe/src/framework_entity.dart';

@immutable
class BakeReport with FrameworkEntity {
  BakeReport({
    required this.startedOn,
    required this.stoppedOn,
    required this.inputContext,
  });

  final DateTime startedOn;

  final DateTime stoppedOn;

  Duration get duration => stoppedOn.difference(startedOn);

  final BakeContext inputContext;
}
