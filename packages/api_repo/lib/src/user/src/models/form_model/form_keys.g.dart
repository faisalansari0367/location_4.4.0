// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_keys.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormKeys _$FormKeysFromJson(Map<String, dynamic> json) => FormKeys(
      key: json['key'] as String,
      description: json['description'] as String,
      index: json['index'] as int,
      dataType: json['dataType'] as String,
      acceptableValue: (json['acceptableValue'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$FormKeysToJson(FormKeys instance) => <String, dynamic>{
      'key': instance.key,
      'description': instance.description,
      'index': instance.index,
      'dataType': instance.dataType,
      'acceptableValue': instance.acceptableValue,
    };
