import 'dart:convert';

import 'package:api_client/api_client.dart';
import 'package:cvd_forms/cvd_forms.dart';
import 'package:flutter/services.dart';
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
      return const ApiResult.failure(error: NetworkExceptions.defaultError('Failed to save form'));
    }
  }

  @override
  ApiResult<List<CvdForm>> getCvdForms() {
    try {
      final forms = storage.getCvdForms();
      return ApiResult.success(data: forms);
    } catch (e) {
      return const ApiResult.failure(error: NetworkExceptions.defaultError('Failed to get forms'));
    }
  }

  @override
  Future<ApiResult<Uint8List>> submitForm(CvdForm cvdForm, {ProgressCallback? onReceiveProgress}) async {
    return const ApiResult.failure(error: NetworkExceptions.defaultError('Not available in offline mode'));
  }

  @override
  Future<ApiResult<CvdForm>> updateCvdForm(CvdForm cvdForm) async {
    try {
      await storage.updateCvdForm(cvdForm);
      return ApiResult.success(data: cvdForm);
    } catch (e) {
      return const ApiResult.failure(error: NetworkExceptions.defaultError('Failed to update form'));
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
  Future<ApiResult<List<WitholdingPeriodModel>>> getWitholdingPeriodsList() async {
    try {
      final data = await rootBundle.loadString("packages/cvd_forms/assets/json/witholding_periods.json");
      final map = jsonDecode(data);
      final list = (map as List).map((e) => WitholdingPeriodModel.fromJson(e)).toList();
      return ApiResult.success(data: list);
    } catch (e) {
      return const ApiResult.failure(error: NetworkExceptions.defaultError('Failed to get witholding periods'));
    }
  }
}
