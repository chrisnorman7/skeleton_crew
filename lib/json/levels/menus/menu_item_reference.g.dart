// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item_reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuItemReference _$MenuItemReferenceFromJson(Map<String, dynamic> json) =>
    MenuItemReference(
      id: json['id'] as String,
      title: json['title'] as String?,
      soundReference: json['soundReference'] == null
          ? null
          : SoundReference.fromJson(
              json['soundReference'] as Map<String, dynamic>),
      callFunction: json['callFunction'] == null
          ? null
          : CallFunction.fromJson(json['callFunction'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MenuItemReferenceToJson(MenuItemReference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'soundReference': instance.soundReference,
      'callFunction': instance.callFunction,
    };
