import 'dart:async';
import 'package:fhir_yaml/fhir_yaml.dart';
import 'package:meta/meta.dart';

mixin _RecipeFrameworkEntity {
  String get name => runtimeType.toString();

  Map<String, dynamic> toJson();
}

class Wire<T> with _RecipeFrameworkEntity {
  Wire({
    required this.from,
    required this.to,
  });

  final OutputPort<T> from;
  final InputPort<T> to;

  final _streamController = StreamController<T>();

  @override
  Map<String, dynamic> toJson() {
    return {
      'from': from.hashCode,
      'to': to.hashCode,
      if (T != dynamic) 'type': T.toString(),
    };
  }
}

abstract class _PortBase<T> with _RecipeFrameworkEntity {
  List<Wire<T>> get connections;

  Recipe get associatedRecipe;

  @override
  Map<String, dynamic> toJson() {
    return {
      'of': associatedRecipe.hashCode,
      'name': name,
      'connections': connections.map((e) => e.hashCode).toList(),
      if (T != dynamic) 'type': T.toString(),
    };
  }

  Type get type => T;
}

@sealed
class InputPort<T> extends _PortBase<T> {
  InputPort(
    this.name, {
    required Recipe of,
  }) : associatedRecipe = of {
    associatedRecipe.inputPorts.add(this);
  }

  final String name;

  final Recipe associatedRecipe;

  final List<Wire<T>> connections = [];
}

@sealed
class OutputPort<T> extends _PortBase<T> {
  OutputPort(
    this.name, {
    required Recipe of,
  }) : associatedRecipe = of {
    associatedRecipe.outputPorts.add(this);
  }

  final String name;

  final Recipe associatedRecipe;

  final List<Wire<T>> connections = [];

  void write(T data) {
    for (final connection in connections) {
      connection._streamController.sink.add(data);
    }
  }

  Wire<T> connectTo(InputPort<T> destination) {
    final wire = Wire<T>(from: this, to: destination);
    connections.add(wire);
    return wire;
  }
}

abstract class Recipe with _RecipeFrameworkEntity {
  Recipe({this.recipeContext});

  final RecipeContext? recipeContext;

  List<InputPort> inputPorts = [];
  List<OutputPort> outputPorts = [];

  FutureOr<void> bake(int context);

  @override
  Map<String, dynamic> toJson() {
    return {
      'recipe': name,
      if (inputPorts.isNotEmpty) 'inputs': [...inputPorts.map(_portToJson)],
      if (outputPorts.isNotEmpty) 'outputs': [...outputPorts.map(_portToJson)],
      if (recipeContext != null && recipeContext!._data.isNotEmpty)
        'recipeContext': recipeContext!.toJson(),
    };
  }

  static Map<String, dynamic> _portToJson(_PortBase port) {
    return {
      'ref': port.hashCode,
      'name': port.name,
      if (port.type != dynamic) 'type': port.type,
    };
  }
}

@immutable
class RecipeContext with _RecipeFrameworkEntity {
  RecipeContext(this.id, this._data);

  final String id;

  final Map<String, dynamic> _data;

  get(String key) => _data[key];

  @override
  Map<String, dynamic> toJson() => _data;
}

class A extends Recipe {
  A({
    RecipeContext? recipeContext,
  }) : super(recipeContext: recipeContext);

  late final outputPort = OutputPort('output', of: this);

  Future<void> bake(int context) async {}
}

class B extends Recipe {
  B({
    RecipeContext? recipeContext,
  }) : super(recipeContext: recipeContext);

  late final inputPort = InputPort('input', of: this);
  late final outputPort = OutputPort('output', of: this);

  Future<void> bake(int context) async {}
}

class C extends Recipe {
  C({
    RecipeContext? recipeContext,
  }) : super(recipeContext: recipeContext);

  late final inputPort = InputPort('input', of: this);
  late final outputPort = OutputPort('output', of: this);

  Future<void> bake(int context) async {}
}

class D extends Recipe {
  D({
    RecipeContext? recipeContext,
  }) : super(recipeContext: recipeContext);

  late final inputPort = InputPort('input', of: this);

  Future<void> bake(int context) async {}
}

Map<String, dynamic> visit(Recipe recipe, [Map<String, dynamic>? map]) {
  map ??= <String, dynamic>{
    'recipes': <Map<String, dynamic>>[],
    'wires': <Map<String, dynamic>>[],
  };

  map['recipes'].add(recipe.toJson());

  for (final port in recipe.outputPorts) {
    for (final wire in port.connections) {
      map['wires'].add(wire.toJson());

      visit(wire.to.associatedRecipe, map);
    }
  }

  return map;
}

void main() {
  final a = A(recipeContext: RecipeContext('a-id', {}));
  final b = B(recipeContext: RecipeContext('b-id', {}));
  final c = C(recipeContext: RecipeContext('c-id', {}));
  final d = D(recipeContext: RecipeContext('d-id', {}));

  final result = visit(a);

  print(json2yaml(result));
}
