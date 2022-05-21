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
      assetType: $enumDecode(_$AssetTypeEnumMap, json['assetType']),
      name: json['name'] as String,
    );

Map<String, dynamic> _$PretendAssetReferenceToJson(
        PretendAssetReference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'variableName': instance.variableName,
      'comment': instance.comment,
      'assetType': _$AssetTypeEnumMap[instance.assetType],
      'name': instance.name,
    };

const _$AssetTypeEnumMap = {
  AssetType.file: 'file',
  AssetType.collection: 'collection',
};
