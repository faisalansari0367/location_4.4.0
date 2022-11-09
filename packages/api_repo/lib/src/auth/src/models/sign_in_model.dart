import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SignInModel {
  final String email;
  final String password;
  SignInModel({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email.trim(),
      'password': password.trim(),
    };
  }

  factory SignInModel.fromMap(Map<String, dynamic> map) {
    return SignInModel(
      email: map['email'].toString().trim(),
      password: map['password'].toString().trim(),
    );
  }

  String toJson() => json.encode(toMap());

  factory SignInModel.fromJson(String source) => SignInModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant SignInModel other) {
    if (identical(this, other)) return true;

    return other.email.trim() == email.trim() && other.password.trim() == password.trim();
  }

  @override
  int get hashCode => email.hashCode ^ password.hashCode;
}
