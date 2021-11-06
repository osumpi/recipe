part of recipe.ports;

abstract class Port<T extends Object> with FrameworkEntity {
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

  Set<Connection<T>> get connections;
}
