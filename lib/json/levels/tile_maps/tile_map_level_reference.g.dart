// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tile_map_level_reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TileMapLevelReference _$TileMapLevelReferenceFromJson(
        Map<String, dynamic> json) =>
    TileMapLevelReference(
      id: json['id'] as String,
      tileMapId: json['tileMapId'] as String,
      title: json['title'] as String? ?? 'Untitled Map Level',
      className: json['className'] as String? ?? 'CustomMapLevel',
      comment: json['comment'] as String? ?? 'A new map level.',
      ambiances: (json['ambiances'] as List<dynamic>?)
          ?.map((e) => AmbianceReference.fromJson(e as Map<String, dynamic>))
          .toList(),
      commands: (json['commands'] as List<dynamic>?)
          ?.map(
              (e) => LevelCommandReference.fromJson(e as Map<String, dynamic>))
          .toList(),
      functions: (json['functions'] as List<dynamic>?)
          ?.map((e) => FunctionReference.fromJson(e as Map<String, dynamic>))
          .toList(),
      music: json['music'] == null
          ? null
          : SoundReference.fromJson(json['music'] as Map<String, dynamic>),
      initialCoordinates: json['initialCoordinates'] == null
          ? null
          : Coordinates.fromJson(
              json['initialCoordinates'] as Map<String, dynamic>),
      initialHeading: json['initialHeading'] as int? ?? 0,
    );

Map<String, dynamic> _$TileMapLevelReferenceToJson(
        TileMapLevelReference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'className': instance.className,
      'comment': instance.comment,
      'music': instance.music,
      'ambiances': instance.ambiances,
      'commands': instance.commands,
      'functions': instance.functions,
      'tileMapId': instance.tileMapId,
      'initialCoordinates': instance.initialCoordinates,
      'initialHeading': instance.initialHeading,
    };
