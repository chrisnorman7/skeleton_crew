// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'command_trigger_reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommandTriggerReference _$CommandTriggerReferenceFromJson(
        Map<String, dynamic> json) =>
    CommandTriggerReference(
      id: json['id'] as String,
      variableName: json['variableName'] as String,
      commandTrigger: CommandTrigger.fromJson(
          json['commandTrigger'] as Map<String, dynamic>),
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$CommandTriggerReferenceToJson(
        CommandTriggerReference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'variableName': instance.variableName,
      'comment': instance.comment,
      'commandTrigger': instance.commandTrigger,
    };
