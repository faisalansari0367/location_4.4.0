import 'package:api_repo/configs/client.dart';
import 'package:api_repo/src/locale/currency_repo.dart';
import 'package:api_repo/src/user/src/models/role_details_response.dart';
import 'package:hive_flutter/adapters.dart';

import '../../api_repo.dart';
import '../../api_result/api_result.dart';
import '../auth/src/storage/storage_service.dart';
import '../user/src/models/models.dart';

class ApiRepo implements Api {
  late Client _client;
  late AuthRepo _authRepo;
  late UserRepo _userRepo;
  late Box _box;
  late LocalesApi _localesApi;

  ApiRepo();

  
  @override
  Future<void> init({required String baseUrl}) async {
    await Hive.initFlutter();
    _box = await Hive.openBox('storage');
    final storage = StorageService(box: _box);
    final token = storage.getToken();
    _client = Client(baseUrl: baseUrl, token: token);
    _userStream(_box, storage.userKey);
    _authRepo = AuthRepoImpl(client: _client, box: _box);
    _userRepo = UserRepoImpl(client: _client);
    _localesApi = LocalesRepo();
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
  Future<ApiResult<UserRoles>> getUserRoles() async => await _userRepo.getUserRoles();

  @override
  Future<ApiResult<RoleDetailsModel>> getFields() => _userRepo.getFields();

  @override
  Future<ApiResult<User>> updateUser({required User user}) async {
    return await _authRepo.updateUser(user: user);
  }

  @override
  void changeCountry({required String code, required String dial, required String name}) {
    return _localesApi.changeCountry(code: code, dial: dial, name: name);
  }

  @override
  String? get countryCode => _localesApi.countryCode;

  @override
  String? get countryName => _localesApi.countryName;

  @override
  String? get dialCode => _localesApi.dialCode;

  @override
  Future<void> initLocale() {
    // TODO: implement initLocale
    throw UnimplementedError();
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
  Future<ApiResult<void>> updateRole(Map<String, dynamic> data) {
    return _userRepo.updateRole(data);
  }

  @override
  Future<ApiResult<RoleDetailsResponse>> getRoleData() {
    return _userRepo.getRoleData();
  }
}
