import 'package:api_repo/src/auth/src/storage/storage_service.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import '../../../api_result/api_result.dart';
import '../../../api_result/network_exceptions/network_exceptions.dart';
import '../../../configs/client.dart';
import '../../../configs/endpoint.dart';
import 'models/models.dart';

abstract class UserRepo {
  Future<ApiResult<List<UserRoles>>> getUserRoles();
  Future<ApiResult<RoleDetailsModel>> getFields(String role);
  Future<ApiResult<RoleDetailsModel>> getRoles();

  Future<ApiResult<void>> updateRole(String role, Map<String, dynamic> data);
  Future<ApiResult<Map<String, dynamic>>> getRoleData(String role);
  // Future<ApiResult<LogbookResponseModel>> getLogbookRecords();
  Future<ApiResult<UsersResponseModel>> getUsers({Map<String, dynamic>? queryParams});
  Future<ApiResult<List<String>>> getFormQuestions();
  Future<ApiResult<UserSpecies>> getUserSpecies();
  Future<ApiResult<UserFormsData>> getUserForms();

  Future<ApiResult<List<String>>> getLicenceCategories();
  Future<void> getCvdPDf(Map<String, dynamic> data);
  Future<dynamic> getQrCode(String data);
  Future<ApiResult> openPdf(String url);
}

class UserRepoImpl extends UserRepo {
  final Client client;
  final StorageService storage;

  UserRepoImpl({required this.client, required Box box}) : storage = StorageService(box: box);

  @override
  Future<ApiResult<List<UserRoles>>> getUserRoles() async {
    try {
      final result = await client.get(Endpoints.fieldsRecords);
      final List data = result.data['data'];
      final List<UserRoles> model = data
          .map(
            (e) => UserRoles.fromMap(Map<String, dynamic>.from(e)),
          )
          .toList();
      storage.setRoles(model);
      return ApiResult.success(data: model);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<RoleDetailsModel>> getFields(String role) async {
    try {
      final result = await client.get(Endpoints.getFields);
      final model = RoleDetailsModel.fromMap(result.data);
      storage.setRoleFields(role, model.toMap());
      return ApiResult.success(data: model);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<void>> updateRole(String role, Map<String, dynamic> data) async {
    try {
      await client.patch(Endpoints.updateMe, data: data);
      // storage.setRoleData(role, data);
      // ignore: void_checks

      // ignore: void_checks
      return const ApiResult.success(data: Null);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getRoleData(String role) async {
    try {
      final result = await client.get(Endpoints.updateMe);
      final data = (result.data);
      storage.setRoleData(role, data);
      return ApiResult.success(data: data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  // @override
  // Future<ApiResult<LogbookResponseModel>> getLogbookRecords() async {
  //   try {
  //     final result = await client.get(Endpoints.logRecords);
  //     final data = LogbookResponseModel.fromJson(result.data);
  //     return ApiResult.success(data: data);
  //   } catch (e) {
  //     return ApiResult.failure(error: NetworkExceptions.getDioException(e));
  //   }
  // }

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
      final result = await client.get(Endpoints.forms);
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
      storage.setUserSpecies(list);
      return ApiResult.success(data: list);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<UserFormsData>> getUserForms() async {
    try {
      final result = await client.get(Endpoints.forms);
      final list = UserFormsData.fromJson(result.data);
      storage.setUserForms(list);
      return ApiResult.success(data: list);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<List<String>>> getLicenceCategories() async {
    try {
      final result = await client.get(Endpoints.licenceCategories);
      return ApiResult.success(data: List<String>.from(result.data['data']));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<void> getCvdPDf(Map<String, dynamic> data) async {
    // final result = await Dio().post('https://uniquetowinggoa.com/safemeat/public/api/declaration', data: data);
    // print(result);
    // throw UnimplementedError();
  }

  @override
  Future getQrCode(String data) async {
    try {
      final result = await client.post(Endpoints.qrCode, data: {'text': data});
      return ApiResult.success(data: result.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult> openPdf(String url) async {
    try {
      final result = await client.build().get(
            url,
            options: Options(
              responseType: ResponseType.bytes,
            ),
          );
      return ApiResult.success(data: result.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<RoleDetailsModel>> getRoles() async {
    try {
      final result = await client.get(Endpoints.roles);
      final model = RoleDetailsModel.fromMap(result.data);
      return ApiResult.success(data: model);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
