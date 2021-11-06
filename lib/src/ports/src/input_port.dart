part of recipe.ports;

abstract class InputPort<T extends Object> extends Port<T> {
  // ignore: unused_element
  InputPort._(String name) : super(name);

  factory InputPort(
    String name, {
    bool allowMultipleConnections = true,
  }) =>
      allowMultipleConnections
          ? MultiInboundInputPort<T>._(name)
          : SingleInboundInputPort<T>._(name);

  bool get allowMultipleInboundConnections;

  Connection<T>? connectFrom(OutputPort<T> outputPort, {bool wireless});

  final events = StreamController<BakeContext<T>>();
}

mixin _SingleInboundInputPortHandler<T extends Object> on InputPort<T> {
  final allowMultipleInboundConnections = false;

  Connection<T>? inboundConnection;

  Set<Connection<T>> get connections =>
      {if (inboundConnection != null) inboundConnection!};

  Connection<T>? connectFrom(
    OutputPort<T> outputPort, {
    bool wireless = false,
  }) {
    if (inboundConnection != null) {
      return wireless
          ? Connection<T>.wireless(from: outputPort, to: this)
          : Connection<T>(from: outputPort, to: this);
    }
  }
}

mixin _MultiInboundInputPortHandler<T extends Object> on InputPort<T> {
  final allowMultipleInboundConnections = true;

  Set<Connection<T>> get connections => inboundConnections;

  final inboundConnections = <Connection<T>>{};

  @override
  Connection<T> connectFrom(
    OutputPort<T> outputPort, {
    bool wireless = false,
  }) {
    return wireless
        ? Connection<T>.wireless(from: outputPort, to: this)
        : Connection<T>(from: outputPort, to: this);
  }
}

class SingleInboundInputPort<T extends Object> = InputPort<T>
    with _SingleInboundInputPortHandler<T>;
class MultiInboundInputPort<T extends Object> = InputPort<T>
    with _MultiInboundInputPortHandler<T>;
