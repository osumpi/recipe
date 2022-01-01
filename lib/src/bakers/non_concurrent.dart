// /// Baker that permits only one bake at any given moment on a recipe.
// /// This baker cannot be used directly as it does not define how the bake
// /// should be handled.
// ///
// /// For all usable [NonConcurrentBaker]s, see:
// /// * [FirstInFirstOutBaker]
// abstract class NonConcurrentBaker = Baker with _NonConcurrentBakerMixin;

// mixin _NonConcurrentBakerMixin on Baker {
//   @override
//   @nonVirtual
//   final concurrencyAllowed = false;

//   @override
//   bool get canBake => isIdle;

//   @override
//   void requestBake(final BakeContext inputContext) {
//     if (canBake) {
//       bake(inputContext);
//     } else {
//       handleBakeRequestWhenBaking(inputContext);
//     }
//   }

//   void handleBakeRequestWhenBaking(final BakeContext inputContext);
// }
