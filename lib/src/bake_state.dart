part of recipe;

@sealed
@immutable
abstract class BakeState {
  String get description;

  double get progress;

  const BakeState();

  factory BakeState.awaiting() => _Awaiting.instance;

  factory BakeState.baking(double progress) => _Baking(progress);

  factory BakeState.paused(double progress) => _Paused(progress);

  factory BakeState.partiallyBaked(double progress) =>
      _PartiallyBaked(progress);

  factory BakeState.baked() => _Baked.instance;

  factory BakeState.abortive() => _Abortive.instance;

  bool get isAwaiting => this is _Awaiting;
  bool get isBaking => this is _Baking;
  bool get isPaused => this is _Paused;
  bool get isPartiallyBaked => this is _PartiallyBaked;
  bool get isBaked => this is _Baked;
  bool get isAbortive => this is _Abortive;

  static BakeState combine(Iterable<BakeState> states) {
    assert(states.isNotEmpty);

    final progress =
        states.fold<double>(0.0, (a, b) => a + b.progress) / states.length;

    return {...states}.reduce((a, b) {
      if (a == b) return a;

      if (a.isBaking || b.isBaking) return BakeState.baking(progress);
      if (a.isPaused || b.isPaused) return BakeState.paused(progress);
      if (a.isAbortive || b.isAbortive) return BakeState.abortive();
      if (a.isPartiallyBaked || b.isPartiallyBaked)
        return BakeState.partiallyBaked(progress);

      return BakeState.baking(progress);
    });
  }

  @override
  String toString() {
    if (progress == 0.0) {
      return description;
    } else {
      return '$description (${(progress * 100).toStringAsFixed(0)} %)';
    }
  }
}

class _Awaiting extends BakeState {
  const _Awaiting._();

  static const instance = _Awaiting._();

  @override
  String get description => 'Awaiting';

  @override
  double get progress => 0.0;
}

class _Baking extends BakeState {
  @override
  String get description => 'Baking';

  const _Baking(this.progress) : assert(0 <= progress && progress <= 1);

  final double progress;
}

class _Paused extends BakeState {
  @override
  String get description => 'Paused';

  const _Paused(this.progress) : assert(0 <= progress && progress <= 1);

  final double progress;
}

class _Baked extends BakeState {
  const _Baked();

  static const instance = _Baked();

  @override
  String get description => 'Baked';

  @override
  double get progress => 1.0;
}

class _PartiallyBaked extends BakeState {
  @override
  String get description => 'Partially Baked';

  const _PartiallyBaked(this.progress) : assert(0 <= progress && progress <= 1);

  final double progress;
}

class _Abortive extends BakeState {
  const _Abortive._();

  static const instance = _Abortive._();

  @override
  String get description => 'Abortive';

  @override
  double get progress => 0.0;
}
