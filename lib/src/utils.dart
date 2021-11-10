import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import 'recipe.dart';

/// Abstract class that contains all utility tools for use in recipe framework
/// as static members.
///
/// This class is not intended to be used as a super type or have instances.
@sealed
abstract class FrameworkUtils {
  // TODO: remove this class if not required by alpha.
}

/// Provides an instance of [Uuid].
///
/// Used by:
/// * [Baker]s for [BakeReport]s and other relevant tasks.
/// * [MultiIORecipe] to allocate random label for the the masked IO ports.
const uuid = Uuid();

// TODO: make it as Recipe<RecipeRun
void bake(final Recipe<dynamic, dynamic> recipe) {
  throw UnimplementedError();
  // return Baker.of(null).bake(recipe);
}

typedef JsonMap = Map<String, dynamic>;
