import 'dart:collection';

import 'package:recipe/recipe.dart';

typedef AnyBakeContext = BakeContext<dynamic>;
typedef AnyRecipe = Recipe<dynamic, dynamic>;
typedef AnyInputPort = InputPort<dynamic>;
typedef AnyOutputPort = OutputPort<dynamic>;

typedef MuxedInputs = UnmodifiableMapView<AnyInputPort, dynamic>;
typedef MuxedOutput = List<MapEntry<AnyOutputPort, dynamic>>;
