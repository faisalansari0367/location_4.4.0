import 'package:api_client/api_client.dart';
import 'package:api_client/configs/client.dart';
import 'package:api_repo/src/auth/src/storage/storage_service.dart';
import 'package:hive_flutter/adapters.dart';

import '../../auth/src/models/user_data.dart';
import 'models/models.dart';
import 'user_repo.dart';

class UserRepoImpl extends UserRepo {
  final Client client;
  final StorageService storage;

  UserRepoImpl({required this.client, required Box box})
      : storage = StorageService(box: box);

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
  Future<ApiResult<void>> updateRole(
      String role, Map<String, dynamic> data) async {
    try {
      final result = await client.patch(
        Endpoints.updateMe,
        data: data,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      final model = UserData.fromJson(result.data['data']);
      await storage.setUserData(model);
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
      final data = result.data;
      await storage.setUserData(UserData.fromJson(data['data']));
      await storage.setRoleData(role, data);
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
  Future<ApiResult<UsersResponseModel>> getUsers(
      {Map<String, dynamic>? queryParams}) async {
    try {
      final result =
          await client.get(Endpoints.users, queryParameters: queryParams);
      final data = UsersResponseModel.fromJson(result.data['data']);
      return ApiResult.success(data: data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<List<DeclarationForms>>> getDeclarationForms() async {
    try {
      final result = await client.get(Endpoints.getForms);
      final forms = result.data['data'];
      final model = forms
          .map<DeclarationForms>(
              (e) => DeclarationForms.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      return ApiResult.success(data: model);
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

  @override
  Future<ApiResult<String>> deleteUser({int? userId}) async {
    try {
      final result =
          await client.delete(Endpoints.deleteUser, data: {'id': userId});
      final model = result.data['data'];
      return ApiResult.success(data: model);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<String>> deleteUserById({required int userId}) async {
    try {
      final result = await client.delete('${Endpoints.deleteUserById}/$userId');
      final model = result.data['data'];
      return ApiResult.success(data: model);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
