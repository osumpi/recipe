part of recipe.ports;

class OutputPort<T extends Object> extends Port<T> {
  OutputPort(String name) : super(name);

  UnmodifiableSetView<Connection<T>> get connections =>
      UnmodifiableSetView(outboundConnections);

  @internal
  final outboundConnections = <Connection<T>>{};

  @nonVirtual
  WiredConnection<T> connectTo(InputPort<T> inputPort) {
    final connection = inputPort._connectFrom(this);
    outboundConnections.add(connection);
    return connection;
  }

  @nonVirtual
  WirelessConnection<T> wirelesslyConnectTo(InputPort<T> inputPort) {
    final connection = inputPort._wirelesslyConnectFrom(this);
    outboundConnections.add(connection);
    return connection;
  }

  @nonVirtual
  void write(BakeContext<T> context) {
    connections.forEach((c) => c.to.events.add(context));
  }
}
