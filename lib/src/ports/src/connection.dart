part of recipe.ports;

class Connection with FrameworkEntity {
  Connection({
    required this.from,
    required this.to,
  }) {
    // SketchRegistry.registerConnection(this);
  }

  factory Connection.wireless({
    required OutputPort from,
    required InputPort to,
  }) = WirelessConnection;

  final OutputPort from;
  final InputPort to;

  final isWireless = false;

  void write(BakeContext context) {
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

class WirelessConnection extends Connection {
  WirelessConnection({
    required OutputPort from,
    required InputPort to,
  }) : super(from: from, to: to);

  final isWireless = true;

  @override
  Connection get asWirelessConnection => this;
}
