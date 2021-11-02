import 'package:meta/meta.dart';

import 'package:recipe/src/utils.dart';

@immutable
class RecipeContext with FrameworkEntity {
  RecipeContext(this.id, this._data);

  final String id;

  final JsonMap _data;

  get(String key) => _data[key];

  @override
  JsonMap toJson() => _data;
}
