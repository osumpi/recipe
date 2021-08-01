// GENERATED CODE - DO NOT MODIFY BY HAND

part of recipe;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ParsedRecipe _$_ParsedRecipeFromJson(Map json) {
  return $checkedNew('_ParsedRecipe', json, () {
    $checkKeys(json,
        requiredKeys: const ['name'], disallowNullValues: const ['name']);
    final val = _ParsedRecipe(
      name: $checkedConvert(json, 'name', (v) => v as String),
      description:
          $checkedConvert(json, 'description', (v) => v as String?) ?? '',
      version: $checkedConvert(json, 'version', (v) => v as String?) ??
          '0.0.0-unknown',
      author:
          $checkedConvert(json, 'author', (v) => v as String?) ?? '<unknown>',
      properties: $checkedConvert(
              json,
              'properties',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => RecipeProperty.fromJson(e as Map))
                  .toList()) ??
          [],
      flows: $checkedConvert(
              json,
              'flows',
              (v) => (v as Map?)?.map(
                    (k, e) => MapEntry(k as String, Flow.fromJson(e as Map)),
                  )) ??
          {},
    );
    return val;
  });
}

Map<String, dynamic> _$_ParsedRecipeToJson(_ParsedRecipe instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'version': instance.version,
      'author': instance.author,
      'properties': instance.properties,
      'flows': instance.flows,
    };

RecipeProperty _$RecipePropertyFromJson(Map json) {
  return $checkedNew('RecipeProperty', json, () {
    $checkKeys(json,
        requiredKeys: const ['name'], disallowNullValues: const ['name']);
    final val = RecipeProperty(
      name: $checkedConvert(json, 'name', (v) => v as String),
      required: $checkedConvert(json, 'required', (v) => v as bool?) ?? true,
      defaultValue: $checkedConvert(json, 'default', (v) => v),
      minimum: $checkedConvert(json, 'minimum', (v) => v as num?),
      maximum: $checkedConvert(json, 'maximum', (v) => v as num?),
      description:
          $checkedConvert(json, 'description', (v) => v as String?) ?? '',
      options: $checkedConvert(
          json,
          'options',
          (v) => (v as Map?)?.map(
                (k, e) => MapEntry(k as String, e),
              )),
    );
    return val;
  }, fieldKeyMap: const {'defaultValue': 'default'});
}

Map<String, dynamic> _$RecipePropertyToJson(RecipeProperty instance) =>
    <String, dynamic>{
      'name': instance.name,
      'default': instance.defaultValue,
      'required': instance.required,
      'minimum': instance.minimum,
      'maximum': instance.maximum,
      'description': instance.description,
      'options': instance.options,
    };

Flow _$FlowFromJson(Map json) {
  return $checkedNew('Flow', json, () {
    final val = Flow(
      name: $checkedConvert(json, 'name', (v) => v as String?),
      description: $checkedConvert(json, 'description', (v) => v as String?),
      steps: $checkedConvert(
          json,
          'steps',
          (v) => (v as List<dynamic>?)
              ?.map((e) => Step.fromJson(e as Map))
              .toList()),
    );
    return val;
  });
}

Map<String, dynamic> _$FlowToJson(Flow instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'steps': instance.steps,
    };

Step _$StepFromJson(Map json) {
  return $checkedNew('Step', json, () {
    final val = Step(
      name: $checkedConvert(json, 'name', (v) => v as String?),
      uses: $checkedConvert(json, 'uses', (v) => v as String?),
      useArgs: $checkedConvert(
          json,
          'with',
          (v) => (v as Map?)?.map(
                (k, e) => MapEntry(k as String, e),
              )),
    );
    return val;
  }, fieldKeyMap: const {'useArgs': 'with'});
}

Map<String, dynamic> _$StepToJson(Step instance) => <String, dynamic>{
      'name': instance.name,
      'uses': instance.uses,
      'with': instance.useArgs,
    };
