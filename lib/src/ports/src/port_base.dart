part of recipe.ports;

abstract class Port<T> with FrameworkEntity {
  const Port(this.name);

  @override
  final String name;

  @override
  JsonMap toJson() {
    return {
      ...super.toJson(),
      'name': name,
      'type': runtimeType.toString(),
    };
  }

  UnmodifiableSetView<Connection<T>> get connections;
}
