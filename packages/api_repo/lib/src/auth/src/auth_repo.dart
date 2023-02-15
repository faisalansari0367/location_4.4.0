import 'package:api_repo/api_repo.dart';

abstract class AuthRepo {
  Future<ApiResult<ResponseModel>> signUp({required SignUpModel data});
  Future<ApiResult<User>> signIn({required SignInModel data});
  Future<ApiResult<User>> verifyOtp({required OtpModel otpModel});
  Future<ApiResult<User>> updateMe({required User user, bool isUpdate = true});
  Future<ApiResult<User>> updateAllowedRoles(
      {required List<String> allowedRoles});
  Future<ApiResult<User>> updateStatus({required UserData userData});
  Future<ApiResult<UserData>> updateUserData({required UserData data});
  Future<ApiResult<User>> updateCvdForms({required List<String> base64pdfs});

  Future<ApiResult<ResponseModel>> forgotPassword({required String email});
  Future<ApiResult<ResponseModel>> resetPassword({required OtpModel model});
  User? getUser();
  UserData? getUserData();

  Future<void> setUserData(UserData userData);
  bool get isLoggedIn;
  bool get isInit;

  bool setIsInit(bool isInit);

  Future<void> logout();
  String? getToken();
  Stream<User?> get userStream;
  Stream<UserData?> get userDataStream;
  Stream<List<UserRoles>?> get userRolesStream;
  Stream<bool> get isLoggedInStream;
}
