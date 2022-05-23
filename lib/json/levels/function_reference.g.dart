// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'function_reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FunctionReference _$FunctionReferenceFromJson(Map<String, dynamic> json) =>
    FunctionReference(
      name: json['name'] as String,
      comment: json['comment'] as String? ??
          'TODO(Someone): Enter a sensible comment.',
    );

Map<String, dynamic> _$FunctionReferenceToJson(FunctionReference instance) =>
    <String, dynamic>{
      'name': instance.name,
      'comment': instance.comment,
    };
