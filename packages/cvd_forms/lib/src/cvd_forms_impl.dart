// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:api_client/configs/client.dart';
import 'package:cvd_forms/models/models.dart';
import 'package:cvd_forms/src/cvd_form_utils.dart';
import 'package:cvd_forms/src/forms_storage_helper.dart';
import 'package:cvd_forms/src/pdf/models/cvd_pdf_model.dart';
import 'package:cvd_forms/storage/cvd_forms_storage.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';

import 'cvd_forms_repo.dart';

class CvdFormsRepoImpl implements CvdFormsRepo {
  final Client client;
  final CvdFormsStorage storage;
  final Directory cacheDir;
  CvdFormsRepoImpl({
    required this.cacheDir,
    required Box box,
    required this.client,
  }) : storage = CvdFormsStorage(box);

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
  ApiResult<List<CvdForm>> getCvdForms() {
    try {
      final forms = storage.getCvdForms();
      return ApiResult.success(data: forms);
    } catch (e) {
      return const ApiResult.failure(
          error: NetworkExceptions.defaultError('Failed to get forms'));
    }
  }

  @override
  Future<ApiResult<File>> submitCvdForm(CvdForm cvdForm,
      {ProgressCallback? onReceiveProgress}) async {
    try {
      final Uint8List pdf = await _generatePdf(cvdForm.toFormJson());
      final FormsHelper formsHelper = FormsHelper(cachePath: cacheDir.path);
      final file = await formsHelper.createCvdFile(cvdForm.fileName);
      await file.writeAsBytes(pdf);
      final form = cvdForm.copyWith(filePath: file.path);
      await addCvdForm(form);
      return ApiResult.success(data: file);
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
  Future<bool> deleteForm(CvdForm cvdForm) async {
    if (cvdForm.filePath != null) {
      final file = File(cvdForm.filePath!);
      final fileExists = await file.exists();
      if (fileExists) await file.delete();
    }
    final isRemoved = await storage.deleteCvdForm(cvdForm);
    return isRemoved;
  }

  @override
  Future<ApiResult<bool>> uploadCvdForm(CvdForm file, String? pic,
      {ProgressCallback? onReceiveProgress,
      ProgressCallback? onSendProgress}) async {
    try {
      await client.uploadFile(
        Endpoints.createCvd,
        file: File(file.filePath!),
        fields: file.toForm(),
        fileName: file.fileName,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
      );
      return const ApiResult.success(data: true);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<void> syncForm() async {
    for (var cvdform in storage.cvdForms) {
      final result = await uploadCvdForm(cvdform, '');
      result.when(
        success: (s) {
          if (s) deleteForm(cvdform);
        },
        failure: (s) {},
      );
    }
  }

  @override
  List<CvdForm> get cvdForms => storage.cvdForms;

  @override
  Stream<List<CvdForm>> get cvdFormsStream => storage.cvdFormsStream;
}
