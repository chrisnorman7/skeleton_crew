// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_command_reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LevelCommandReference _$LevelCommandReferenceFromJson(
        Map<String, dynamic> json) =>
    LevelCommandReference(
      id: json['id'] as String,
      commandTriggerId: json['commandTriggerId'] as String,
      startFunction: json['startFunction'] == null
          ? null
          : CallFunction.fromJson(
              json['startFunction'] as Map<String, dynamic>),
      stopFunction: json['stopFunction'] == null
          ? null
          : CallFunction.fromJson(json['stopFunction'] as Map<String, dynamic>),
      undoFunction: json['undoFunction'] == null
          ? null
          : CallFunction.fromJson(json['undoFunction'] as Map<String, dynamic>),
      interval: json['interval'] as int?,
    );

Map<String, dynamic> _$LevelCommandReferenceToJson(
        LevelCommandReference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'commandTriggerId': instance.commandTriggerId,
      'startFunction': instance.startFunction,
      'stopFunction': instance.stopFunction,
      'undoFunction': instance.undoFunction,
      'interval': instance.interval,
    };
