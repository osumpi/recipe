part of recipe.ports;

class Connection<T extends BakeContext> with FrameworkEntity {
  Connection({
    required this.from,
    required this.to,
  }) {
    register();
  }

  factory Connection.wireless({
    required OutputPort<T> from,
    required InputPort<T> to,
  }) = WirelessConnection;

  final OutputPort<T> from;
  final InputPort<T> to;

  final isWireless = false;

  void write(T context) {
    to.events.add(context);
  }

  @override
  JsonMap toJson() {
    return {
      'from': from.hashCode,
      'to': to.hashCode,
      'is wireless': isWireless,
      'context type': T.toString(),
    };
  }

  @useResult
  Connection<T> get asWirelessConnection =>
      Connection.wireless(from: from, to: to);
}

class WirelessConnection<T extends BakeContext> extends Connection<T> {
  WirelessConnection({
    required OutputPort<T> from,
    required InputPort<T> to,
  }) : super(from: from, to: to);

  @nonVirtual
  @override
  final isWireless = true;

  @override
  Connection<T> get asWirelessConnection => this;
}
