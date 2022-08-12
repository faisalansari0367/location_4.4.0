// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OtpModel {
  final String email;
  final String otp;
  final String? password;

  OtpModel({this.password, required this.email, required this.otp});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'email': email.trim(),
      'otp': otp.trim(),
    };
    if(password != null) map['password'] = password!.trim();
    return map;
  }

  factory OtpModel.fromMap(Map<String, dynamic> map) {
    return OtpModel(
      email: map['email'] as String,
      otp: map['otp'] as String,
      password: map['password'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OtpModel.fromJson(String source) =>
      OtpModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
