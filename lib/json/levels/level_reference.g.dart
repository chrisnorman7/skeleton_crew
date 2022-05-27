// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LevelReference _$LevelReferenceFromJson(Map<String, dynamic> json) =>
    LevelReference(
      id: json['id'] as String,
      title: json['title'] as String,
      className: json['className'] as String? ?? 'CustomLevel',
      comment: json['comment'] as String? ?? 'A level which must be extended.',
      music: json['music'] == null
          ? null
          : SoundReference.fromJson(json['music'] as Map<String, dynamic>),
      ambiances: (json['ambiances'] as List<dynamic>?)
          ?.map((e) => AmbianceReference.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LevelReferenceToJson(LevelReference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'className': instance.className,
      'comment': instance.comment,
      'music': instance.music,
      'ambiances': instance.ambiances,
    };
