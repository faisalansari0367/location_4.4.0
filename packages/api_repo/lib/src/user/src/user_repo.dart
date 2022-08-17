import 'package:api_repo/src/user/src/models/role_details_response.dart';

import '../../../api_result/api_result.dart';
import '../../../api_result/network_exceptions/network_exceptions.dart';
import '../../../configs/client.dart';
import '../../../configs/endpoint.dart';
import 'models/models.dart';

abstract class UserRepo {
  Future<ApiResult<UserRoles>> getUserRoles();
  Future<ApiResult<RoleDetailsModel>> getFields();
  Future<ApiResult<void>> updateRole(Map<String, dynamic> data);
  Future<ApiResult<Map<String, dynamic>>> getRoleData();
}

class UserRepoImpl extends UserRepo {
  final Client client;

  UserRepoImpl({required this.client});

  @override
  Future<ApiResult<UserRoles>> getUserRoles() async {
    try {
      final result = await client.get(Endpoints.getRoles);
      final model = UserRoles.fromMap(result.data);
      return ApiResult.success(data: model);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<RoleDetailsModel>> getFields() async {
    try {
      final result = await client.get(Endpoints.getFields);
      final model = RoleDetailsModel.fromMap(result.data);
      return ApiResult.success(data: model);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<void>> updateRole(Map<String, dynamic> data) async {
    try {
      final result = await client.patch(Endpoints.updateUser, data: data);
      return ApiResult.success(data: result.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getRoleData() async {
    try {
      final result = await client.get(Endpoints.updateUser);
      final data = (result.data);
      return ApiResult.success(data: data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
