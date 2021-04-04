part of recipe;

@immutable
abstract class BakeState {
  int get completed;
  int? get current;
  int get total;

  const BakeState();

  factory BakeState.awaiting({required int total}) => _Awaiting(total);

  factory BakeState.running(
    int? running, {
    required int of,
    required int after,
  }) =>
      _Running(after, running, of);

  factory BakeState.paused({
    required int? at,
    required int after,
    required int of,
  }) =>
      _Paused(after, at, of);

  factory BakeState.stopped({
    required int at,
    required int of,
  }) =>
      _Stopped(at, of);

  factory BakeState.completed(int completed, {required int total}) =>
      _Completed(completed, total);

  bool get isAwaiting => this is _Awaiting;

  bool get isRunning => this is _Running;

  bool get isPaused => this is _Paused;

  bool get isStopped => this is _Stopped;

  bool get isCompleted => this is _Completed;

  double get progress {
    if (completed == 0 && total == 0) return 0.0;
    if (completed == total) return 100.0;

    return completed.toDouble() / total.toDouble();
  }
}

class _Awaiting extends BakeState {
  int get completed => 0;
  Null get current => null;

  final int total;

  _Awaiting(this.total);
}

class _Running extends BakeState {
  final int completed, total;
  final int? current;

  const _Running(this.completed, this.current, this.total);

  @override
  String toString() => 'Running ${current ?? (completed + 1)} of $total';
}

class _Paused extends BakeState {
  final int completed, total;
  final int? current;

  const _Paused(this.completed, this.current, this.total);

  @override
  String toString() => 'Paused at ${current ?? (completed + 1)} of $total';
}

class _Stopped extends BakeState {
  final int completed, total;

  Null get current => null;

  const _Stopped(this.completed, this.total);

  @override
  String toString() => 'Stopped after completing $completed of $total';
}

class _Completed extends BakeState {
  final int completed, total;

  Null get current => null;

  const _Completed(this.completed, this.total);

  @override
  String toString() => 'Completed $completed of $total';
}
