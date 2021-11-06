import 'package:recipe/recipe.dart';
import 'package:recipe/src/ports/ports.dart';

void main() async {
  FrameworkUtils.loggingLevel = LogLevels.verbose;
  FrameworkUtils.showTimestampInLogs = true;

  // bake(MyRecipe()).listen(FrameworkUtils.log);
}

class MyRecipe extends Recipe {
  late final InputPort<double> theta;

  @override
  void initialize() {
    // Temperory solution until meta is fixed. Try on dart not from flutter-sdk.
    final theta = inputPort<double>('theta');
    this.theta = theta;

    super.initialize();
  }

  @override
  Future<void> bake(BakeContext<Object> context) {
    throw UnimplementedError();
  }
}
