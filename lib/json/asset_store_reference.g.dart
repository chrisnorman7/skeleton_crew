// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_store_reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetStoreReference _$AssetStoreReferenceFromJson(Map<String, dynamic> json) =>
    AssetStoreReference(
      id: json['id'] as String,
      name: json['name'] as String,
      assetStore:
          AssetStore.fromJson(json['assetStore'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AssetStoreReferenceToJson(
        AssetStoreReference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'assetStore': instance.assetStore,
    };
