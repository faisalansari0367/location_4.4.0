import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:api_repo/src/envd/envd_repo.dart';
import 'package:cvd_forms/cvd_forms.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

import '../../api_repo.dart';
import '../auth/src/storage/storage_service.dart';

// import '../log/log_records.dart';

export '../functions/models/notifications_model.dart';

class ApiRepo implements Api {
  late Client _client;
  late AuthRepo _authRepo;
  late UserRepo _userRepo;
  late LogRecordsRepo _logRecordsRepo;
  late FunctionsRepo _functionsRepo;
  late CvdFormsRepo _cvdFormsRepo;
  late GeofencesRepo _geofencesRepo;
  late PaymentRepo _paymentRepo;
  late PicRepo _picRepo;
  late EnvdRepo _envdRepo;
  late Directory _cacheDir;

  // final BehaviorSubject<Box> _userBoxController = BehaviorSubject<Box>();

  Future<void> Function({required String baseUrl, required Box<dynamic> box})
      localApiinit;

  late Box _box;
  // late LocalesApi _localesApi;

  ApiRepo({required this.localApiinit});

  StreamSubscription<BoxEvent>? _onUserChange;

  @override
  Future<void> init({
    required String baseUrl,
    required Box box,
    // required ValueChanged<Box> onBoxChange,
  }) async {
    final userBox = await _getBox(box);
    await _initRepos(baseUrl, userBox);
  }

  Future<void> _initRepos(String baseUrl, Box box) async {
    _box = box;
    final storage = StorageService(box: box);
    final token = storage.getToken();
    _client = Client(baseUrl: baseUrl, token: token, onError: _onError);
    localApiinit(baseUrl: baseUrl, box: box);
    _logRecordsRepo = LogRecordsImpl(client: _client, box: box);
    _authRepo =
        AuthRepoImpl(client: _client, box: box, onUserChange: changeUserBox);
    _userRepo = UserRepoImpl(client: _client, box: box);
    _functionsRepo = FunctionsRepoImpl(client: _client);

    _cacheDir = await _getUserCacheDir();
    _cvdFormsRepo =
        CvdFormsRepoImpl(box: box, client: _client, cacheDir: _cacheDir);
    _geofencesRepo = GeofencesRepoImpl(client: client, box: box);
    _paymentRepo = PaymentRepoImpl(client: client);
    _picRepo = PicRepoImpl(client: client);
    _envdRepo = EnvdRepoImpl(client: client, box: box);

    _userStream(_box, storage.userKey);
  }

  Future<Directory> _getUserCacheDir() async {
    final storage = StorageService(box: _box);
    final cacheDir = await getApplicationDocumentsDirectory();
    final email = storage.getUser()?.email ?? '';
    _cacheDir = Directory('${cacheDir.path}/$email');
    return _cacheDir;
  }

  Future<Box> _getBox(Box oldBox) async {
    final storage = StorageService(box: oldBox);
    late Box finalBox = oldBox;
    if (storage.isLoggedIn) {
      final userBox = await Hive.openBox(storage.getUser()!.email!);
      log('userbox name is ${userBox.name}}');
      if (userBox.isNotEmpty) {
        finalBox = userBox;
      }
    }
    return finalBox;
  }

  // void _changeUserBox(Box box) {
  //   _userBoxController.add(box);
  // }

  // void _listenToBoxChanges() {
  //   _userBoxController.listen((value) {
  //     _initRepos(_client.baseUrl, value);
  //     // log('box changed');
  //   });
  // }

  Future<void> changeUserBox(String email) async {
    try {
      _box = await Hive.openBox(email.trim());
      // _authRepo.signIn(data: data);
      _initRepos(_client.baseUrl, _box);
    } catch (e) {
      log('error while opening box for user $email');
    }
  }

  void _userStream(Box box, String key) {
    _onUserChange?.cancel();
    _onUserChange = box.watch(key: key).listen((event) {
      log(event.deleted.toString());
      final storage = StorageService(box: _box);
      final token = storage.getToken();
      if (token != null) {
        _client.token = token;
      }
      log('updating the token ${_client.token}');
    });
  }

  @override
  Future<ApiResult<User>> signIn({required SignInModel data}) async {
    final result = await _authRepo.signIn(data: data);
    result.when(
        success: (s) async {
          // change user box and update all repos
          await changeUserBox(s.email!);
          // the box is already opened in the changeUserBox method
          // now we need to update the user in the box
          // await _authRepo.signIn(data: data);
        },
        failure: (s) {});
    return result;
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
  Future<ApiResult<List<UserRoles>>> getUserRoles() async =>
      await _userRepo.getUserRoles();

  @override
  Future<ApiResult<RoleDetailsModel>> getFields(String role) =>
      _userRepo.getFields(role);

  @override
  Future<ApiResult<User>> updateMe(
      {required User user, bool isUpdate = true}) async {
    return await _authRepo.updateMe(user: user, isUpdate: isUpdate);
  }

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
  Future<ApiResult<LogbookResponseModel>> getLogbookRecords(
      {int page = 1, int limit = 20}) {
    return _logRecordsRepo.getLogbookRecords(page: page, limit: limit);
  }

  @override
  Future<ApiResult<UsersResponseModel>> getUsers(
      {Map<String, dynamic>? queryParams}) {
    return _userRepo.getUsers(queryParams: queryParams);
  }

  @override
  Future<ApiResult<List<DeclarationForms>>> getDeclarationForms() {
    return _userRepo.getDeclarationForms();
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
  Future<ApiResult<User>> updateAllowedRoles(
      {required List<String> allowedRoles}) {
    return _authRepo.updateAllowedRoles(allowedRoles: allowedRoles);
  }

  @override
  Future<ApiResult<LogbookEntry>> createLogRecord(String geofenceId,
      {LogbookFormModel? form}) {
    return _logRecordsRepo.createLogRecord(geofenceId);
  }

  @override
  Stream<List<LogbookEntry>> get logbookRecordsStream =>
      _logRecordsRepo.logbookRecordsStream;

  // @override
  // Future<ApiResult<LogbookEntry>> updateLogRecord(int logId, String geofenceId) {
  //   return _logRecordsRepo.updateLogRecord(logId, geofenceId);
  // }

  @override
  Future<ApiResult<LogbookEntry>> udpateForm(
      String geofenceId, Map<String, dynamic> form,
      {int? logId}) {
    return _logRecordsRepo.udpateForm(geofenceId, form, logId: logId);
  }

  @override
  Future<ApiResult<LogbookEntry>> logBookEntry(String geofenceId,
      {bool isExiting = false, LogbookFormModel? form}) {
    return _logRecordsRepo.logBookEntry(
      geofenceId,
      isExiting: isExiting,
      form: form,
    );
  }

  @override
  Future<ApiResult<LogbookEntry>> markExit(String geofenceId) {
    return _logRecordsRepo.markExit(geofenceId);
  }

  @override
  Future<ApiResult<User>> updateStatus({required UserData userData}) {
    return _authRepo.updateStatus(userData: userData);
  }

  @override
  Future<LogbookEntry?> getLogRecord(String geofenceId) {
    return _logRecordsRepo.getLogRecord(geofenceId);
  }

  @override
  Future<ApiResult<RoleDetailsModel>> getRoles() {
    return _userRepo.getRoles();
  }

  @override
  Future<ApiResult<List<UserData>>> sendEmergencyNotification(
      {required List<int> ids}) async {
    return _functionsRepo.sendEmergencyNotification(ids: ids);
  }

  @override
  List<LogbookEntry> get logbookRecords => _logRecordsRepo.logbookRecords;

  @override
  bool get isInit => _authRepo.isInit;

  @override
  bool setIsInit(bool isInit) {
    return _authRepo.setIsInit(isInit);
  }

  @override
  Future<Uint8List> downloadPdf(String url,
      {void Function(int, int)? onReceiveProgress}) {
    return _functionsRepo.downloadPdf(url,
        onReceiveProgress: onReceiveProgress);
  }

  @override
  Future<ApiResult<LogbookEntry>> markExitById(String logRecordId) {
    return _logRecordsRepo.markExitById(logRecordId);
  }

  @override
  Future<ApiResult<NotificationResponseModel>> getSentNotifications() {
    return _functionsRepo.getSentNotifications();
  }

  @override
  Future<ApiResult> sendSos(double lat, double lng) {
    return _functionsRepo.sendSos(lat, lng);
  }

  void _onError(DioError dioError, ErrorInterceptorHandler handler) {
    if (dioError.response?.statusCode == 401) {
      _authRepo.logout();
    }
    handler.next(dioError);
  }

  @override
  Stream<bool> get isLoggedInStream => _authRepo.isLoggedInStream;

  @override
  Future<ApiResult<String>> deleteUser() {
    return _userRepo.deleteUser();
  }

  @override
  Future<ApiResult<String>> deleteUserById({required int userId}) {
    return _userRepo.deleteUserById(userId: userId);
  }

  @override
  Future<bool> synchronizeLogRecords() {
    return _logRecordsRepo.synchronizeLogRecords();
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
    return _cvdFormsRepo.submitCvdForm(cvdForm,
        onReceiveProgress: onReceiveProgress);
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
    return _authRepo.updateCvdForms(base64pdfs: base64pdfs);
  }

  @override
  Future<ApiResult<List<WitholdingPeriodModel>>> getWitholdingPeriodsList() {
    return _cvdFormsRepo.getWitholdingPeriodsList();
  }

  @override
  void cancel() {
    _geofencesRepo.cancel();
  }

  @override
  Future<ApiResult> deletePolygon(PolygonModel model) {
    return _geofencesRepo.deletePolygon(model);
  }

  @override
  Future<ApiResult<List<PolygonModel>>> getAllPolygon() {
    return _geofencesRepo.getAllPolygon();
  }

  @override
  bool get hasPolygons => _geofencesRepo.hasPolygons;

  @override
  Future<ApiResult<String>> notifyManager(
      String lat, String lng, String locationId) {
    return _geofencesRepo.notifyManager(lat, lng, locationId);
  }

  @override
  Stream<List<PolygonModel>> get polygonStream => _geofencesRepo.polygonStream;

  @override
  Future<List<PolygonModel>> get polygonsCompleter =>
      _geofencesRepo.polygonsCompleter;

  @override
  Future<void> saveAllPolygon(List<PolygonModel> polygons) {
    return _geofencesRepo.saveAllPolygon(polygons);
  }

  @override
  Future<ApiResult<void>> savePolygon(PolygonModel model) {
    return _geofencesRepo.savePolygon(model);
  }

  @override
  Future<ApiResult> updatePolygon(PolygonModel model) {
    return _geofencesRepo.updatePolygon(model);
  }

  @override
  Future<void> previousZoneExitDateChecker() {
    return _logRecordsRepo.previousZoneExitDateChecker();
  }

  @override
  List<PolygonModel> get polygons => _geofencesRepo.polygons;

  @override
  Future<ApiResult<UserData>> temporaryOwner(TemporaryOwnerParams params) {
    return _geofencesRepo.temporaryOwner(params);
  }

  @override
  Future<ApiResult<bool>> removeTemporaryOwner(TemporaryOwnerParams params) {
    return _geofencesRepo.removeTemporaryOwner(params);
  }

  @override
  Future<ApiResult<String>> createStripeSession(
      String priceId, String paymentMode,
      {String? governmentCode, String? role}) {
    return _paymentRepo.createStripeSession(priceId, paymentMode,
        governmentCode: governmentCode, role: role);
  }

  @override
  List<CvdForm> get cvdForms => _cvdFormsRepo.cvdForms;

  @override
  Stream<List<CvdForm>> get cvdFormsStream => _cvdFormsRepo.cvdFormsStream;

  @override
  Future<ApiResult<bool>> uploadCvdForm(CvdForm file, String? pic,
      {ProgressCallback? onReceiveProgress, ProgressCallback? onSendProgress}) {
    return _cvdFormsRepo.uploadCvdForm(file, pic,
        onReceiveProgress: onReceiveProgress, onSendProgress: onSendProgress);
  }

  @override
  Future<ApiResult<PlanDetailsModel>> getPlanDetails() {
    return _paymentRepo.getPlanDetails();
  }

  @override
  Future<ApiResult<File>> saveOnlineCvd(CvdModel cvd,
      {ProgressCallback? onReceiveProgress}) {
    return _cvdFormsRepo.saveOnlineCvd(cvd,
        onReceiveProgress: onReceiveProgress);
  }

  @override
  Future<Directory> getCvdDownloadsDir() {
    return _cvdFormsRepo.getCvdDownloadsDir();
  }

  @override
  Future<ApiResult<List<SosNotification>>> getSosNotification() {
    return _functionsRepo.getSosNotification();
  }

  @override
  Future<ApiResult<String>> createPortal() {
    return _paymentRepo.createPortal();
  }

  @override
  Future<ApiResult<List<PicModel>>> getPics() {
    return _picRepo.getPics();
  }

  @override
  Future<ApiResult<PicModel>> createPic({required AddPicParams params}) {
    return _picRepo.createPic(params: params);
  }

  @override
  Future<ApiResult<PicModel>> updatePic(
      {required AddPicParams params, required int picId}) {
    return _picRepo.updatePic(params: params, picId: picId);
  }

  @override
  List<PicModel> get pics => _picRepo.pics;

  @override
  Stream<List<PicModel>> get picsStream => _picRepo.picsStream;

  @override
  Future<ApiResult<UserData>> updateUserData({required UserData data}) {
    return _authRepo.updateUserData(data: data);
  }
  
  @override
  Future<ApiResult<Consignments>> getEnvdForms(String lpaUsername, String lpaPassword) {
    return _envdRepo.getEnvdForms(lpaUsername, lpaPassword);
  }
  
  @override
  Future<ApiResult> getEnvdToken({required String username, required String password}) {
    return _envdRepo.getEnvdToken(username: username, password: password);
  }
  
  @override
  // TODO: implement consignmentsStream
  Stream<Consignments> get consignmentsStream => _envdRepo.consignmentsStream;
}
