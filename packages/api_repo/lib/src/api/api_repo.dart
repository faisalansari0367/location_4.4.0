import 'package:api_repo/src/auth/auth_repo.dart';

abstract class Api with AuthRepo {
  Future<void> init({required String baseUrl});
}
