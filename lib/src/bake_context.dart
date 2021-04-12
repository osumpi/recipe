part of recipe;

@sealed
class BakeContext {
  final Recipe recipe;

  List<BakeEvent> events = List<BakeEvent>.empty(growable: true);

  BakeState _state = BakeState.awaiting();

  BakeState get state => _state;

  set state(BakeState value) {
    if (_state == value) return;

    _state = value;

    final event = BakeEvent<BakeState>(
      event: value,
      occuredOn: DateTime.now(),
    );

    events.add(event);
  }

  final BakeContext? ancestor;

  List<BakeContext> descendants = List<BakeContext>.empty(growable: true);

  BakeContext._for(this.recipe, {required this.ancestor});

  BakeContext adopt(Recipe recipe) {
    final context = BakeContext._for(recipe, ancestor: this);
    descendants.add(context);
    return context;
  }

  bool get isRoot => ancestor == null;
  bool get hasAncestor => !isRoot;
  bool get hasDescendants => descendants.isNotEmpty;
}
