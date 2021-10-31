part of recipe.old;

@sealed
abstract class InputPort<T extends BakeContext> implements _PortBase<T> {
  factory InputPort(
    String name, {
    required Inputs of,
    bool allowMultipleConnections = true,
  }) =>
      allowMultipleConnections
          ? _MultiWireInputPort<T>(name, of)
          : _SingleWireInputPort<T>(name, of);

  String get name;

  Inputs get associatedRecipe;

  bool get isSingleWireInputPort;

  bool get isMultiWireInputPort;

  void onReceive(T context);
}

abstract class _InputPort<T extends BakeContext>
    implements InputPort<T>, _PortBase<T> {
  _InputPort(this.name, this.associatedRecipe) {
    associatedRecipe.inputPorts.add(this);
  }

  final String name;

  final Inputs associatedRecipe;

  void onReceive(BakeContext context) {
    throw UnimplementedError();
  }

  @override
  JsonMap toJson() {
    return {
      'of': associatedRecipe.hashCode,
      'name': name,
      'type': runtimeType.toString(),
      'context': T.toString(),
    };
  }

  @override
  bool get isSingleWireInputPort => this is _SingleWireInputPort;

  @override
  bool get isMultiWireInputPort => this is _MultiWireInputPort;

  @override
  Type get type => T;
}

mixin _SingleWireInputPortHandler<T extends BakeContext> on _InputPort<T> {
  Wire<T>? inboundConnection;

  @override
  JsonMap toJson() {
    return {
      ...super.toJson(),
      'connection': inboundConnection?.hashCode,
    };
  }
}

mixin _MultiWireInputPortHandler<T extends BakeContext> on _InputPort<T> {
  final List<Wire<T>> inboundConnections = [];

  @override
  JsonMap toJson() {
    return {
      ...super.toJson(),
      'connections': inboundConnections.map((e) => e.hashCode).toList()
    };
  }
}

class _SingleWireInputPort<T extends BakeContext> = _InputPort<T>
    with _SingleWireInputPortHandler<T>;

class _MultiWireInputPort<T extends BakeContext> = _InputPort<T>
    with _MultiWireInputPortHandler<T>;
