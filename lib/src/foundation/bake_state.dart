import 'package:meta/meta.dart';

@immutable
abstract class BakeState {
  const BakeState();

  const factory BakeState.notStarted() = _NotStarted;

  const factory BakeState.preparing() = _Preparing;

  const factory BakeState.baking(
    final int currentStep, {
    required final int of,
    final Duration? estimatedTimeToComplete,
  }) = _Baking;

  static const completed = _Completed();

  // TODO: add more states like: prematurely completed etc...

  @override
  String toString() => throw UnimplementedError();
}

class _NotStarted implements BakeState {
  const _NotStarted();

  // TODO: apply formatting.
  @override
  String toString() => 'Bake not started';
}

class _Preparing implements BakeState {
  const _Preparing();

  // TODO: apply formatting.
  @override
  String toString() => 'Preparing';
}

class _Baking extends BakeState {
  const _Baking(
    this.currentStep, {
    required final int of,
    final this.estimatedTimeToComplete,
  }) : totalSteps = of;

  final int currentStep;
  final int totalSteps;
  final Duration? estimatedTimeToComplete;

  // TODO: apply formatting.
  @override
  String toString() =>
      'Baking $currentStep/$totalSteps. ETC: $estimatedTimeToComplete';
}

class _Completed extends BakeState {
  const _Completed();

  // TODO: apply formatting
  @override
  String toString() => 'Completed';
}
