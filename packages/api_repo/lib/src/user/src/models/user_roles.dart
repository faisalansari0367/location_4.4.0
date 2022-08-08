// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserRoles {
  final List<String> roles;

  UserRoles({this.roles = const []});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data': roles,
    };
  }

  factory UserRoles.fromMap(Map<String, dynamic> map) {
    return UserRoles(roles: List<String>.from((map['data'])));
  }

  String toJson() => json.encode(toMap());

  factory UserRoles.fromJson(String source) =>
      UserRoles.fromMap(json.decode(source) as Map<String, dynamic>);
}
