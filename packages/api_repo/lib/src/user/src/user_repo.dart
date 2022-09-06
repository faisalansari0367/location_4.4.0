import 'package:api_repo/src/auth/src/storage/storage_service.dart';
import 'package:hive/hive.dart';

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
  Future<ApiResult<LogbookEntryModel>> getLogbookRecords();
  Future<ApiResult<UsersResponseModel>> getUsers({Map<String, dynamic>? queryParams});
  Future<ApiResult<List<String>>> getFormQuestions();
  Future<ApiResult<UserSpecies>> getUserSpecies();
  Future<ApiResult<UserFormsData>> getUserForms();
}

class UserRepoImpl extends UserRepo {
  final Client client;
  final StorageService storage;

  UserRepoImpl({required this.client, required Box box}) : storage = StorageService(box: box);

  @override
  Future<ApiResult<UserRoles>> getUserRoles() async {
    try {
      final result = await client.get(Endpoints.getRoles);
      final model = UserRoles.fromMap(result.data);
      storage.setRoles(model.roles);
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
      await client.patch(Endpoints.updateUser, data: data);
      // ignore: void_checks
      return const ApiResult.success(data: Null);
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

  @override
  Future<ApiResult<LogbookEntryModel>> getLogbookRecords() async {
    try {
      final result = await client.get(Endpoints.logRecords);
      final data = LogbookEntryModel.fromJson(result.data);
      return ApiResult.success(data: data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<UsersResponseModel>> getUsers({Map<String, dynamic>? queryParams}) async {
    try {
      final result = await client.get(Endpoints.users, queryParameters: queryParams);
      final data = UsersResponseModel.fromJson(result.data['data']);
      return ApiResult.success(data: data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<List<String>>> getFormQuestions() async {
    try {
      final result = await client.get(Endpoints.formQuestions);
      final forms = result.data['data']['forms'].first.first;
      final list = (forms['questions']);
      final data = List<String>.from(list);
      return ApiResult.success(data: data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<UserSpecies>> getUserSpecies() async {
    try {
      final result = await client.get(Endpoints.userSpecies);
      final list = UserSpecies.fromJson(result.data);
      return ApiResult.success(data: list);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<UserFormsData>> getUserForms() async {
    try {
      final result = await client.get(Endpoints.usersForms);
      final list = UserFormsData.fromJson(result.data);
      return ApiResult.success(data: list);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
