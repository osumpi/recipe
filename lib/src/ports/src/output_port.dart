part of recipe.ports;

class OutputPort extends Port {
  OutputPort(String name) : super(name);

  Set<Connection> get connections => outboundConnections;

  final outboundConnections = <Connection>{};

  Connection? connectTo(InputPort inputPort, {bool wireless = false}) {
    return inputPort.connectFrom(this, wireless: wireless);
  }
}
