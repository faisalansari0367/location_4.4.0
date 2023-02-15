import 'package:api_repo/api_repo.dart';
import 'package:api_repo/src/envd/envd_repo.dart';
import 'package:cvd_forms/cvd_forms.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class Api
    with
        AuthRepo,
        UserRepo,
        LogRecordsRepo,
        FunctionsRepo,
        CvdFormsRepo,
        EnvdRepo,
        GeofencesRepo,
        PicRepo,
        PaymentRepo {
  // @override
  Future<void> init({required String baseUrl, required Box box});
  Client get client;
}
