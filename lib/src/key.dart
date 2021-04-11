part of recipe;

@immutable
class Key with EquatableMixin {
  final Object _obj;

  const Key(Object value) : _obj = value;

  @override
  List<Object?> get props => [_obj];
}

class UniqueKey extends Key {
  static const _uuid = Uuid();

  UniqueKey() : super(_uuid.v4());
}
