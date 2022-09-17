import 'package:api_repo/api_repo.dart';
import 'package:api_repo/api_result/api_result.dart';
import 'package:api_repo/api_result/network_exceptions/network_exceptions.dart';
import 'package:api_repo/configs/client.dart';
import 'package:api_repo/src/auth/src/storage/storage_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalApi extends Api {
  late StorageService storage;
  @override
  Client get client => throw UnimplementedError();

  @override
  Future<ApiResult<ResponseModel>> forgotPassword({required String email}) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<RoleDetailsModel>> getFields(String role) async {
    try {
      final data = storage.getRoleFiels(role)!;
      return ApiResult.success(data: data);
    } catch (e) {
      return const ApiResult.failure(error: NetworkExceptions.defaultError('Data not found'));
    }
  }

  @override
  Future<ApiResult<List<String>>> getFormQuestions() {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<LogbookEntryModel>> getLogbookRecords() {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getRoleData(String role) async {
    try {
      var data = <String, dynamic>{};
      data = storage.getRoleData(role)!;
      if (data.isEmpty) data = storage.getUserData()?.toJson() ?? {};
      return ApiResult.success(data: data.containsKey('data') ? data : {'data': data});
    } catch (e) {
      return const ApiResult.failure(error: NetworkExceptions.defaultError('Data not found'));
    }
  }

  @override
  String? getToken() {
    throw UnimplementedError();
  }

  @override
  User? getUser() {
    return storage.getUser();
  }

  @override
  UserData? getUserData() {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<UserFormsData>> getUserForms() {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<List<UserRoles>>> getUserRoles() async {
    final roles = storage.getRoles();
    return ApiResult.success(data: roles);
  }

  @override
  Future<ApiResult<UserSpecies>> getUserSpecies() async {
    try {
      return ApiResult.success(data: storage.getUserSpecies()!);
    } catch (e) {
      return const ApiResult.failure(error: NetworkExceptions.defaultError('Species Data not found'));
    }
  }

  ApiResult _dataNotFound() {
    return const ApiResult.failure(error: NetworkExceptions.defaultError('Data not found'));
  }

  @override
  Future<ApiResult<UsersResponseModel>> getUsers({Map<String, dynamic>? queryParams}) {
    throw UnimplementedError();
  }

  @override
  Future<void> init({required String baseUrl, required Box box}) async {
    storage = StorageService(box: box);
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<ResponseModel>> resetPassword({required OtpModel model}) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<User>> signIn({required SignInModel data}) async {
    try {
      final savedModel = storage.getSignInData();
      if (savedModel != data) return const ApiResult.failure(error: NetworkExceptions.defaultError('User not found'));
      final user = storage.getUser();
      if (user != null) {
        storage.setIsLoggedIn(true);
        return ApiResult.success(data: user);
      } else {
        return const ApiResult.failure(error: NetworkExceptions.defaultError('User not found'));
      }
    } catch (e) {
      return const ApiResult.failure(error: NetworkExceptions.defaultError('User not found'));
    }
  }

  @override
  Future<ApiResult<ResponseModel>> signUp({required SignUpModel data}) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<void>> updateRole(String role, Map<String, dynamic> data) async {
    // storage.setRoleData(data);
    return const ApiResult.success(data: Null);
  }

  @override
  Future<ApiResult<User>> updateUser({required User user}) async {
    // final userData = storage.getUserData();
    return ApiResult.success(data: user);
  }

  @override
  Stream<UserData?> get userDataStream => throw UnimplementedError();

  @override
  Stream<List<UserRoles>?> get userRolesStream => storage.userRolesStream;

  @override
  Stream<User?> get userStream => throw UnimplementedError();

  @override
  Future<ApiResult<User>> verifyOtp({required OtpModel otpModel}) {
    throw UnimplementedError();
  }

  @override
  // TODO: implement isLoggedIn
  bool get isLoggedIn => throw UnimplementedError();

  @override
  Future<ApiResult<List<String>>> getLicenceCategories() {
    // TODO: implement getLicenceCategories
    throw UnimplementedError();
  }

  @override
  Future<void> getCvdPDf(Map<String, dynamic> data) {
    // TODO: implement getCvdPDf
    throw UnimplementedError();
  }
}
