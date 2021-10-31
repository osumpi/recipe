part of recipe.ports;

abstract class InputPort<T extends BakeContext> extends Port<T> {
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

  final events = StreamController<T>();
}

mixin SingleInboundInputPortHandler<T extends BakeContext> on InputPort<T> {
  final allowMultipleInboundConnections = false;

  Connection<T>? inboundConnection;

  Set<Connection> get connections =>
      {if (inboundConnection != null) inboundConnection!};

  Connection<T>? connectFrom(
    OutputPort<T> outputPort, {
    bool wireless = false,
  }) {
    if (inboundConnection != null) {
      return wireless
          ? Connection.wireless(from: outputPort, to: this)
          : Connection(from: outputPort, to: this);
    }
  }
}

mixin MultiInboundInputPortHandler<T extends BakeContext> on InputPort<T> {
  final allowMultipleInboundConnections = true;

  Set<Connection> get connections => inboundConnections;

  final inboundConnections = <Connection<T>>{};

  Connection<T> connectFrom(
    OutputPort<T> outputPort, {
    bool wireless = false,
  }) {
    return wireless
        ? Connection.wireless(from: outputPort, to: this)
        : Connection(from: outputPort, to: this);
  }
}

class SingleInboundInputPort<T extends BakeContext> = InputPort<T>
    with SingleInboundInputPortHandler<T>;

class MultiInboundInputPort<T extends BakeContext> = InputPort<T>
    with MultiInboundInputPortHandler<T>;
