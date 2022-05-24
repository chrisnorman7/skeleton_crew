// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ambiance_reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AmbianceReference _$AmbianceReferenceFromJson(Map<String, dynamic> json) =>
    AmbianceReference(
      id: json['id'] as String,
      sound: SoundReference.fromJson(json['sound'] as Map<String, dynamic>),
      x: (json['x'] as num?)?.toDouble(),
      y: (json['y'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AmbianceReferenceToJson(AmbianceReference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sound': instance.sound,
      'x': instance.x,
      'y': instance.y,
    };
