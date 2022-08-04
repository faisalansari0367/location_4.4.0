import 'package:api_repo/api_result/api_result.dart';

import 'models/models.dart';

abstract class AuthRepo {
  Future<ApiResult<ResponseModel>> signUp({required SignUpModel data});
  Future<ApiResult<User>> signIn({required SignInModel data});
  Future<ApiResult<User>> verifyOtp({required OtpModel otpModel});
  User? getUser();
  Future<void> logout();
  // Stream<User?> get userStream;
}
