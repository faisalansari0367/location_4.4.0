// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';

import 'package:api_repo/src/auth/src/storage/storage_service.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../api_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final Client client;
  final Box box;
  final StorageService storage;

  final Function(String userId) onUserChange;

  AuthRepoImpl({
    required this.onUserChange,
    required this.client,
    required this.box,
  }) : storage = StorageService(box: box) {
    client.token = storage.getToken();
  }

  /// to get data from the server for the first time
  ///
  @override
  bool isInit = false;

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

      final oldUser = getUser();
      if (oldUser?.id != model.data!.user!.id) {
        storage.box.deleteAll(storage.box.keys);
      }

      client.token = model.token!;

      // open the user's hive box
      final storageBox = StorageService(box: await Hive.openBox('storage'));
      final userStorage = StorageService(box: await Hive.openBox(model.data!.user!.email!));

      await Future.wait(
        [
          storageBox.setUserData(userData),
          storageBox.setToken(model.token!),
          storageBox.setUser(model.data!.user!.toJson()),
          storageBox.setIsLoggedIn(true),
          storageBox.setSignInData(data.toMap()),
        ],
      );

      await Future.wait(
        [
          userStorage.setUserData(userData),
          userStorage.setToken(model.token!),
          userStorage.setUser(model.data!.user!.toJson()),
          userStorage.setIsLoggedIn(true),
          userStorage.setSignInData(data.toMap()),
        ],
      );

      // onUserChange(model.data!.user!.email!);

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
  Future<ApiResult<User>> updateMe({required User user, bool isUpdate = true}) async {
    try {
      final result = await client.patch(Endpoints.updateMe, data: isUpdate ? user.updateUser() : {});
      final model = User.fromJson(result.data['data']);
      UserData userData = UserData.fromJson(result.data['data']);
      await Future.wait(
        [
          storage.setUserData(userData),
          storage.setUser(model.toJson()),
        ],
      );
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
      final result = await client.patch(
        '${Endpoints.users}/me',
        options: Options(headers: {"Content-Type": "application/json"}),
        data: json,
      );
      final model = User.fromJson((result.data));
      final _userData = UserData.fromJson(result.data['data']);
      await storage.setUserData(_userData);
      return ApiResult.success(data: model);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<User>> updateCvdForms({required List<String> base64pdfs}) async {
    try {
      // final json = userData.updateAllowedRoles();
      final result = await client.patch(
        '${Endpoints.users}/me',
        options: Options(headers: {"Content-Type": "application/json"}),
        data: {'cvdForms': base64pdfs},
      );
      final model = User.fromJson((result.data));
      final _userData = UserData.fromJson(result.data['data']);
      await storage.setUserData(_userData);
      return ApiResult.success(data: model);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

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

  @override
  User? getUser() => storage.getUser();

  @override
  Future<void> logout() async {
    isInit = false;
    await storage.setIsLoggedIn(false);
  }

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
  bool setIsInit(bool isInit) {
    this.isInit = isInit;
    return isInit;
  }

  @override
  Stream<bool> get isLoggedInStream => storage.isLoggedInStream;
}
