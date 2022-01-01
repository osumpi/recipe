import 'package:recipe/foundation.dart';

void bake(final Recipe recipe, BakeContext context) {
  recipe.initialize();
  recipe.baker.requestBake(context);
}
