import 'package:api_repo/api_repo.dart';
import 'package:api_repo/src/log/log_records.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../configs/client.dart';

abstract class Api with AuthRepo, UserRepo, LogRecordsRepo {
  // @override
  Future<void> init({required String baseUrl, required Box box});
  Client get client;
}
