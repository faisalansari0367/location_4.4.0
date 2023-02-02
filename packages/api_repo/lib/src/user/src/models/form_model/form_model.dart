// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:api_repo/src/log/models/enum/declaration_form_type.dart';
import 'package:json_annotation/json_annotation.dart';

import 'form_keys.dart';

part 'form_model.g.dart';

@JsonSerializable()
class DeclarationForms {
  final int id;
  final DeclarationFormType type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<FormKeys> formKeys;

  DeclarationForms({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.formKeys,
  });

  factory DeclarationForms.fromJson(Map<String, dynamic> json) =>
      _$DeclarationFormsFromJson(json);

  Map<String, dynamic> toJson() => _$DeclarationFormsToJson(this);
}
