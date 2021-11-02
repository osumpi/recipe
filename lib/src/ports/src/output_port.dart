part of recipe.ports;

class OutputPort<T extends BakeContext> extends Port<T> {
  OutputPort(String name) : super(name);

  Set<Connection<T>> get connections => outboundConnections;

  final outboundConnections = <Connection<T>>{};

  Connection<T>? connectTo(InputPort<T> inputPort, {bool wireless = false}) {
    final connection = inputPort.connectFrom(this, wireless: wireless);

    if (connection == null) {
      error('failed to connect to $inputPort');
    } else {
      verbose('connected to $inputPort');
      outboundConnections.add(connection);
    }

    return connection;
  }

  void write(T context) {
    verbose('writing context to ${connections.length} connection(s).');
    connections.forEach((e) => e.write(context));
  }
}
