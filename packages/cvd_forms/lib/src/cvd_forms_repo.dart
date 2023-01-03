import 'dart:typed_data';

import 'package:api_client/api_client.dart';

import '../models/src/cvd_form.dart';

abstract class CvdFormsRepo {
  ApiResult<List<CvdForm>> getCvdForms();
  Future<ApiResult<CvdForm>> addCvdForm(CvdForm cvdForm);
  Future<ApiResult<CvdForm>> updateCvdForm(CvdForm cvdForm);
  CvdForm? getCurrentForm();
  Future<bool> deleteForm(CvdForm cvdForm);
  // ApiResult<Uint8List> submitForm(CvdForm cvdForm);
  Future<ApiResult<Uint8List>> submitForm(CvdForm cvdForm, {ProgressCallback? onReceiveProgress});
}