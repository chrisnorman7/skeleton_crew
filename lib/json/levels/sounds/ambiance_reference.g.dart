// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ambiance_reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AmbianceReference _$AmbianceReferenceFromJson(Map<String, dynamic> json) =>
    AmbianceReference(
      sound: SoundReference.fromJson(json['sound'] as Map<String, dynamic>),
      x: (json['x'] as num?)?.toDouble(),
      y: (json['y'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AmbianceReferenceToJson(AmbianceReference instance) =>
    <String, dynamic>{
      'sound': instance.sound,
      'x': instance.x,
      'y': instance.y,
    };
