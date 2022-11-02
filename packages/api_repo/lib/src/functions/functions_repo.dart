// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:api_repo/api_repo.dart';
import 'package:api_repo/api_result/api_result.dart';
import 'package:api_repo/api_result/network_exceptions/network_exceptions.dart';
import 'package:api_repo/configs/client.dart';
import 'package:api_repo/configs/endpoint.dart';

abstract class FunctionsRepo {
  Future<ApiResult<List<UserData>>> sendEmergencyNotification({required List<int> ids});
  Future<void> getEnvdToken();
  // Future<void> getEnvdForms();
}

class FunctionsRepoImpl implements FunctionsRepo {
  final Client client;
  FunctionsRepoImpl({
    required this.client,
  });
  @override
  Future<ApiResult<List<UserData>>> sendEmergencyNotification({required List<int> ids}) async {
    try {
      final response = await client.post(
        Endpoints.sendEmergencyNotification,
        // data: {'geofences': ids},
        queryParameters: {'geofences': ids},
      );

      final data = response.data['data'] as List;
      final users = data.map((e) => UserData.fromJson(e)).toList();
      return ApiResult.success(data: users);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  static const envdUrl = 'https://auth-uat.integritysystems.com.au';

  @override
  Future<void> getEnvdToken() async {
    final data = {
      'client_id': 'itrack',
      'client_secret': 'u7euFqDzqZzP2T9SmL7Y',
      'grant_type': 'password',
      'scope': 'lpa_scope',
      'username': 'QDZZ3333-2305875',
      'password': 'Q6qN2VquqqtpkBP!'
    };
    final result = await client.build().post(envdUrl + '/connect/token', data: data);
    final accessToken = result.data['access_token'];
    // ignore: avoid_print
    print(accessToken);
  }

  // @override
  // Future<void> getEnvdForms() async {
  //   final result = await client.build().post(
  //         envdUrl + '/graphql',
  //       );
  // }

  /// envd
  ///

}
