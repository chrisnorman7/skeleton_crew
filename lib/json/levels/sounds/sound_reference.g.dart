// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sound_reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SoundReference _$SoundReferenceFromJson(Map<String, dynamic> json) =>
    SoundReference(
      assetStoreId: json['assetStoreId'] as String,
      assetReferenceId: json['assetReferenceId'] as String,
      gain: (json['gain'] as num?)?.toDouble() ?? 0.7,
    );

Map<String, dynamic> _$SoundReferenceToJson(SoundReference instance) =>
    <String, dynamic>{
      'assetStoreId': instance.assetStoreId,
      'assetReferenceId': instance.assetReferenceId,
      'gain': instance.gain,
    };
