// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeclarationForms _$DeclarationFormsFromJson(Map<String, dynamic> json) =>
    DeclarationForms(
      id: json['id'] as int,
      type: $enumDecode(_$DeclarationFormTypeEnumMap, json['type']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      formKeys: (json['formKeys'] as List<dynamic>)
          .map((e) => FormKeys.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DeclarationFormsToJson(DeclarationForms instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$DeclarationFormTypeEnumMap[instance.type]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'formKeys': instance.formKeys,
    };

const _$DeclarationFormTypeEnumMap = {
  DeclarationFormType.global: 'global',
  DeclarationFormType.aurora: 'aurora',
  DeclarationFormType.warakirri: 'warakirri',
};
