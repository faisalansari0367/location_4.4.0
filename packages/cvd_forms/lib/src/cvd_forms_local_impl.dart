import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:cvd_forms/cvd_forms.dart';
import 'package:cvd_forms/src/cvd_form_utils.dart';
import 'package:hive_flutter/adapters.dart';

import '../storage/cvd_forms_storage.dart';

class CvdFormsLocalImpl implements CvdFormsRepo {
  final CvdFormsStorage storage;
  CvdFormsLocalImpl({required Box box}) : storage = CvdFormsStorage(box);

  @override
  Future<ApiResult<CvdForm>> addCvdForm(CvdForm cvdForm) async {
    try {
      await storage.addCvdForm(cvdForm);
      return ApiResult.success(data: cvdForm);
    } catch (e) {
      return const ApiResult.failure(
          error: NetworkExceptions.defaultError('Failed to save form'));
    }
  }

  @override
  Future<ApiResult<List<CvdModel>>> getCvdUrls() {
    return Future.value(const ApiResult.failure(
      error: NetworkExceptions.defaultError('Not available in offline mode'),
    ));
  }

  @override
  Future<ApiResult<File>> submitCvdForm(CvdForm cvdForm,
      {ProgressCallback? onReceiveProgress}) async {
    return const ApiResult.failure(
        error: NetworkExceptions.defaultError('Not available in offline mode'));
  }

  @override
  Future<ApiResult<CvdForm>> updateCvdForm(CvdForm cvdForm) async {
    try {
      await storage.updateCvdForm(cvdForm);
      return ApiResult.success(data: cvdForm);
    } catch (e) {
      return const ApiResult.failure(
          error: NetworkExceptions.defaultError('Failed to update form'));
    }
  }

  @override
  CvdForm? getCurrentForm() {
    try {
      final form = storage.getCvdForm();
      return form;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteForm(CvdForm cvdForm) {
    return storage.deleteCvdForm(cvdForm);
  }

  @override
  Future<ApiResult<List<WitholdingPeriodModel>>>
      getWitholdingPeriodsList() async {
    try {
      final data = await CvdFormUtils.fetchWitholdingPeriods();
      return ApiResult.success(data: data);
    } catch (e) {
      return const ApiResult.failure(
        error:
            NetworkExceptions.defaultError('Failed to get witholding periods'),
      );
    }
  }

  @override
  List<CvdForm> get cvdForms => storage.cvdForms;

  @override
  Stream<List<CvdForm>> get cvdFormsStream => storage.cvdFormsStream;

  @override
  Future<ApiResult<bool>> uploadCvdForm(
    CvdForm file,
    String? pic, {
    ProgressCallback? onReceiveProgress,
    ProgressCallback? onSendProgress,
  }) {
    return Future.value(const ApiResult.failure(
      error: NetworkExceptions.defaultError('Not available in offline mode'),
    ));
  }
}
