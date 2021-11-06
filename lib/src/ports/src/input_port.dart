part of recipe.ports;

abstract class InputPort extends Port {
  // ignore: unused_element
  InputPort._(String name) : super(name);

  factory InputPort(
    String name, {
    bool allowMultipleConnections = true,
  }) =>
      allowMultipleConnections
          ? MultiInboundInputPort._(name)
          : SingleInboundInputPort._(name);

  bool get allowMultipleInboundConnections;

  Connection? connectFrom(OutputPort outputPort, {bool wireless});

  final events = StreamController<BakeContext>();
}

mixin _SingleInboundInputPortHandler<T extends BakeContext> on InputPort {
  final allowMultipleInboundConnections = false;

  Connection? inboundConnection;

  Set<Connection> get connections =>
      {if (inboundConnection != null) inboundConnection!};

  Connection? connectFrom(
    OutputPort outputPort, {
    bool wireless = false,
  }) {
    if (inboundConnection != null) {
      return wireless
          ? Connection.wireless(from: outputPort, to: this)
          : Connection(from: outputPort, to: this);
    }
  }
}

mixin _MultiInboundInputPortHandler<T extends BakeContext> on InputPort {
  final allowMultipleInboundConnections = true;

  Set<Connection> get connections => inboundConnections;

  final inboundConnections = <Connection>{};

  Connection connectFrom(
    OutputPort outputPort, {
    bool wireless = false,
  }) {
    return wireless
        ? Connection.wireless(from: outputPort, to: this)
        : Connection(from: outputPort, to: this);
  }
}

class SingleInboundInputPort = InputPort with _SingleInboundInputPortHandler;
class MultiInboundInputPort = InputPort with _MultiInboundInputPortHandler;
