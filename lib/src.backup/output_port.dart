part of recipe.old;

@sealed
class OutputPort<T extends BakeContext> extends _PortBase<T> {
  OutputPort(
    this.name, {
    required Outputs of,
  }) : associatedRecipe = of {
    associatedRecipe.outputPorts.add(this);
  }

  final String name;

  final Outputs associatedRecipe;

  final List<Wire<T>> connections = [];

  void write(T data) {
    for (final connection in connections) {
      connection._streamController.sink.add(data);
    }
  }

  Wire<T> connectTo(InputPort<T> destination) {
    return Wire<T>(from: this, to: destination);
  }
}
