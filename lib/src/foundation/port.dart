// TODO: inspect modularity

import 'dart:async';
import 'dart:collection';

import 'package:meta/meta.dart';

import 'recipe.dart';
import 'utils.dart';

@immutable
class BakeData<T> {
  const BakeData({
    required this.data,
    required this.source,
    required this.timestamp,
  });

  final T data;
  final Recipe source;
  final DateTime timestamp;
}

abstract class Port<T> with FrameworkEntity {
  const Port(this.name);

  @override
  final String name;

  Iterable<Connection<T>> get connections;
}

mixin ConnectTarget<T> on FrameworkEntity {}

mixin ConnectOrigin<T> on FrameworkEntity {}

@immutable
abstract class Connection<T> with FrameworkEntity {
  Connection({
    required final this.from,
    required final this.to,
  });

  @nonVirtual
  final ConnectOrigin<T> from;

  @nonVirtual
  final ConnectTarget<T> to;

  final _streamController = StreamController<T>();

  void write(final T event) => _streamController.sink.add(event);

  late final listen = _streamController.stream.listen;

  @override
  JsonMap toJson() {
    return {
      ...super.toJson(),
      'origin': from.hashCode,
      'target': to.hashCode,
    };
  }
}

mixin _WiredConnectionHandler<T> on Connection<T> {}
mixin _WirelessConnectionHandler<T> on Connection<T> {
  @override
  JsonMap toJson() {
    return {
      ...super.toJson(),
      'isWireless': true,
    };
  }
}

class WiredConnection<T> = Connection<T> with _WiredConnectionHandler<T>;

class WirelessConnection<T> = Connection<T> with _WirelessConnectionHandler<T>;

abstract class InputPort<T> extends Port<T> with ConnectTarget<T> {
  InputPort(final String name) : super(name);

  @useResult
  WiredConnection<T> _connectFrom(final OutputPort<T> outputPort);

  @useResult
  WirelessConnection<T> _wirelesslyConnectFrom(final OutputPort<T> outputPort);

  final _events = StreamController<T>();

  Stream<T> get stream => _events.stream;

  late T _data;

  T get data => _data;
}

mixin _SingleInboundInputPortHandler<T> on InputPort<T> {
  @nonVirtual
  Connection<T>? inboundConnection;

  @override
  Iterable<Connection<T>> get connections {
    return {if (inboundConnection != null) inboundConnection!};
  }

  @override
  WiredConnection<T> _connectFrom(final OutputPort<T> outputPort) {
    if (inboundConnection is Connection<T>) {
      throw StateError(
        'Cannot connect to $name ($runtimeType) when already an inbound connection exists.',
      );
    }

    return inboundConnection = WiredConnection<T>(from: outputPort, to: this);
  }

  @override
  WirelessConnection<T> _wirelesslyConnectFrom(final OutputPort<T> outputPort) {
    if (inboundConnection is Connection<T>) {
      throw StateError(
        'Cannot connect to $name ($runtimeType) when already an inbound connection exists.',
      );
    }

    return inboundConnection =
        WirelessConnection<T>(from: outputPort, to: this);
  }
}

mixin _MultiInboundInputPortHandler<T> on InputPort<T> {
  @override
  Iterable<Connection<T>> get connections => inboundConnections;

  @internal
  final inboundConnections = <Connection<T>>{};

  @override
  WiredConnection<T> _connectFrom(final OutputPort<T> outputPort) {
    final connection = WiredConnection<T>(from: outputPort, to: this);
    inboundConnections.add(connection);
    return connection;
  }

  @override
  WirelessConnection<T> _wirelesslyConnectFrom(final OutputPort<T> outputPort) {
    final connection = WirelessConnection<T>(from: outputPort, to: this);
    inboundConnections.add(connection);
    return connection;
  }
}

class SingleInboundInputPort<T> = InputPort<T>
    with _SingleInboundInputPortHandler<T>;

class MultiInboundInputPort<T> = InputPort<T>
    with _MultiInboundInputPortHandler<T>;

class OutputPort<T> extends Port<T> with ConnectOrigin<T> {
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
  void write(final T event) {
    for (final connection in connections) {
      connection.write(event);
    }
  }
}
