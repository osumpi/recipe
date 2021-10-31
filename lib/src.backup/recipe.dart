part of recipe.old;

abstract class Recipe with _RecipeFrameworkEntity {
  Recipe({this.recipeContext}) {
    recipeExporter._add(this);
  }

  bool isInitialized = false;

  @mustCallSuper
  void initialize() {
    // TODO: change to warning instead of assert
    assert(!isInitialized, 'Warn: Already initialized!');

    isInitialized = true;
  }

  final RecipeContext? recipeContext;

  Stream bake(BakeContext context);

  @override
  JsonMap toJson() {
    return {
      'recipe': name,
      if (recipeContext != null && recipeContext!._data.isNotEmpty)
        'recipeContext': recipeContext!.toJson(),
    };
  }

  static JsonMap _portToJson(_PortBase port) {
    return {
      'key': port.hashCode,
      'name': port.name,
      if (port.type != dynamic) 'type': port.type,
    };
  }
}

mixin Inputs on Recipe {
  List<InputPort> inputPorts = [];

  @protected
  InputPort<T> input<T extends BakeContext>(
    String name, {
    bool allowMultipleConnections = true,
  }) {
    return InputPort<T>(name,
        of: this, allowMultipleConnections: allowMultipleConnections);
  }
}

mixin Outputs on Recipe {
  List<OutputPort> outputPorts = [];

  @protected
  OutputPort<T> output<T extends BakeContext>(String name) {
    return OutputPort<T>(name, of: this);
  }
}
