import 'dart:collection' show UnmodifiableMapView;

import 'package:meta/meta.dart';

import 'framework_entity.dart';

@immutable
class BakeContext with FrameworkEntity, EntityLogging {
  @internal
  BakeContext({
    required final Map<String, dynamic> data,
  }) : data = UnmodifiableMapView(data);

  final UnmodifiableMapView<String, dynamic> data;
}
