part of recipe;

@immutable
class BakeEvent<T> {
  final DateTime occuredOn;
  final T event;

  const BakeEvent({
    required this.event,
    required this.occuredOn,
  });
}
