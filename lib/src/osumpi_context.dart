import 'package:meta/meta.dart';

import 'package:recipe/src/utils.dart';

@immutable
class OsumPiContext with FrameworkEntity {
  const OsumPiContext._(this._data);

  const factory OsumPiContext.fromJson(JsonMap json) = OsumPiContext._;

  OsumPiContext({
    required int x,
    required int y,
    required int width,
    required int height,
  }) : _data = Map() {
    _data['x'] = x;
    _data['y'] = y;
    _data['width'] = width;
    _data['height'] = height;
  }

  final JsonMap _data;

  @override
  JsonMap toJson() => _data;
}
