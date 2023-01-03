// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:api_client/api_client.dart';
import 'package:api_client/configs/client.dart';
import 'package:cvd_forms/models/models.dart';
import 'package:cvd_forms/models/src/cvd_form.dart';
import 'package:cvd_forms/src/pdf/models/cvd_pdf_model.dart';
import 'package:cvd_forms/storage/cvd_forms_storage.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';

import 'cvd_forms_repo.dart';

class CvdFormsRepoImpl implements CvdFormsRepo {
  final Client client;
  final CvdFormsStorage storage;
  CvdFormsRepoImpl({required Box box, required this.client}) : storage = CvdFormsStorage(box);

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
    try {
      // final result = await client.build().post(
      //       Endpoints.cvdFormUrl,
      //       data: cvdForm.toFormJson(),
      //       // options: Options(responseType: ResponseType.bytes),
      //       onReceiveProgress: onReceiveProgress,
      //     );
      // if (result.data['status'] == false) {
      //   final error = result.data['data'] as Map;
      //   final exception = NetworkExceptions.defaultError('${result.data['message']} \n ${error.values.first}');
      //   return ApiResult.failure(error: exception);
      // }

      return ApiResult.success(data: await _generatePdf(cvdForm.toFormJson()));

      // final Uint8List bytes = base64Decode(result.data['data']);
      // return ApiResult.success(data: bytes);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<Uint8List> _generatePdf(Map<String, dynamic> json) async {
    final model = CvdPdfModel.fromJson(json);
    return await model.generatePdf();
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

  // Future<void> sync() async {
  //   final forms = storage.getCvdForms();
  //   for (final form in forms) {

  //     final result = await submitForm(form);
  //     if (result.isSuccess) {
  //       await storage.updateCvdForm(form.copyWith(isSynced: true));
  //     }
  //   }
  // }
}
