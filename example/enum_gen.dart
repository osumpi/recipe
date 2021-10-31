import 'package:dart_style/dart_style.dart';

void main(List<String> args) {
  EnumsGenerationSchema schema = {
    'Genders': [
      'male',
      'female',
    ],
    'RecipeTypes': [
      'singleInputSingleOutputRecipe',
      'singleInputMultipleOutputRecipe',
      'multipleInputSingleOutputRecipe',
      'multipleInputMultipleOutputRecipe',
    ]
  };

  var result = EnumGenerator(schema).generate();

  print(result);
}

typedef EnumsGenerationSchema = Map<String, List<String>>;

class EnumGenerator {
  EnumGenerator(this._content);

  final EnumsGenerationSchema _content;

  final _dartFmt = DartFormatter();

  String generate() {
    final buffer = StringBuffer();

    _content.forEach((key, value) {
      buffer.write("enum $key { ${value.join(', ')}, }\n\n");
    });

    return _dartFmt.format(buffer.toString());
  }
}
