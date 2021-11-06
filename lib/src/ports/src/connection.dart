part of recipe.ports;

class Connection<T extends Object> with FrameworkEntity {
  const Connection({
    required this.from,
    required this.to,
  });

  factory Connection.wireless({
    required OutputPort from,
    required InputPort to,
  }) = WirelessConnection<T>;

  final OutputPort from;
  final InputPort to;

  final isWireless = false;

  void write(BakeContext<T> context) {
    to.events.add(context);
  }

  @override
  JsonMap toJson() {
    return {
      ...super.toJson(),
      'from': from.hashCode,
      'to': to.hashCode,
      'is wireless': isWireless,
    };
  }

  Connection get asWirelessConnection =>
      Connection.wireless(from: from, to: to);
}

class WirelessConnection<T extends Object> extends Connection<T> {
  WirelessConnection({
    required OutputPort from,
    required InputPort to,
  }) : super(from: from, to: to);

  final isWireless = true;

  @override
  Connection get asWirelessConnection => this;
}
