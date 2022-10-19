// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:api_repo/api_result/api_result.dart';
import 'package:api_repo/api_result/network_exceptions/network_exceptions.dart';
import 'package:api_repo/configs/client.dart';
import 'package:api_repo/configs/endpoint.dart';

abstract class FunctionsRepo {
  Future<ApiResult> sendEmergencyNotification();
}

class FunctionsRepoImpl implements FunctionsRepo {
  final Client client;
  FunctionsRepoImpl({
    required this.client,
  });
  @override
  Future<ApiResult> sendEmergencyNotification() async {
    try {
      final response = await client.post(
        Endpoints.sendEmergencyNotification,
      );
      return ApiResult.success(data: response);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
