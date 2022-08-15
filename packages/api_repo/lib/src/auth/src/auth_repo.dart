import 'package:api_repo/api_result/api_result.dart';

import 'models/models.dart';

abstract class AuthRepo {
  Future<ApiResult<ResponseModel>> signUp({required SignUpModel data});
  Future<ApiResult<User>> signIn({required SignInModel data});
  Future<ApiResult<User>> verifyOtp({required OtpModel otpModel});
  Future<ApiResult<User>> updateUser({required User user});
  Future<ApiResult<ResponseModel>> forgotPassword({required String email});
  Future<ApiResult<ResponseModel>> resetPassword({required OtpModel model});
  User? getUser();
  Future<void> logout();
  String? getToken();
}
