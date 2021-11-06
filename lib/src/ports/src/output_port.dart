part of recipe.ports;

class OutputPort<T extends Object> extends Port<T> {
  OutputPort(String name) : super(name);

  UnmodifiableSetView<Connection<T>> get connections =>
      UnmodifiableSetView(outboundConnections);

  @internal
  final outboundConnections = <Connection<T>>{};

  WiredConnection<T> connectTo(InputPort<T> inputPort) {
    final connection = inputPort.connectFrom(this);
    outboundConnections.add(connection);
    return connection;
  }

  WirelessConnection<T> wirelesslyConnectTo(InputPort<T> inputPort) {
    final connection = inputPort.wirelesslyConnectFrom(this);
    outboundConnections.add(connection);
    return connection;
  }
}
