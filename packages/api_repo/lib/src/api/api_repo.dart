import 'package:api_repo/api_repo.dart';
import 'package:api_repo/src/locale/currency_repo.dart';

import '../../configs/client.dart';

abstract class Api with AuthRepo, UserRepo, LocalesApi {
  @override
  Future<void> init({required String baseUrl});
  Client get client;
}
