part of recipe.ports;

class OutputPort<T extends Object> extends Port<T> {
  OutputPort(final String name) : super(name);

  @override
  UnmodifiableSetView<Connection<T>> get connections =>
      UnmodifiableSetView(outboundConnections);

  @internal
  final outboundConnections = <Connection<T>>{};

  @nonVirtual
  WiredConnection<T> connectTo(final InputPort<T> inputPort) {
    final connection = inputPort._connectFrom(this);
    outboundConnections.add(connection);
    return connection;
  }

  @nonVirtual
  WirelessConnection<T> wirelesslyConnectTo(final InputPort<T> inputPort) {
    final connection = inputPort._wirelesslyConnectFrom(this);
    outboundConnections.add(connection);
    return connection;
  }

  @nonVirtual
  void write(final BakeContext<T> context) {
    connections.forEach((c) => c.to._write(context));
  }
}
