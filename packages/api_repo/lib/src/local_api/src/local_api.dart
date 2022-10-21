import 'package:api_repo/api_repo.dart';
import 'package:api_repo/api_result/api_result.dart';
import 'package:api_repo/api_result/network_exceptions/network_exceptions.dart';
import 'package:api_repo/configs/client.dart';
import 'package:api_repo/src/auth/src/storage/storage_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalApi extends Api {
  late StorageService storage;
  // late LogRecordsLocalService _logRecordsLocalService;

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
  Future<ApiResult<LogbookResponseModel>> getLogbookRecords() {
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
  Future<ApiResult<UserFormsData>> getUserForms() async {
    final data = storage.getUserForms();
    if (data != null) {
      return ApiResult.success(data: data);
    } else {
      return const ApiResult.failure(error: NetworkExceptions.defaultError('Not found'));
    }
  }

  @override
  Future<ApiResult<List<UserRoles>>> getUserRoles() async {
    final roles = storage.getRoles();
    return ApiResult.success(data: roles);
  }

  @override
  Future<ApiResult<UserSpecies>> getUserSpecies() async {
    try {
      final species = storage.getUserSpecies();

      return ApiResult.success(data: species!);
    } catch (e) {
      return const ApiResult.failure(error: NetworkExceptions.defaultError('Species Data not found'));
    }
  }

  ApiResult _dataNotFound() => const ApiResult.failure(error: NetworkExceptions.defaultError('Data not found'));

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
  Future<ApiResult<User>> updateMe({required User user, bool isUpdate = true}) async {
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

  @override
  Future<void> setUserData(UserData userData) {
    // TODO: implement setUserData
    throw UnimplementedError();
  }

  @override
  Future getQrCode(String data) {
    // TODO: implement getQrCode
    throw UnimplementedError();
  }

  @override
  Future<ApiResult> openPdf(String url) {
    // TODO: implement openPdf
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<User>> updateUser({required UserData userData}) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<LogbookEntry>> createLogRecord(String geofenceId, {String? form}) {
    throw UnimplementedError();
  }

  @override
  Stream<List<LogbookEntry>> get logbookRecordsStream => throw UnimplementedError();

  @override
  Future<ApiResult<LogbookEntry>> updateLogRecord(int logId, String geofenceId) {
    // TODO: implement updateLogRecord
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<LogbookEntry>> udpateForm(String geofenceId, String form) {
    // TODO: implement udpateForm
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<LogbookEntry>> logBookEntry(String pic, String geofenceId, {bool isExiting = false, String? form}) {
    // TODO: implement logBookEntry
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<LogbookEntry>> markExit(String geofenceId) {
    // TODO: implement markExit
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<User>> updateStatus({required UserData userData}) {
    // TODO: implement updateStatus
    throw UnimplementedError();
  }

  @override
  LogbookEntry? getLogRecord(String geofenceId) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<RoleDetailsModel>> getRoles() {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<List<UserData>>> sendEmergencyNotification({required List<int> ids}) async {
    return const ApiResult.failure(error: NetworkExceptions.defaultError('Not available in offline mode'));
  }
}
