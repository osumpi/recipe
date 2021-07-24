part of recipe;

@sealed
@JsonSerializable(anyMap: true, checked: true)
class _ParsedRecipe extends Recipe {
  @JsonKey(required: true, disallowNullValue: true)
  final String name;

  @JsonKey(defaultValue: '')
  final String description;

  @JsonKey(defaultValue: r'0.0.0-unknown')
  final String version;

  @JsonKey(defaultValue: '<unknown>')
  final String author;

  @JsonKey(defaultValue: const <RecipeProperty>[])
  final List<RecipeProperty> properties;

  @JsonKey(defaultValue: <String, Flow>{})
  final Map<String, Flow> flows;

  _ParsedRecipe({
    required this.name,
    required this.description,
    required this.version,
    required this.author,
    required this.properties,
    required this.flows,
  }) {
    if (name.isEmpty) {
      throw ArgumentError.value(name, 'name', 'Cannot be empty.');
    }
  }

  factory _ParsedRecipe.fromMap(Map json) => _$_ParsedRecipeFromJson(json);

  Map<String, dynamic> toJson() => _$_ParsedRecipeToJson(this);

  bake(BakeContext context) {
    throw UnimplementedError();
  }
}

@JsonSerializable(anyMap: true, checked: true)
class RecipeProperty {
  @JsonKey(required: true, disallowNullValue: true)
  final String name;

  @JsonKey(name: 'default')
  final defaultValue;

  @JsonKey(defaultValue: true)
  final bool required;

  final num? minimum;
  final num? maximum;

  @JsonKey(defaultValue: '')
  final String description;

  final Map<String, dynamic>? options;

  RecipeProperty({
    required this.name,
    required this.required,
    this.defaultValue,
    this.minimum,
    this.maximum,
    required this.description,
    this.options,
  }) {
    if (name.isEmpty) {
      throw ArgumentError.value(name, 'name', 'Cannot be empty.');
    }

    if (!required && defaultValue == null) {
      throw ArgumentError.value(defaultValue, 'default',
          'Value cannot be null when `required: false`. A default value has to be provided.');
    }
  }

  factory RecipeProperty.fromJson(Map json) => _$RecipePropertyFromJson(json);

  Map<String, dynamic> toJson() => _$RecipePropertyToJson(this);

  @override
  String toString() => 'Recipe Property($name)';
}

@JsonSerializable(anyMap: true, checked: true)
class Flow {
  final String? name;
  final String? description;

  final List<Step>? steps;

  Flow({
    this.name,
    this.description,
    this.steps,
  }) {}

  factory Flow.fromJson(Map json) => _$FlowFromJson(json);

  Map<String, dynamic> toJson() => _$FlowToJson(this);

  @override
  String toString() => 'Flow: ${toJson()}';
}

@JsonSerializable(anyMap: true, checked: true)
class Step {
  final String? name;
  final String? uses;

  @JsonKey(name: 'with')
  final Map<String, dynamic>? useArgs;

  Step({
    this.name,
    this.uses,
    this.useArgs,
  }) {}

  factory Step.fromJson(Map json) => _$StepFromJson(json);

  Map<String, dynamic> toJson() => _$StepToJson(this);

  @override
  String toString() => 'Step: ${toJson()}';
}
