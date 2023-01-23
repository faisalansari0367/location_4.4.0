import 'dart:io';

import 'package:api_repo/api_repo.dart';
import 'package:api_repo/src/auth/src/storage/storage_service.dart';
import 'package:api_repo/src/log/src/local_log_records_impl.dart';
import 'package:cvd_forms/cvd_forms.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class LocalApi extends Api {
  late StorageService storage;
  late LocalLogRecordsImpl _logRecordsImpl;
  late GeofencesRepo _geofencesRepoLocalImpl;
  late CvdFormsRepo _cvdFormsRepo;
  late Directory _cacheDir;

  @override
  Future<void> init({required String baseUrl, required Box box}) async {
    _logRecordsImpl = LocalLogRecordsImpl(box: box);
    _cacheDir = await _getUserCacheDir(box);
    _cvdFormsRepo = CvdFormsLocalImpl(_cacheDir, box: box);
    storage = StorageService(box: box);
    _geofencesRepoLocalImpl = GeofencesRepoLocalImpl(box: box);
  }

  Future<Directory> _getUserCacheDir(Box box) async {
    final storage = StorageService(box: box);
    final cacheDir = await getApplicationDocumentsDirectory();
    final email = storage.getUser()?.email ?? '';
    _cacheDir = Directory('${cacheDir.path}/$email');
    return _cacheDir;
  }

  @override
  Client get client => throw UnimplementedError();

  @override
  Future<ApiResult<ResponseModel>> forgotPassword({required String email}) {
    throw UnimplementedError();
  }

  Stream<List<LogbookEntry>> get offlineRecordsToSync =>
      _logRecordsImpl.logRecordsToSync;

  @override
  Future<ApiResult<RoleDetailsModel>> getFields(String role) async {
    try {
      final data = storage.getRoleFiels(role)!;
      return ApiResult.success(data: data);
    } catch (e) {
      return const ApiResult.failure(
          error: NetworkExceptions.defaultError('Data not found'));
    }
  }

  @override
  Future<ApiResult<List<String>>> getFormQuestions() {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<LogbookResponseModel>> getLogbookRecords(
      {int page = 1, int limit = 100}) {
    return _logRecordsImpl.getLogbookRecords(page: page, limit: limit);
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getRoleData(String role) async {
    try {
      var data = <String, dynamic>{};
      data = storage.getRoleData(role)!;
      if (data.isEmpty) data = storage.getUserData()?.toJson() ?? {};
      return ApiResult.success(
          data: data.containsKey('data') ? data : {'data': data});
    } catch (e) {
      return const ApiResult.failure(
          error: NetworkExceptions.defaultError('Data not found'));
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
    return storage.getUserData();
  }

  @override
  Future<ApiResult<UserFormsData>> getUserForms() async {
    final data = storage.getUserForms();
    if (data != null) {
      return ApiResult.success(data: data);
    } else {
      return const ApiResult.failure(
          error: NetworkExceptions.defaultError('Not found'));
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
      return const ApiResult.failure(
          error: NetworkExceptions.defaultError('Species Data not found'));
    }
  }

  ApiResult _dataNotFound() => const ApiResult.failure(
      error: NetworkExceptions.defaultError('Data not found'));

  @override
  Future<ApiResult<UsersResponseModel>> getUsers(
      {Map<String, dynamic>? queryParams}) {
    throw UnimplementedError();
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
      // final box = await Hive.openBox(data.email.trim());
      // await init(baseUrl: '', box: box);
      // final hive = await Hive.openBox('storage');
      // final storage = StorageService(box: hive);
      final savedModel = storage.getSignInData();
      if (savedModel != data) {
        return const ApiResult.failure(
          error: NetworkExceptions.defaultError(
            'You are in offline mode only the last user can login',
          ),
        );
      }
      final user = storage.getUser();
      if (user != null) {
        storage.setIsLoggedIn(true);
        return ApiResult.success(data: user);
      } else {
        return const ApiResult.failure(
          error: NetworkExceptions.defaultError('User not found'),
        );
      }
    } catch (e) {
      return const ApiResult.failure(
        error: NetworkExceptions.defaultError('User not found'),
      );
    }
  }

  @override
  Future<ApiResult<ResponseModel>> signUp({required SignUpModel data}) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<void>> updateRole(
      String role, Map<String, dynamic> data) async {
    // storage.setRoleData(data);
    return const ApiResult.success(data: Null);
  }

  @override
  Future<ApiResult<User>> updateMe(
      {required User user, bool isUpdate = true}) async {
    // final userData = storage.getUserData();
    return ApiResult.success(data: user);
  }

  @override
  Stream<UserData?> get userDataStream => storage.userDataStrem;

  @override
  Stream<List<UserRoles>?> get userRolesStream => storage.userRolesStream;

  @override
  Stream<User?> get userStream => throw UnimplementedError();

  @override
  Future<ApiResult<User>> verifyOtp({required OtpModel otpModel}) {
    throw UnimplementedError();
  }

  @override
  bool get isLoggedIn => storage.isLoggedIn;

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
  Future<ApiResult<LogbookEntry>> createLogRecord(String geofenceId,
      {LogbookFormModel? form}) async {
    return _logRecordsImpl.createLogRecord(geofenceId, form: form);
  }

  @override
  Stream<List<LogbookEntry>> get logbookRecordsStream =>
      _logRecordsImpl.logbookRecordsStream;

  @override
  Future<ApiResult<LogbookEntry>> udpateForm(
      String geofenceId, Map<String, dynamic> form,
      {int? logId}) {
    return _logRecordsImpl.udpateForm(geofenceId, form, logId: logId);
  }

  @override
  Future<ApiResult<LogbookEntry>> logBookEntry(String geofenceId,
      {bool isExiting = false, LogbookFormModel? form}) {
    return _logRecordsImpl.logBookEntry(geofenceId,
        isExiting: isExiting, form: form);
  }

  @override
  Future<ApiResult<LogbookEntry>> markExit(String geofenceId) {
    return _logRecordsImpl.markExit(geofenceId);
  }

  @override
  Future<ApiResult<User>> updateStatus({required UserData userData}) {
    // TODO: implement updateStatus
    throw UnimplementedError();
  }

  @override
  Future<LogbookEntry?> getLogRecord(String geofenceId) {
    return _logRecordsImpl.getLogRecord(geofenceId);
  }

  @override
  Future<ApiResult<RoleDetailsModel>> getRoles() {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<List<UserData>>> sendEmergencyNotification(
      {required List<int> ids}) async {
    return const ApiResult.failure(
        error: NetworkExceptions.defaultError('Not available in offline mode'));
  }

  @override
  Future<void> getEnvdToken() {
    // TODO: implement getEnvdToken
    throw UnimplementedError();
  }

  @override
  List<LogbookEntry> get logbookRecords => [];

  @override
  // TODO: implement getEnvdToken
  bool get isInit => true;

  @override
  // TODO: implement getEnvdToken
  bool setIsInit(bool isInit) {
    // isInit = isInit;
    return isInit;
  }

  @override
  Future<Uint8List> downloadPdf(String url,
      {void Function(int, int)? onReceiveProgress}) {
    // TODO: implement downloadPdf
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<LogbookEntry>> markExitById(String logRecordId) {
    // TODO: implement markExitById
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<NotificationResponseModel>> getSentNotifications() {
    // TODO: implement getSentNotifications
    throw UnimplementedError();
  }

  @override
  Future<ApiResult> sendSos(double lat, double lng) {
    // TODO: implement sendSos
    throw UnimplementedError();
  }

  @override
  Stream<bool> get isLoggedInStream => storage.isLoggedInStream;

  @override
  Future<ApiResult<String>> deleteUser() async {
    return const ApiResult.failure(
        error: NetworkExceptions.defaultError('Not available in offline mode'));
  }

  @override
  Future<ApiResult<String>> deleteUserById({required int userId}) {
    throw UnimplementedError();
  }

  @override
  Future<bool> synchronizeLogRecords() {
    return _logRecordsImpl.synchronizeLogRecords();
  }

  @override
  Future<ApiResult<CvdForm>> addCvdForm(CvdForm cvdForm) {
    return _cvdFormsRepo.addCvdForm(cvdForm);
  }

  @override
  CvdForm? getCurrentForm() {
    return _cvdFormsRepo.getCurrentForm();
  }

  @override
  Future<ApiResult<List<CvdModel>>> getCvdUrls() {
    return _cvdFormsRepo.getCvdUrls();
  }

  @override
  Future<ApiResult<File>> submitCvdForm(CvdForm cvdForm,
      {ProgressCallback? onReceiveProgress}) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<CvdForm>> updateCvdForm(CvdForm cvdForm) {
    return _cvdFormsRepo.updateCvdForm(cvdForm);
  }

  @override
  Future<bool> deleteForm(CvdForm cvdForm) {
    return _cvdFormsRepo.deleteForm(cvdForm);
  }

  @override
  Future<ApiResult<User>> updateCvdForms({required List<String> base64pdfs}) {
    const api = NetworkExceptions.defaultError('Not available in offline mode');
    return Future.value(const ApiResult.failure(error: api));
  }

  @override
  Future<ApiResult<List<WitholdingPeriodModel>>> getWitholdingPeriodsList() {
    return _cvdFormsRepo.getWitholdingPeriodsList();
  }

  @override
  void cancel() {
    _geofencesRepoLocalImpl.cancel();
  }

  @override
  Future<ApiResult> deletePolygon(PolygonModel model) {
    return _geofencesRepoLocalImpl.deletePolygon(model);
  }

  @override
  Future<ApiResult<List<PolygonModel>>> getAllPolygon() {
    return _geofencesRepoLocalImpl.getAllPolygon();
  }

  @override
  Future<ApiResult<String>> notifyManager(
      String lat, String lng, String locationId) {
    return _geofencesRepoLocalImpl.notifyManager(lat, lng, locationId);
  }

  @override
  Stream<List<PolygonModel>> get polygonStream =>
      _geofencesRepoLocalImpl.polygonStream;

  @override
  Future<List<PolygonModel>> get polygonsCompleter =>
      _geofencesRepoLocalImpl.polygonsCompleter;

  @override
  Future<void> saveAllPolygon(List<PolygonModel> polygons) {
    return _geofencesRepoLocalImpl.saveAllPolygon(polygons);
  }

  @override
  Future<ApiResult<void>> savePolygon(PolygonModel model) {
    return _geofencesRepoLocalImpl.savePolygon(model);
  }

  @override
  Future<ApiResult> updatePolygon(PolygonModel model) {
    return _geofencesRepoLocalImpl.updatePolygon(model);
  }

  @override
  bool get hasPolygons => _geofencesRepoLocalImpl.hasPolygons;

  @override
  Future<void> previousZoneExitDateChecker() {
    return _logRecordsImpl.previousZoneExitDateChecker();
  }

  @override
  List<PolygonModel> get polygons => _geofencesRepoLocalImpl.polygons;

  @override
  Future<ApiResult<UserData>> temporaryOwner(TemporaryOwnerParams params) {
    return _geofencesRepoLocalImpl.temporaryOwner(params);
  }

  @override
  Future<ApiResult<bool>> removeTemporaryOwner(TemporaryOwnerParams params) {
    return _geofencesRepoLocalImpl.removeTemporaryOwner(params);
  }

  @override
  Future<ApiResult<String>> createStripeSession(
      String priceId, String paymentMode,  {String? governmentCode, String? role}) async {
    return const ApiResult.failure(
      error: NetworkExceptions.defaultError('Not available in offline mode'),
    );
  }

  @override
  List<CvdForm> get cvdForms => _cvdFormsRepo.cvdForms;

  @override
  Stream<List<CvdForm>> get cvdFormsStream => _cvdFormsRepo.cvdFormsStream;

  @override
  Future<ApiResult<bool>> uploadCvdForm(CvdForm file, String? pic,
      {ProgressCallback? onReceiveProgress,
      ProgressCallback? onSendProgress}) async {
    return const ApiResult.failure(
      error: NetworkExceptions.defaultError('Not available in offline mode'),
    );
  }

  @override
  Future<ApiResult<PlanDetailsModel>> getPlanDetails() async {
    return const ApiResult.failure(
      error: NetworkExceptions.defaultError('Not available in offline mode'),
    );
  }

  @override
  Future<ApiResult<File>> saveOnlineCvd(CvdModel cvd,
      {ProgressCallback? onReceiveProgress}) async {
    return _notAvailable();
  }

  ApiResult<File> _notAvailable() {
    return const ApiResult.failure(
      error: NetworkExceptions.defaultError('Not available in offline mode'),
    );
  }

  @override
  Future<Directory> getCvdDownloadsDir() {
    return _cvdFormsRepo.getCvdDownloadsDir();
  }

  @override
  Future<ApiResult<List<SosNotification>>> getSosNotification() {
    // return .getSosNotification();
    throw _notAvailable();
  }
}
