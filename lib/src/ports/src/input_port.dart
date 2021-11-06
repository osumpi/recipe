part of recipe.ports;

abstract class InputPort<T extends Object> extends Port<T> {
  InputPort(String name) : super(name);

  @visibleForOverriding
  Connection<T> connectFrom(OutputPort<T> outputPort, {bool wireless});

  @internal
  final events = StreamController<BakeContext<T>>();
}

mixin _SingleInboundInputPortHandler<T extends Object> on InputPort<T> {
  Connection<T>? inboundConnection;

  UnmodifiableSetView<Connection<T>> get connections {
    return UnmodifiableSetView({
      if (inboundConnection != null) inboundConnection!,
    });
  }

  Connection<T> connectFrom(
    OutputPort<T> outputPort, {
    bool wireless = false,
  }) {
    if (inboundConnection is Connection<T>) {
      throw StateError(
        'Cannot connect to $runtimeType when already an inbound connection exists.',
      );
    }

    final connection = wireless
        ? WirelessConnection<T>(from: outputPort, to: this)
        : WiredConnection<T>(from: outputPort, to: this);

    inboundConnection = connection;

    return connection;
  }
}

mixin _MultiInboundInputPortHandler<T extends Object> on InputPort<T> {
  UnmodifiableSetView<Connection<T>> get connections =>
      UnmodifiableSetView(inboundConnections);

  @internal
  final inboundConnections = <Connection<T>>{};

  @override
  Connection<T> connectFrom(
    OutputPort<T> outputPort, {
    bool wireless = false,
  }) {
    final connection = wireless
        ? WirelessConnection<T>(from: outputPort, to: this)
        : WiredConnection<T>(from: outputPort, to: this);

    inboundConnections.add(connection);

    return connection;
  }
}

class SingleInboundInputPort<T extends Object> = InputPort<T>
    with _SingleInboundInputPortHandler<T>;

class MultiInboundInputPort<T extends Object> = InputPort<T>
    with _MultiInboundInputPortHandler<T>;
