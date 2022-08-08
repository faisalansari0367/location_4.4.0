import 'package:api_repo/configs/client.dart';
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

  ApiRepo();

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
  Future<void> init({required String baseUrl}) async {
    await Hive.initFlutter();
    _box = await Hive.openBox('storage');
    final storage = StorageService(box: _box);
    _client = Client(baseUrl: baseUrl, token: storage.getToken());
    _authRepo = AuthRepoImpl(client: _client, box: _box);
    _userRepo = UserRepoImpl(client: _client);
  }

  @override
  User? getUser() => _authRepo.getUser();

  @override
  Future<void> logout() => _authRepo.logout();

  @override
  Future<ApiResult<UserRoles>> getUserRoles() async => await _userRepo.getUserRoles();

  @override
  Future<ApiResult<RoleDetailsModel>> getFields() => _userRepo.getFields();
}
