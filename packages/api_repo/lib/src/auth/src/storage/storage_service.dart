// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive_flutter/adapters.dart';

import '../../../../api_repo.dart';

class _Keys {
  static const String user = 'user';
  static const String token = 'token';
}

abstract class UserStorage {
  User? getUser();
  Future<void> setUser(Map<String, dynamic> user);
  Future<void> removeUser();
  Future<void> removeToken();

  Future<void> setToken(String token);
  String? getToken();
}

class StorageService implements UserStorage {
  final Box box;
  StorageService({
    required this.box,
  });

  String get userKey => _Keys.user;

  @override
  User? getUser() {
    final map = box.get(_Keys.user);
    if (map == null) return null;
    return User.fromJson(Map<String, dynamic>.from(map));
  }

  @override
  Future<void> removeUser() async {
    await box.delete(_Keys.user);
  }

  @override
  Future<void> setUser(Map<String, dynamic> user) async {
    await box.put(_Keys.user, user);
  }

  @override
  Future<void> setToken(String token) async {
    await box.put(_Keys.token, token);
  }

  @override
  String? getToken() {
    return box.get(_Keys.token);
  }

  @override
  Future<void> removeToken() async {
    await box.delete(_Keys.token);
  }
}
