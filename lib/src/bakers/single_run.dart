// import 'package:recipe/foundation.dart';

// /// Baker that permits the associated [Recipe] to be baked only once in the
// /// current runtime.
// abstract class SingleRunBaker with BakerBase implements Baker {
//   /// Whether the [SingleRunBaker] should throw when the requested bake was
//   /// rejected.
//   ///
//   /// If set to `true`, throws [StateError] if the input [BakeContext] was
//   /// rejected from being baked.
//   ///
//   /// If set to `false`, just logs an error if the input [BakeContext] was
//   /// rejected from being baked.
//   bool get shouldThrowWhenBakeRejected => false;

//   @override
//   Future<BakeReport> startBake(final BakeContext inputContext) async {
//     uptimeStopwatch.start();
//     canBake = false;

//     final startedOn = DateTime.now();
//     final key = uuid.v4();

//     // TODO: listen and report recipe.bakeCompletedWithContext / hook to output
//     await bake(inputContext);

//     final stoppedOn = DateTime.now();

//     final report = BakeReport(
//       bakeId: key,
//       bakedBy: this,
//       startedOn: startedOn,
//       stoppedOn: stoppedOn,
//       inputContext: inputContext,
//     );

//     bakeLog.add(report);

//     uptimeStopwatch.stop();

//     return report;
//   }

//   @override
//   @nonVirtual
//   bool canBake = true;

//   @override
//   void requestBake(final BakeContext inputContext) {
//     if (canBake) {
//       startBake(inputContext);
//       canBake = false;
//     } else {
//       final bakeRejectReason =
//           'Bake request rejected. $bakerType does not allow more than one bake requests.';

//       if (shouldThrowWhenBakeRejected) {
//         throw StateError(bakeRejectReason);
//       } else {
//         error(bakeRejectReason);
//       }
//     }
//   }
// }
