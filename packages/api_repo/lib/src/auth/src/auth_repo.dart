import 'package:api_repo/api_repo.dart';
import 'package:api_repo/api_result/api_result.dart';

abstract class AuthRepo {
  Future<ApiResult<ResponseModel>> signUp({required SignUpModel data});
  Future<ApiResult<User>> signIn({required SignInModel data});
  Future<ApiResult<User>> verifyOtp({required OtpModel otpModel});
  Future<ApiResult<User>> updateMe({required User user});
  Future<ApiResult<User>> updateUser({required UserData userData});
  Future<ApiResult<User>> updateStatus({required UserData userData});


  Future<ApiResult<ResponseModel>> forgotPassword({required String email});
  Future<ApiResult<ResponseModel>> resetPassword({required OtpModel model});
  User? getUser();
  UserData? getUserData();

  Future<void> setUserData(UserData userData);
  bool get isLoggedIn;

  Future<void> logout();
  String? getToken();
  Stream<User?> get userStream;
  Stream<UserData?> get userDataStream;
  Stream<List<UserRoles>?> get userRolesStream;
}
