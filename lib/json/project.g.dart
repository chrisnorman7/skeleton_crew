// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
      title: json['title'] as String,
      gameClassName: json['gameClassName'] as String? ?? 'CustomGame',
      gameClassComment: json['gameClassComment'] as String? ?? 'A custom game.',
      commandTriggers: (json['commandTriggers'] as List<dynamic>?)
          ?.map((e) =>
              CommandTriggerReference.fromJson(e as Map<String, dynamic>))
          .toList(),
      assetStores: (json['assetStores'] as List<dynamic>?)
          ?.map((e) => AssetStoreReference.fromJson(e as Map<String, dynamic>))
          .toList(),
      orgName: json['orgName'] as String? ?? 'com.example',
      appName: json['appName'] as String? ?? 'untitled_game',
      outputDirectory: json['outputDirectory'] as String? ?? 'lib/generated',
      menus: (json['menus'] as List<dynamic>?)
          ?.map((e) => MenuReference.fromJson(e as Map<String, dynamic>))
          .toList(),
      levels: (json['levels'] as List<dynamic>?)
          ?.map((e) => LevelReference.fromJson(e as Map<String, dynamic>))
          .toList(),
      tileMapFlags: (json['tileMapFlags'] as List<dynamic>?)
          ?.map((e) => TileMapFlag.fromJson(e as Map<String, dynamic>))
          .toList(),
      tileMaps: (json['tileMaps'] as List<dynamic>?)
          ?.map((e) => TileMapReference.fromJson(e as Map<String, dynamic>))
          .toList(),
      tileMapLevels: (json['tileMapLevels'] as List<dynamic>?)
          ?.map(
              (e) => TileMapLevelReference.fromJson(e as Map<String, dynamic>))
          .toList(),
      dialogueLevels: (json['dialogueLevels'] as List<dynamic>?)
          ?.map(
              (e) => DialogueLevelReference.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'title': instance.title,
      'orgName': instance.orgName,
      'appName': instance.appName,
      'outputDirectory': instance.outputDirectory,
      'gameClassName': instance.gameClassName,
      'gameClassComment': instance.gameClassComment,
      'commandTriggers': instance.commandTriggers,
      'assetStores': instance.assetStores,
      'menus': instance.menus,
      'levels': instance.levels,
      'tileMapFlags': instance.tileMapFlags,
      'tileMaps': instance.tileMaps,
      'tileMapLevels': instance.tileMapLevels,
      'dialogueLevels': instance.dialogueLevels,
    };
