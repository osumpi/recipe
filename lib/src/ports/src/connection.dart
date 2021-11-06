part of recipe.ports;

abstract class Connection<T extends Object> with FrameworkEntity {
  @literal
  const Connection({
    required this.from,
    required this.to,
  });

  @nonVirtual
  final OutputPort from;

  @nonVirtual
  final InputPort to;

  void write(BakeContext<T> context) {
    to.events.add(context);
  }

  @override
  JsonMap toJson() {
    return {
      ...super.toJson(),
      'from': from.hashCode,
      'to': to.hashCode,
    };
  }
}

mixin _WiredConnectionHandler<T extends Object> on Connection<T> {}
mixin _WirelessConnectionHandler<T extends Object> on Connection<T> {}

class WiredConnection<T extends Object> = Connection<T>
    with _WiredConnectionHandler;

class WirelessConnection<T extends Object> = Connection<T>
    with _WirelessConnectionHandler<T>;
