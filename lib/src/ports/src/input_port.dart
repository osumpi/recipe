part of recipe.ports;

abstract class InputPort<T extends Object> extends Port<T> {
  InputPort(String name) : super(name);

  @useResult
  WiredConnection<T> _connectFrom(OutputPort<T> outputPort);

  @useResult
  WirelessConnection<T> _wirelesslyConnectFrom(OutputPort<T> outputPort);

  @internal
  final events = StreamController<BakeContext<T>>();
}

mixin _SingleInboundInputPortHandler<T extends Object> on InputPort<T> {
  @nonVirtual
  Connection<T>? inboundConnection;

  UnmodifiableSetView<Connection<T>> get connections {
    return UnmodifiableSetView({
      if (inboundConnection != null) inboundConnection!,
    });
  }

  @override
  WiredConnection<T> _connectFrom(OutputPort<T> outputPort) {
    if (inboundConnection is Connection<T>) {
      throw StateError(
        'Cannot connect to $runtimeType when already an inbound connection exists.',
      );
    }

    return inboundConnection = WiredConnection<T>(from: outputPort, to: this);
  }

  @override
  WirelessConnection<T> _wirelesslyConnectFrom(OutputPort<T> outputPort) {
    if (inboundConnection is Connection<T>) {
      throw StateError(
        'Cannot connect to $runtimeType when already an inbound connection exists.',
      );
    }

    return inboundConnection =
        WirelessConnection<T>(from: outputPort, to: this);
  }
}

mixin _MultiInboundInputPortHandler<T extends Object> on InputPort<T> {
  UnmodifiableSetView<Connection<T>> get connections =>
      UnmodifiableSetView(inboundConnections);

  @internal
  final inboundConnections = <Connection<T>>{};

  @override
  WiredConnection<T> _connectFrom(OutputPort<T> outputPort) {
    final connection = WiredConnection<T>(from: outputPort, to: this);
    inboundConnections.add(connection);
    return connection;
  }

  @override
  WirelessConnection<T> _wirelesslyConnectFrom(OutputPort<T> outputPort) {
    final connection = WirelessConnection<T>(from: outputPort, to: this);
    inboundConnections.add(connection);
    return connection;
  }
}

class SingleInboundInputPort<T extends Object> = InputPort<T>
    with _SingleInboundInputPortHandler<T>;

class MultiInboundInputPort<T extends Object> = InputPort<T>
    with _MultiInboundInputPortHandler<T>;
