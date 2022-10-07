import 'package:api_repo/configs/client.dart';
import 'package:hive_flutter/adapters.dart';

import '../../api_repo.dart';
import '../../api_result/api_result.dart';
import '../auth/src/storage/storage_service.dart';
import '../log/log_records.dart';

class ApiRepo implements Api {
  late Client _client;
  late AuthRepo _authRepo;
  late UserRepo _userRepo;
  late LogRecordsRepo _logRecordsRepo;

  late Box _box;
  // late LocalesApi _localesApi;

  ApiRepo();

  @override
  Future<void> init({required String baseUrl, required Box box}) async {
    await Hive.initFlutter();
    _box = await Hive.openBox('storage');
    final storage = StorageService(box: _box);
    final token = storage.getToken();
    _client = Client(baseUrl: baseUrl, token: token);
    _userStream(_box, storage.userKey);
    _logRecordsRepo = LogRecordsImpl(client: _client, box: _box);
    _authRepo = AuthRepoImpl(client: _client, box: _box);
    _userRepo = UserRepoImpl(client: _client, box: _box);
    // _localesApi = LocalesRepo();
    // await _localesApi.initLocale();
  }

  void _userStream(Box box, String key) {
    box.watch(key: key).listen((event) {
      final storage = StorageService(box: _box);
      _client.token = storage.getToken();
    });
  }

  @override
  Future<ApiResult<User>> signIn({required SignInModel data}) {
    return _authRepo.signIn(data: data);
  }

  @override
  Future<ApiResult<ResponseModel>> signUp({required SignUpModel data}) {
    return _authRepo.signUp(data: data);
  }

  @override
  Future<ApiResult<User>> verifyOtp({required OtpModel otpModel}) {
    return _authRepo.verifyOtp(otpModel: otpModel);
  }

  @override
  User? getUser() => _authRepo.getUser();

  @override
  Future<void> logout() => _authRepo.logout();

  @override
  Future<ApiResult<List<UserRoles>>> getUserRoles() async => await _userRepo.getUserRoles();

  @override
  Future<ApiResult<RoleDetailsModel>> getFields(String role) => _userRepo.getFields(role);

  @override
  Future<ApiResult<User>> updateMe({required User user}) async {
    return await _authRepo.updateMe(user: user);
  }

  // @override
  // void changeCountry({required String code, required String dial, required String name}) {
  //   return _localesApi.changeCountry(code: code, dial: dial, name: name);
  // }

  // @override
  // String? get countryCode => _localesApi.countryCode;

  // @override
  // String? get countryName => _localesApi.countryName;

  // @override
  // String? get dialCode => _localesApi.dialCode;

  // @override
  // Future<void> initLocale() {
  //   throw UnimplementedError();
  // }

  @override
  Future<ApiResult<ResponseModel>> forgotPassword({required String email}) {
    return _authRepo.forgotPassword(email: email);
  }

  @override
  Future<ApiResult<ResponseModel>> resetPassword({required OtpModel model}) {
    return _authRepo.resetPassword(model: model);
  }

  @override
  Future<ApiResult<void>> updateRole(String role, Map<String, dynamic> data) {
    return _userRepo.updateRole(role, data);
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getRoleData(String role) {
    return _userRepo.getRoleData(role);
  }

  @override
  String? getToken() {
    return _authRepo.getToken();
  }

  @override
  Stream<User?> get userStream => _authRepo.userStream;

  @override
  Client get client => _client;

  @override
  UserData? getUserData() => _authRepo.getUserData();

  @override
  Future<ApiResult<LogbookResponseModel>> getLogbookRecords() {
    return _logRecordsRepo.getLogbookRecords();
  }

  @override
  Future<ApiResult<UsersResponseModel>> getUsers({Map<String, dynamic>? queryParams}) {
    return _userRepo.getUsers(queryParams: queryParams);
  }

  @override
  Future<ApiResult<List<String>>> getFormQuestions() {
    return _userRepo.getFormQuestions();
  }

  @override
  Future<ApiResult<UserSpecies>> getUserSpecies() {
    return _userRepo.getUserSpecies();
  }

  @override
  Stream<UserData?> get userDataStream => _authRepo.userDataStream;

  @override
  Future<ApiResult<UserFormsData>> getUserForms() {
    return _userRepo.getUserForms();
  }

  @override
  Stream<List<UserRoles>?> get userRolesStream => _authRepo.userRolesStream;

  @override
  bool get isLoggedIn => _authRepo.isLoggedIn;

  @override
  Future<ApiResult<List<String>>> getLicenceCategories() {
    return _userRepo.getLicenceCategories();
  }

  @override
  Future<void> getCvdPDf(Map<String, dynamic> data) {
    return _userRepo.getCvdPDf(data);
  }

  @override
  Future<void> setUserData(UserData userData) async {
    _authRepo.setUserData(userData);
  }

  @override
  Future getQrCode(String data) {
    return _userRepo.getQrCode(data);
  }

  @override
  Future<ApiResult> openPdf(String url) {
    return _userRepo.openPdf(url);
  }

  @override
  Future<ApiResult<User>> updateUser({required UserData userData}) {
    return _authRepo.updateUser(userData: userData);
  }

  @override
  Future<ApiResult<LogbookEntry>> createLogRecord(String geofenceId, {String? form}) {
    return _logRecordsRepo.createLogRecord(geofenceId);
  }

  @override
  Stream<List<LogbookEntry>> get logbookRecordsStream => _logRecordsRepo.logbookRecordsStream;

  @override
  Future<ApiResult<LogbookEntry>> updateLogRecord(int logId, String geofenceId) {
    return _logRecordsRepo.updateLogRecord(logId, geofenceId);
  }

  @override
  Future<ApiResult<LogbookEntry>> udpateForm(String geofenceId, String form) {
    return _logRecordsRepo.udpateForm(geofenceId, form);
  }

  @override
  Future<ApiResult<LogbookEntry>> logBookEntry(String pic, String geofenceId, {bool isExiting = false, String? form}) {
    return _logRecordsRepo.logBookEntry(pic, geofenceId, isExiting: isExiting, form: form);
  }

  @override
  Future<ApiResult<LogbookEntry>> markExit(String geofenceId) {
    return _logRecordsRepo.markExit(geofenceId);
  }
}
