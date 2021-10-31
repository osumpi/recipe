part of recipe.old;

class Wire<T extends BakeContext> with _RecipeFrameworkEntity {
  Wire({
    required this.from,
    required this.to,
  }) {
    from.connections.add(this);

    if (to.isMultiWireInputPort) {
      throw AbstractClassInstantiationError('Wire');
      //TODO:
    }

    _streamController.stream.listen((context) {
      if (context is _CloseWireContext) {
        _streamController.close();
        return;
      }

      to.onReceive(context);
    });
  }

  final OutputPort<T> from;
  final InputPort<T> to;

  final _streamController = StreamController<T>();

  @override
  JsonMap toJson() {
    return {
      'from': from.hashCode,
      'to': to.hashCode,
      'type': T.toString(),
    };
  }
}
