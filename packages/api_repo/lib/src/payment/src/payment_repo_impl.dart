// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:api_repo/api_repo.dart';
import 'package:api_repo/src/payment/src/payement_repo.dart';

class PaymentRepoImpl implements PaymentRepo {
  final Client client;
  PaymentRepoImpl({
    required this.client,
  });

  @override
  Future<ApiResult<String>> createStripeSession() async {
    try {
      final session = await client.post(Endpoints.createSession);
      return ApiResult.success(data: session.data['url']);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
