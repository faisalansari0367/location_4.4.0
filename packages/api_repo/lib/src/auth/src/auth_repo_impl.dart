// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';

import 'package:api_repo/api_result/api_result.dart';
import 'package:api_repo/api_result/network_exceptions/network_exceptions.dart';
import 'package:api_repo/configs/client.dart';
import 'package:api_repo/configs/endpoint.dart';
import 'package:api_repo/src/auth/src/storage/storage_service.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../api_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final Client client;
  final Box box;
  final StorageService storage;

  AuthRepoImpl({
    required this.client,
    required this.box,
  }) : storage = StorageService(box: box) {
    client.token = storage.getToken();
  }

  // final userController = StreamController();

  @override
  Future<ApiResult<ResponseModel>> signUp({required SignUpModel data}) async {
    try {
      final result = await client.post(Endpoints.signUp, data: data.toJson());
      final model = ResponseModel.fromMap((result.data));
      return ApiResult.success(data: model);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<User>> signIn({required SignInModel data}) async {
    try {
      final result = await client.post(Endpoints.signIn, data: data.toMap());
      final model = UserResponse.fromJson((result.data));
      final userData = UserData.fromJson(result.data['data']['user']);
      await setUserData(userData);
      // if (model.data!.user!.role!.getRole.isAdmin) {
      //   await updateUser(userData: UserData(role: model.data!.user!.role!, id: model.data!.user!.id));
      // } else {
      //   await updateMe(user: model.data!.user!);
      // }
      Future.wait([
        storage.setToken(model.token!),
        storage.setUser(model.data!.user!.toJson()),
        storage.setIsLoggedIn(true),
        storage.setSignInData(data.toMap()),
      ]);
      return ApiResult.success(data: model.data!.user!);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<User>> verifyOtp({required OtpModel otpModel}) async {
    try {
      final result = await client.post(Endpoints.verifyOtp, data: otpModel.toMap());
      final model = UserResponse.fromJson((result.data));
      storage.setToken(model.token!);
      storage.setUser(model.data!.user!.toJson());
      return ApiResult.success(data: model.data!.user!);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<User>> updateMe({required User user}) async {
    try {
      final result = await client.patch(Endpoints.updateMe, data: user.updateUser());
      final model = User.fromJson((result.data));
      final userData = UserData.fromJson(result.data['data']);
      await Future.wait([
        storage.setUserData(userData),
        storage.setUser(user.toJson()),
      ]);
      // storage.setUserData(userData);
      // storage.setUser(user.toJson());
      return ApiResult.success(data: model);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<ResponseModel>> forgotPassword({required String email}) async {
    try {
      final result = await client.post(Endpoints.forgotPassword, data: {"email": email.toLowerCase().trim()});
      final model = ResponseModel.fromMap((result.data));
      return ApiResult.success(data: model);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<ResponseModel>> resetPassword({required OtpModel model}) async {
    try {
      final result = await client.post(Endpoints.resetPassword, data: model.toMap());
      final data = ResponseModel.fromMap(result.data);
      return ApiResult.success(data: data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<User>> updateUser({required UserData userData}) async {
    try {
      final json = userData.updateAllowedRoles();
      final result = await client.patch('${Endpoints.users}/me', data: json);

      // final result = await client.patch('${Endpoints.users}/me/${userData.id}', data: json);
      final model = User.fromJson((result.data));
      final _userData = UserData.fromJson(result.data['data']);
      await storage.setUserData(_userData);
      return ApiResult.success(data: model);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  void _checkAndRemoveKey(Map<String, dynamic> json, String key) {
    if (json[key] == null) {
      json.remove(key);
    }
  }

  @override
  User? getUser() => storage.getUser();

  @override
  Future<void> logout() async => await storage.setIsLoggedIn(false);

  @override
  String? getToken() => storage.getToken();

  @override
  Stream<User?> get userStream => storage.userStream;

  @override
  UserData? getUserData() => storage.getUserData();

  @override
  Stream<UserData?> get userDataStream => storage.userDataStrem;

  @override
  Stream<List<UserRoles>?> get userRolesStream => storage.userRolesStream;

  @override
  bool get isLoggedIn => storage.isLoggedIn;

  @override
  Future<void> setUserData(UserData userData) async => await storage.setUserData(userData);

  @override
  Future<ApiResult<User>> updateStatus({required UserData userData}) async {
    try {
      final result = await client.patch('${Endpoints.users}/${userData.id}', data: userData.updateStatus());
      final model = User.fromJson((result.data));
      final _userData = UserData.fromJson(result.data['data']);
      await storage.setUserData(_userData);
      return ApiResult.success(data: model);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
