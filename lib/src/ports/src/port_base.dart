part of recipe.ports;

abstract class Port<T extends BakeContext> with FrameworkEntity {
  const Port(this.name);

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
