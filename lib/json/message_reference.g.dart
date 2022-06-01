// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageReference _$MessageReferenceFromJson(Map<String, dynamic> json) =>
    MessageReference(
      id: json['id'] as String,
      text: json['text'] as String?,
      soundReference: json['soundReference'] == null
          ? null
          : SoundReference.fromJson(
              json['soundReference'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MessageReferenceToJson(MessageReference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'soundReference': instance.soundReference,
    };
