import 'package:api_client/api_result/api_result.dart';

import 'models/models.dart';

abstract class UserRepo {
  Future<ApiResult<List<UserRoles>>> getUserRoles();
  Future<ApiResult<RoleDetailsModel>> getFields(String role);
  Future<ApiResult<RoleDetailsModel>> getRoles();

  Future<ApiResult<void>> updateRole(String role, Map<String, dynamic> data);
  Future<ApiResult<Map<String, dynamic>>> getRoleData(String role);
  // Future<ApiResult<LogbookResponseModel>> getLogbookRecords();
  Future<ApiResult<UsersResponseModel>> getUsers(
      {Map<String, dynamic>? queryParams});
  Future<ApiResult<List<DeclarationForms>>> getDeclarationForms();
  Future<ApiResult<UserSpecies>> getUserSpecies();
  Future<ApiResult<UserFormsData>> getUserForms();

  Future<ApiResult<List<String>>> getLicenceCategories();
  Future<void> getCvdPDf(Map<String, dynamic> data);
  Future<dynamic> getQrCode(String data);
  Future<ApiResult> openPdf(String url);
  Future<ApiResult<String>> deleteUser();
  Future<ApiResult<String>> deleteUserById({required int userId});
  Future<ApiResult<List<PicModel>>> getPics();
  Future<ApiResult<PicModel>> createPic({required AddPicParams params});
}
