part of recipe.ports;

@immutable
abstract class Connection<T> with FrameworkEntity {
  @literal
  const Connection({
    required final this.from,
    required final this.to,
  });

  @nonVirtual
  final OutputPort<T> from;

  @nonVirtual
  final InputPort<T> to;

  @override
  JsonMap toJson() {
    return {
      ...super.toJson(),
      'from': from.hashCode,
      'to': to.hashCode,
    };
  }
}

mixin _WiredConnectionHandler<T> on Connection<T> {}
mixin _WirelessConnectionHandler<T> on Connection<T> {}

class WiredConnection<T> = Connection<T> with _WiredConnectionHandler<T>;

class WirelessConnection<T> = Connection<T> with _WirelessConnectionHandler<T>;
