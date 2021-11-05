library recipe.baker;

import 'dart:collection' show ListQueue;

import 'package:meta/meta.dart';

import 'package:recipe/src/bake_report.dart' show BakeReport;
import 'package:recipe/src/recipe.dart' show Recipe;
import 'package:recipe/src/bake_context.dart' show BakeContext;
import 'package:recipe/src/utils.dart' show uuid;

part 'src/baker.dart';

part 'src/single_run.dart';
part 'src/concurrent.dart';
part 'src/non_concurrent.dart';
part 'src/fifo.dart';

class SingleRunBaker = Baker with _SingleRunBakeHandler;

class ConcurrentBaker = Baker with _ConcurrentBakeHandler;

abstract class NonConcurrentBaker = Baker with _NonConcurrentBakerMixin;

class FirstInFirstOutBaker = NonConcurrentBaker with _FIFOBakeHandler;
// class AngryBaker = NonConcurrentBaker with _AngryBakeHandler;
// class IncapacitatedConcurrentBaker = ConcurrentBaker with IncapacitatedBaker;
// class IncapacitatedFIFOBaker = FirstInFirstOutBaker with IncapacitatedBaker;
// class LazyBaker = FirstInFirstOutBaker with _LazyBakeHandler;
// class RandomBaker = NonConcurrentBaker with _RandomBakeHandler;
// class LimitedConcurrentBaker = ConcurrentBaker
//     with _LimitedConcurrencyBakeHandler;
