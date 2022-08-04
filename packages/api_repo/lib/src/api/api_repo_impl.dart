import 'package:api_repo/configs/client.dart';
import 'package:hive_flutter/adapters.dart';

import '../../api_repo.dart';
import '../../api_result/api_result.dart';

class ApiRepo implements Api {
  late Client _client;
  late AuthRepo _authRepo;
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
    _client = Client(baseUrl: baseUrl);
    _authRepo = AuthRepoImpl(client: _client, box: _box);
  }

  @override
  User? getUser() => _authRepo.getUser();

  @override
  Future<void> logout() {
    return _authRepo.logout();
  }
}
