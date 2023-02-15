// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:api_repo/configs/client.dart';
// import 'package:hive_flutter/adapters.dart';

import 'package:api_repo/api_repo.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rxdart/subjects.dart';

import '../envd_repo.dart';
import 'graph_query.dart';
import 'storage/envd_storage_service.dart';

class EnvdRepoImpl implements EnvdRepo {
  final Client client;
  final Box box;
  late EnvdStorageService storageService;
  EnvdRepoImpl({
    required this.box,
    required this.client,
  }) {
    storageService = EnvdStorageService(box: box);
  }

  final BehaviorSubject<Consignments> _controller =
      BehaviorSubject<Consignments>.seeded(Consignments(items: []));

  static const _envdUrl = 'https://auth-uat.integritysystems.com.au';
  static const _clientData = {
    'client_id': 'itrack',
    'client_secret': 'u7euFqDzqZzP2T9SmL7Y',
    'grant_type': 'password',
    'scope': 'lpa_scope',
  };

  @override
  Future<ApiResult> getEnvdToken({
    required String username,
    required String password,
  }) async {
    try {
      final data = {'username': username, 'password': password};
      final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      final options = Options(headers: headers);
      final result = await client.build().post(
            '$_envdUrl/connect/token',
            data: _clientData..addAll(data),
            options: options,
          );
      final envdModel = EnvdTokenModel.fromJson(result.data);
      storageService.saveToken(username, envdModel);
      return ApiResult.success(data: envdModel);
    } on DioError catch (e) {
      var error = NetworkExceptions.getDioException(e);
      final response = e.response?.data['error'];
      if (response != null) {
        if (response == 'invalid_client') {
          error = NetworkExceptions.defaultError(
              '$response \n Please contact support');
        }
      } else {
        error = const NetworkExceptions.defaultError('Something went wrong');
      }
      return ApiResult.failure(error: error);
    }
  }

  @override
  Future<ApiResult<Consignments>> getEnvdForms(
      String lpaUsername, String lpaPassword) async {
    final consignments = storageService.getConsignments(lpaUsername);
    if (consignments != null) _controller.add(consignments);

    try {
      EnvdTokenModel? token = storageService.getToken(lpaUsername);
      if (token == null) {
        await getEnvdToken(username: lpaUsername, password: lpaPassword);
      }

      final result = await client.build().post(
            '$_envdUrl/graphql',
            data: {'query': GraphQuery.envdQuery},
            options: Options(headers: {
              'Authorizaiton':
                  'Bearer ${storageService.getToken(lpaUsername)?.accessToken}',
            }),
          );

      final envdModel = Consignments.fromJson(result.data!['consignments']);
      storageService.saveConsignments(lpaUsername, envdModel);
      return ApiResult.success(data: envdModel);
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
