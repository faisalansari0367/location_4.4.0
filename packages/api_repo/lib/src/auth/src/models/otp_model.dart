// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OtpModel {
  final String email;
  final String otp;

  OtpModel({required this.email, required this.otp});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email.trim(),
      'otp': otp.trim(),
    };
  }

  factory OtpModel.fromMap(Map<String, dynamic> map) {
    return OtpModel(
      email: map['email'] as String,
      otp: map['otp'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OtpModel.fromJson(String source) =>
      OtpModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
