import 'package:recipe/recipe.dart';

void main() async {
  FrameworkUtils.loggingLevel = LogLevels.verbose;
  FrameworkUtils.showTimestampInLogs = true;

  // bake(MyRecipe()).listen(FrameworkUtils.log);
}
