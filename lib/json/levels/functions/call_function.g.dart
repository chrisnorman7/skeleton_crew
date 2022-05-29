// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_function.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallFunction _$CallFunctionFromJson(Map<String, dynamic> json) => CallFunction(
      id: json['id'] as String,
      text: json['text'] as String?,
      soundReference: json['soundReference'] == null
          ? null
          : SoundReference.fromJson(
              json['soundReference'] as Map<String, dynamic>),
      functionName: json['functionName'] as String?,
    );

Map<String, dynamic> _$CallFunctionToJson(CallFunction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'soundReference': instance.soundReference,
      'functionName': instance.functionName,
    };
