import 'package:api_client/api_result/api_result.dart';

abstract class PaymentRepo {
  Future<ApiResult<String>> createStripeSession();
}
