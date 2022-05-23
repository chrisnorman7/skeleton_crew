// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_store_reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetStoreReference _$AssetStoreReferenceFromJson(Map<String, dynamic> json) =>
    AssetStoreReference(
      id: json['id'] as String,
      name: json['name'] as String,
      comment: json['comment'] as String,
      dartFilename: json['dartFilename'] as String,
      assets: (json['assets'] as List<dynamic>)
          .map((e) => PretendAssetReference.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AssetStoreReferenceToJson(
        AssetStoreReference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'comment': instance.comment,
      'dartFilename': instance.dartFilename,
      'assets': instance.assets,
    };
