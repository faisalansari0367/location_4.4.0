// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive_flutter/adapters.dart';
import 'package:rxdart/subjects.dart';

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
  Stream<User?> get userStream;
}

class StorageService implements UserStorage {
  final Box box;
  StorageService({
    required this.box,
  }) {
    // _userStream = BehaviorSubject<User?>.seeded(getUser());
    getUser();
    _listenForChanges();
  }

  // late final BehaviorSubject<User?> _controller;
  final _controller = BehaviorSubject<User?>.seeded(null);

  String get userKey => _Keys.user;

  @override
  User? getUser() {
    final map = box.get(_Keys.user);
    if (map == null) return null;
    final user = User.fromJson(Map<String, dynamic>.from(map));
    _controller.add(user);
    return user;
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

  void _listenForChanges() {
    box.watch(key: _Keys.user).map((event) {
      if (event.value == null) return null;
      return User.fromJson(Map<String, dynamic>.from(event.value));
    }).listen((event) {
      _controller.add(event);
    });
  }

  @override
  Stream<User?> get userStream => _controller.stream;
}
