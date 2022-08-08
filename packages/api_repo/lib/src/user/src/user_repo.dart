import '../../../api_result/api_result.dart';
import '../../../api_result/network_exceptions/network_exceptions.dart';
import '../../../configs/client.dart';
import '../../../configs/endpoint.dart';
import 'models/models.dart';

abstract class UserRepo {
  Future<ApiResult<UserRoles>> getUserRoles();
  Future<ApiResult<RoleDetailsModel>> getFields();

  // Future<ApiResult<UserRoles>> getUserRolesById(int id);
  // Future<ApiResult<UserRoles>> createUserRoles(UserRoles userRoles);
  // Future<ApiResult<UserRoles>> updateUserRoles(UserRoles userRoles);
  // Future<ApiResult<UserRoles>> deleteUserRoles(int id);
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
}
