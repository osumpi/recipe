import 'dart:collection' show UnmodifiableMapView;

import 'package:meta/meta.dart';

@immutable
class BakeContext {
  @internal
  BakeContext({
    required final Map<String, dynamic> data,
  }) : data = UnmodifiableMapView(data);

  final UnmodifiableMapView<String, dynamic> data;
}
