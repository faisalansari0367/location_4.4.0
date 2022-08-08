// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RoleDetailsModel {
  final List<String> data;

  RoleDetailsModel({this.data = const []});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data': data,
    };
  }

  factory RoleDetailsModel.fromMap(Map<String, dynamic> map) {
    return RoleDetailsModel(data: List<String>.from((map['data'])));
  }

  String toJson() => json.encode(toMap());

  factory RoleDetailsModel.fromJson(String source) =>
      RoleDetailsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
