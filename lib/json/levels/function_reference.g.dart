// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'function_reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FunctionReference _$FunctionReferenceFromJson(Map<String, dynamic> json) =>
    FunctionReference(
      name: json['name'] as String,
      comment: json['comment'] as String? ??
          'TODO(Someone): Enter a sensible comment.',
      text: json['text'] as String?,
      soundReference: json['soundReference'] == null
          ? null
          : SoundReference.fromJson(
              json['soundReference'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FunctionReferenceToJson(FunctionReference instance) =>
    <String, dynamic>{
      'name': instance.name,
      'comment': instance.comment,
      'text': instance.text,
      'soundReference': instance.soundReference,
    };
