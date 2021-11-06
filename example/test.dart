import 'package:recipe/recipe.dart';
import 'package:recipe/src/ports/ports.dart';
import 'package:recipe/src/recipe.dart';

void main() async {
  FrameworkUtils.loggingLevel = LogLevels.verbose;
  FrameworkUtils.showTimestampInLogs = true;

  // bake(MyRecipe()).listen(FrameworkUtils.log);
}

class MySimpleRecipe extends Recipe<int, String> {
  MySimpleRecipe()
      : super(
          inputPort: MultiInboundInputPort('value'),
          outputPort: OutputPort('asString'),
        );

  @override
  Stream<String> bake(BakeContext<int> context) async* {
    yield context.data.toString();
  }
}
