// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tile_map_reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TileMapReference _$TileMapReferenceFromJson(Map<String, dynamic> json) =>
    TileMapReference(
      id: json['id'] as String,
      name: json['name'] as String,
      variableName: json['variableName'] as String,
      tiles: (json['tiles'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            int.parse(k),
            (e as Map<String, dynamic>).map(
              (k, e) => MapEntry(int.parse(k),
                  (e as List<dynamic>).map((e) => e as String).toList()),
            )),
      ),
      width: json['width'] as int? ?? 10,
      height: json['height'] as int? ?? 10,
      defaultFlagIds: (json['defaultFlagIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$TileMapReferenceToJson(TileMapReference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'variableName': instance.variableName,
      'width': instance.width,
      'height': instance.height,
      'defaultFlagIds': instance.defaultFlagIds,
      'tiles': instance.tiles.map((k, e) =>
          MapEntry(k.toString(), e.map((k, e) => MapEntry(k.toString(), e)))),
    };
