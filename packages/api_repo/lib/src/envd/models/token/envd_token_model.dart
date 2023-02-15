class EnvdTokenModel {
  final String accessToken;
  final int expiresIn;
  final String tokenType;
  final DateTime createdAt;

  EnvdTokenModel({
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

  factory EnvdTokenModel.fromJson(Map map) {
    return EnvdTokenModel(
      createdAt:
          DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
      accessToken: map['access_token'] as String,
      expiresIn: map['expires_in'] as int,
      tokenType: map['token_type'] as String,
    );
  }

  bool isExpired() {
    final duration = DateTime.now().difference(createdAt).inSeconds;
    return duration > expiresIn;
  }
}
