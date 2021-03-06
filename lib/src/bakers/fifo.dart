// class FirstInFirstOutBaker = NonConcurrentBaker with _FIFOBakeHandler;
// // class AngryBaker = NonConcurrentBaker with _AngryBakeHandler;
// // class IncapacitatedConcurrentBaker = ConcurrentBaker with IncapacitatedBaker;
// // class IncapacitatedFIFOBaker = FirstInFirstOutBaker with IncapacitatedBaker;
// // class LazyBaker = FirstInFirstOutBaker with _LazyBakeHandler;
// // class RandomBaker = NonConcurrentBaker with _RandomBakeHandler;
// // class LimitedConcurrentBaker = ConcurrentBaker
// //     with _LimitedConcurrencyBakeHandler;

// mixin _FIFOBakeHandler on NonConcurrentBaker {
//   final requests = ListQueue<BakeContext>();

//   @override
//   Future<BakeReport> bake(final BakeContext inputContext) async {
//     uptimeStopwatch.start();

//     final startedOn = DateTime.now();
//     final key = uuid.v4();

//     // TODO: listen and report recipe.bakeCompletedWithContext / hook to output
//     await recipe.bake(inputContext);

//     final report = BakeReport(
//       bakeId: key,
//       bakedBy: this,
//       startedOn: startedOn,
//       stoppedOn: DateTime.now(),
//       inputContext: inputContext,
//     );

//     bakeLog.add(report);

//     uptimeStopwatch.stop();

//     unawaited(tryCompletePendingRequests());

//     return report;
//   }

//   @override
//   void handleBakeRequestWhenBaking(final BakeContext inputContext) {
//     requests.add(inputContext);
//   }

//   /// Voluntarily marked as future to allow requesting bake stream to close
//   /// without waiting for this to complete.
//   ///
//   /// Do not await this future inside [bake].
//   Future<void> tryCompletePendingRequests() async {
//     if (requests.isNotEmpty) {
//       unawaited(bake(requests.removeFirst()));
//     }
//   }
// }
