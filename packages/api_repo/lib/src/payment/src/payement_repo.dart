import 'package:api_client/api_result/api_result.dart';

import '../model/models.dart';

abstract class PaymentRepo {
  Future<ApiResult<String>> createStripeSession(
      String priceId, String paymentMode,
      {String? governmentCode, String? role});
  Future<ApiResult<PlanDetailsModel>> getPlanDetails();
}
