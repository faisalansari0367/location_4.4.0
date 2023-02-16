// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:api_repo/configs/client.dart';
// import 'package:hive_flutter/adapters.dart';

import 'dart:convert';

import 'package:api_repo/api_repo.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rxdart/subjects.dart';

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

  static const _graphQlUrl = "https://api.uat.integritysystems.com.au/graphql";
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
            data: data..addAll(_clientData),
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
    if (consignments?.items?.isNotEmpty ?? false) {
      // _controller.add(consignments!);
    }

    try {
      EnvdTokenModel? hasToken = storageService.getToken(lpaUsername);
      if (hasToken?.isExpired() ?? true) {
        await getEnvdToken(username: lpaUsername, password: lpaPassword);
      }

      final token = storageService.getToken(lpaUsername)?.accessToken;

      final result = await client.build(logging: false).post(
            _graphQlUrl,
            data: jsonEncode({'query': GraphQuery.envdQuery}),
            // data: GraphQuery.envdQuery,
            options: Options(
              headers: {
                'Authorization': 'Bearer $token',
              },
            ),
          );

      final envdModel = EnvdResponseModel.fromJson(result.data);
      final consignments = envdModel.data!.consignments!;
      storageService.saveConsignments(lpaUsername, consignments);
      _controller.add(consignments);
      return ApiResult.success(data: consignments);
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Stream<Consignments> get consignmentsStream => _controller.stream;
}
