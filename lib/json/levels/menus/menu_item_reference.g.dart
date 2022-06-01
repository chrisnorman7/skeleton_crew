// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item_reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuItemReference _$MenuItemReferenceFromJson(Map<String, dynamic> json) =>
    MenuItemReference(
      id: json['id'] as String,
      message: json['message'] == null
          ? null
          : MessageReference.fromJson(json['message'] as Map<String, dynamic>),
      callFunction: json['callFunction'] == null
          ? null
          : CallFunction.fromJson(json['callFunction'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MenuItemReferenceToJson(MenuItemReference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'callFunction': instance.callFunction,
    };
