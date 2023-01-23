// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:api_repo/api_repo.dart';

class PaymentRepoImpl implements PaymentRepo {
  final Client client;
  PaymentRepoImpl({
    required this.client,
  });

  @override
  Future<ApiResult<String>> createStripeSession(
      String priceId, String paymentMode,
      {String? governmentCode, String? role}) async {
    try {
      final session = await client.post(
        Endpoints.createSession,
        data: {
          'priceId': priceId,
          'mode': paymentMode.toLowerCase(),
          'governmentCode': governmentCode,
          'role': role,
        },
      );
      if (governmentCode != null && role != null) {
        return ApiResult.success(data: session.data['status']);
      }

      return ApiResult.success(data: session.data['url']);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<PlanDetailsModel>> getPlanDetails() async {
    try {
      final session = await client.get(Endpoints.planDetails);
      final model = PlanDetailsModel.fromJson(session.data);
      return ApiResult.success(data: model);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
