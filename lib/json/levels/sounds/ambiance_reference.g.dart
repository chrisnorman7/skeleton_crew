// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ambiance_reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AmbianceReference _$AmbianceReferenceFromJson(Map<String, dynamic> json) =>
    AmbianceReference(
      id: json['id'] as String,
      sound: SoundReference.fromJson(json['sound'] as Map<String, dynamic>),
      coordinates: json['coordinates'] == null
          ? null
          : Coordinates.fromJson(json['coordinates'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AmbianceReferenceToJson(AmbianceReference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sound': instance.sound,
      'coordinates': instance.coordinates,
    };
