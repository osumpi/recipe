part of recipe.ports;

abstract class Port with FrameworkEntity {
  const Port(this.name);

  final String name;

  @override
  JsonMap toJson() {
    return {
      ...super.toJson(),
      'name': name,
      'type': runtimeType.toString(),
    };
  }

  Set<Connection> get connections;
}
