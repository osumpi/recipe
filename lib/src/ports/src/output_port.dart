part of recipe.ports;

class OutputPort<T extends Object> extends Port<T> {
  OutputPort(String name) : super(name);

  UnmodifiableSetView<Connection<T>> get connections =>
      UnmodifiableSetView(outboundConnections);

  @internal
  final outboundConnections = <Connection<T>>{};

  Connection<T>? connectTo(InputPort<T> inputPort, {bool wireless = false}) {
    final connection = inputPort.connectFrom(this, wireless: wireless);

    if (connection != null) {
      outboundConnections.add(connection);
    }

    return connection;
  }
}
