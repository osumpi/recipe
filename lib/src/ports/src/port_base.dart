part of recipe.ports;

abstract class Port<T extends BakeContext> with FrameworkEntity {
  Port(this.name) {
    register();
  }

  final String name;

  Type get type => T;

  @override
  JsonMap toJson() {
    return {
      'name': name,
      'type': runtimeType.toString(),
    };
  }

  Set<Connection> get connections;
}
