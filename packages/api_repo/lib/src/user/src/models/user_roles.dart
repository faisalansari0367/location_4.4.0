// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserRoles {
  final List<String> fields;
  final String role;

  UserRoles({
    required this.fields,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fields': fields,
      'role': role,
    };
  }

  factory UserRoles.fromMap(Map<String, dynamic> map) {
    return UserRoles(
      fields: List<String>.from(map['fields']),
      role: map['role'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserRoles.fromJson(String source) => UserRoles.fromMap(json.decode(source) as Map<String, dynamic>);
}
