// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
      title: json['title'] as String,
      commandTriggers: (json['commandTriggers'] as List<dynamic>)
          .map((e) => CommandTrigger.fromJson(e as Map<String, dynamic>))
          .toList(),
      assetStores: (json['assetStores'] as List<dynamic>)
          .map((e) => AssetStore.fromJson(e as Map<String, dynamic>))
          .toList(),
      orgName: json['orgName'] as String? ?? 'com.example',
      appName: json['appName'] as String? ?? 'untitled_game',
      version: json['version'] as String? ?? '0.0.0',
      outputDirectory: json['outputDirectory'] as String? ?? 'lib',
      commandTriggersFilename:
          json['commandTriggersFilename'] as String? ?? 'triggers.dart',
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'title': instance.title,
      'orgName': instance.orgName,
      'appName': instance.appName,
      'version': instance.version,
      'outputDirectory': instance.outputDirectory,
      'commandTriggersFilename': instance.commandTriggersFilename,
      'commandTriggers': instance.commandTriggers,
      'assetStores': instance.assetStores,
    };
