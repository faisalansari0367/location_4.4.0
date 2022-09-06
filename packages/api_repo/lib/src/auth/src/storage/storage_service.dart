// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive_flutter/adapters.dart';
import 'package:rxdart/subjects.dart';

import '../../../../api_repo.dart';

class _Keys {
  static const String user = 'user';
  static const String token = 'token';
  static const String userData = 'userData';
  static const String userRoles = 'userRoles';
}

abstract class UserStorage {
  User? getUser();
  Future<void> setUser(Map<String, dynamic> user);
  Future<void> removeUser();
  Future<void> removeToken();
  Future<void> setUserData(UserData userData);
  Future<void> setRoles(List<String> userData);
  List<String> getRoles();

  UserData? getUserData();
  Future<void> removeUserData();
  Future<void> setToken(String token);
  String? getToken();
  Stream<User?> get userStream;
  Stream<UserData?> get userDataStrem;
  Stream<List<String>?> get userRolesStream;
}

class StorageService implements UserStorage {
  final Box box;
  StorageService({
    required this.box,
  }) {
    // _userStream = BehaviorSubject<User?>.seeded(getUser());
    getUser();
    _userRoles.add(getRoles());
    _listenForChanges();
    _listenForUserRoleStream();
  }

  // late final BehaviorSubject<User?> _controller;
  final _controller = BehaviorSubject<User?>.seeded(null);
  final _userRoles = BehaviorSubject<List<String>>.seeded([]);

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
    }).listen((event) => _controller.add(event));
  }

  void _listenForUserRoleStream() {
    box.watch(key: _Keys.userRoles).map((event) {
      if (event.value == null) return null;
      // return List<String>.from(event.value);
      // return event.value;
      _userRoles.add(event.value);
    });
  }

  @override
  Stream<User?> get userStream => _controller.stream;

  @override
  Future<void> setUserData(UserData userData) async {
    await box.put(_Keys.userData, userData.toJson());
  }

  @override
  UserData? getUserData() {
    final data = box.get(_Keys.userData);
    if (data == null) return null;
    return UserData.fromJson(Map<String, dynamic>.from(box.get(_Keys.userData)));
  }

  @override
  Future<void> removeUserData() async {
    await box.delete(_Keys.userData);
  }

  @override
  Stream<UserData?> get userDataStrem => box.watch(key: _Keys.userData).map((event) {
        if (event.value == null) return null;
        return UserData.fromJson(Map<String, dynamic>.from(event.value));
      });

  @override
  Stream<List<String>?> get userRolesStream {
    // getRoles();
    // return box.watch(key: _Keys.userRoles).map((event) {
    //   if (event.value == null) return null;
    //   // return List<String>.from(event.value);
    //   return event.value;
    // });
    return _userRoles.stream;
  }

  @override
  List<String> getRoles() {
    final data = box.get(_Keys.userData);
    if (data == null) return [];
    return List<String>.from(box.get(_Keys.userRoles));
  }

  @override
  Future<void> setRoles(List<String> userRoles) async {
    await box.put(_Keys.userRoles, userRoles);
  }
}
