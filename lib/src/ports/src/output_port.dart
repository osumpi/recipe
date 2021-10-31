part of recipe.ports;

class OutputPort<T extends BakeContext> extends Port<T> {
  OutputPort(String name) : super(name);

  Set<Connection<T>> get connections => outboundConnections;

  final outboundConnections = <Connection<T>>{};

  Connection<T>? connectTo(InputPort<T> inputPort, {bool wireless = false}) {
    return inputPort.connectFrom(this, wireless: wireless);
  }
}
