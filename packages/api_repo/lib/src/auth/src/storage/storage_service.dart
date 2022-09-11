// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hive_flutter/adapters.dart';
import 'package:rxdart/subjects.dart';

import '../../../../api_repo.dart';

class _Keys {
  static const String user = 'user';
  static const String token = 'token';
  static const String userData = 'userData';
  static const String userRoles = 'userRoles';
  static const String signInModel = 'signInModel';
  static const String isLoggedIn = 'isLoggedIn';
  static const String roleFields = 'roleFields';
  static const String roleData = 'roleData';
  static const String userSpecies = 'userSpecies';
}

abstract class UserStorage {
  User? getUser();
  Future<void> setUser(Map<String, dynamic> user);
  Future<void> removeUser();
  Future<void> removeToken();
  Future<void> setIsLoggedIn(bool value);

  Future<void> setUserData(UserData userData);
  Future<void> setRoles(List<UserRoles> userData);
  List<UserRoles> getRoles();

  UserData? getUserData();
  Map<String, dynamic>? getRoleData(String role);
  Future<void> setRoleData(String role, Map<String, dynamic> data);

  Future<void> removeUserData();
  Future<void> setToken(String token);
  String? getToken();

  bool get isLoggedIn;

  Stream<User?> get userStream;
  Stream<UserData?> get userDataStrem;
  Stream<List<UserRoles>> get userRolesStream;

  // set signInData
  Future<void> setSignInData(Map<String, dynamic> data);
  SignInModel? getSignInData();

  // get fields
  RoleDetailsModel? getRoleFiels(String role);
  Future<void>? setRoleFields(String role, Map<String, dynamic> data);

  // get user species
  UserSpecies? getUserSpecies();
  Future<void>? setUserSpecies(UserSpecies species);
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
  final _userRoles = BehaviorSubject<List<UserRoles>>.seeded([]);

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
  Stream<List<UserRoles>> get userRolesStream => _userRoles.stream;

  @override
  List<UserRoles> getRoles() {
    final data = box.get(_Keys.userRoles);
    if (data == null) return [];
    if (data is List<String>) return [];
    final json = jsonDecode(data) as List;
    return json.map((e) => UserRoles.fromMap(jsonDecode(e))).toList();
  }

  @override
  Future<void> setRoles(List<UserRoles> userRoles) async {
    await box.put(_Keys.userRoles, jsonEncode(userRoles));
  }

  @override
  SignInModel? getSignInData() {
    final data = box.get(_Keys.signInModel);
    if (data == null) return null;
    return SignInModel.fromMap(Map<String, dynamic>.from(data));
  }

  @override
  Future<void> setSignInData(Map<String, dynamic> data) {
    return box.put(_Keys.signInModel, data);
  }

  @override
  bool get isLoggedIn => box.get(_Keys.isLoggedIn) ?? false;

  @override
  Future<void> setIsLoggedIn(bool value) async {
    await box.put(_Keys.isLoggedIn, value);
  }

  @override
  RoleDetailsModel? getRoleFiels(String role) {
    final data = box.get(role);
    if (data == null) return null;
    return RoleDetailsModel.fromMap(Map<String, dynamic>.from(data['fields']));
  }

  @override
  Future<void> setRoleFields(String role, Map<String, dynamic> data) async {
    final boxData = box.get(role);
    final dataFields = boxData != null && (boxData as Map).containsKey('data') ? boxData['data'] : null;
    await box.put(role, {'data': dataFields, 'fields': data});
  }

  @override
  Map<String, dynamic>? getRoleData(String role) {
    final data = box.get(role);
    if (data == null) return <String, dynamic>{};
    
    return _fromMap(data['data']);
  }

  Map<String, dynamic> _fromMap(data) {
    return Map<String, dynamic>.from(data);
  }

  @override
  Future<void> setRoleData(String role, Map<String, dynamic> data) async {
    final boxData = box.get(role);
    final dataFields = boxData != null && (boxData as Map).containsKey('fields') ? boxData['fields'] : null;
    await box.put(role, {'data': data, 'fields': dataFields});
  }

  @override
  UserSpecies? getUserSpecies() {
    final data = box.get(_Keys.userSpecies);
    if (data == null) return null;
    return UserSpecies.fromJson(_fromMap(data));
  }

  @override
  Future<void>? setUserSpecies(UserSpecies species) async {
    await box.put(_Keys.userSpecies, species.toJson());
  }
}
