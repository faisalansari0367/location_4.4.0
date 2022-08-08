import 'package:api_repo/api_repo.dart';

abstract class Api with AuthRepo, UserRepo {
  Future<void> init({required String baseUrl});
}
