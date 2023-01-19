import 'dart:io';

import 'package:api_client/api_client.dart';

import '../models/models.dart';

abstract class CvdFormsRepo {
  Future<Directory> getCvdDownloadsDir();
  Future<ApiResult<File>> saveOnlineCvd(
      CvdModel cvd, {ProgressCallback? onReceiveProgress});
  Future<ApiResult<List<WitholdingPeriodModel>>> getWitholdingPeriodsList();
  Future<ApiResult<List<CvdModel>>> getCvdUrls();
  Future<ApiResult<CvdForm>> addCvdForm(CvdForm cvdForm);
  Future<ApiResult<CvdForm>> updateCvdForm(CvdForm cvdForm);
  CvdForm? getCurrentForm();
  Future<bool> deleteForm(CvdForm cvdForm);
  // ApiResult<Uint8List> submitForm(CvdForm cvdForm);
  Future<ApiResult<File>> submitCvdForm(CvdForm cvdForm,
      {ProgressCallback? onReceiveProgress});

  Stream<List<CvdForm>> get cvdFormsStream;
  List<CvdForm> get cvdForms;
  Future<ApiResult<bool>> uploadCvdForm(CvdForm file, String? pic,
      {ProgressCallback? onReceiveProgress, ProgressCallback? onSendProgress});
}
