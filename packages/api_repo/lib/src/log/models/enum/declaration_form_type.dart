import 'package:json_annotation/json_annotation.dart';

enum DeclarationFormType {
  @JsonValue('global')
  global,

  @JsonValue('aurora')
  aurora,

  @JsonValue('warakirri')
  warakirri,
}
