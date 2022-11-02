// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:hive_flutter/adapters.dart';

class TokenData {
  final String accessToken;
  final int expiresIn;
  final String tokenType;
  final DateTime createdAt;

  TokenData({
    required this.accessToken,
    required this.expiresIn,
    required this.tokenType,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'access_token': accessToken,
      'expires_in': expiresIn,
      'token_type': tokenType,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory TokenData.fromJson(Map map) {
    return TokenData(
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
      accessToken: map['access_token'] as String,
      expiresIn: map['expires_in'] as int,
      tokenType: map['token_type'] as String,
    );
  }
}

class GrahphQlStorage {
  final Box box;

  GrahphQlStorage({required this.box});

  Future<TokenData> saveToken(Map token) async {
    final TokenData tokenData = TokenData.fromJson(token);
    await box.put('token', tokenData.toJson());
    return tokenData;
  }

  TokenData? getToken() {
    final data = box.get('token');
    if (data != null) {
      return TokenData.fromJson(data);
    }
    return null;
  }
}
