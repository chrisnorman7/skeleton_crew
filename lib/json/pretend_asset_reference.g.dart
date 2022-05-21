// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pretend_asset_reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PretendAssetReference _$PretendAssetReferenceFromJson(
        Map<String, dynamic> json) =>
    PretendAssetReference(
      id: json['id'] as String,
      variableName: json['variableName'] as String,
      comment: json['comment'] as String,
      name: json['name'] as String,
      assetType: $enumDecode(_$AssetTypeEnumMap, json['assetType']),
      encryptionKey: json['encryptionKey'] as String?,
    );

Map<String, dynamic> _$PretendAssetReferenceToJson(
        PretendAssetReference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'variableName': instance.variableName,
      'comment': instance.comment,
      'name': instance.name,
      'assetType': _$AssetTypeEnumMap[instance.assetType],
      'encryptionKey': instance.encryptionKey,
    };

const _$AssetTypeEnumMap = {
  AssetType.file: 'file',
  AssetType.collection: 'collection',
};
