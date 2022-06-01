// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialogue_level_reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DialogueLevelReference _$DialogueLevelReferenceFromJson(
        Map<String, dynamic> json) =>
    DialogueLevelReference(
      id: json['id'] as String,
      title: json['title'] as String,
      className: json['className'] as String? ?? 'CustomDialogueLevelBase',
      ambiances: (json['ambiances'] as List<dynamic>?)
          ?.map((e) => AmbianceReference.fromJson(e as Map<String, dynamic>))
          .toList(),
      commands: (json['commands'] as List<dynamic>?)
          ?.map(
              (e) => LevelCommandReference.fromJson(e as Map<String, dynamic>))
          .toList(),
      comment: json['comment'] as String? ??
          'A dialogue level that needs a comment.',
      functions: (json['functions'] as List<dynamic>?)
          ?.map((e) => FunctionReference.fromJson(e as Map<String, dynamic>))
          .toList(),
      music: json['music'] == null
          ? null
          : SoundReference.fromJson(json['music'] as Map<String, dynamic>),
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => MessageReference.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DialogueLevelReferenceToJson(
        DialogueLevelReference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'className': instance.className,
      'comment': instance.comment,
      'music': instance.music,
      'ambiances': instance.ambiances,
      'commands': instance.commands,
      'functions': instance.functions,
      'messages': instance.messages,
    };
