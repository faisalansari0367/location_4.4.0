import 'package:json_annotation/json_annotation.dart';

part 'form_keys.g.dart';

@JsonSerializable()
class FormKeys {
  final String key;
  final String description;
  final int index;
  final String dataType;
  final List<String>? acceptableValue;

  FormKeys({
    required this.key,
    required this.description,
    required this.index,
    required this.dataType,
    this.acceptableValue,
  });

  factory FormKeys.fromJson(Map<String, dynamic> json) =>
      _$FormKeysFromJson(json);

  Map<String, dynamic> toJson() => _$FormKeysToJson(this);
}
