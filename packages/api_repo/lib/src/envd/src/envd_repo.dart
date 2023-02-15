import 'package:api_client/api_result/api_result.dart';

import '../models/models.dart';

abstract class EnvdRepo {
  Future<ApiResult<Consignments>> getEnvdForms(
      String lpaUsername, String lpaPassword);

  Future<ApiResult> getEnvdToken({
    required String username,
    required String password,
  });
}
