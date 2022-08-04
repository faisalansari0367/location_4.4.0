// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';

import 'package:api_repo/api_result/api_result.dart';
import 'package:api_repo/api_result/network_exceptions/network_exceptions.dart';
import 'package:api_repo/configs/client.dart';
import 'package:api_repo/configs/endpoint.dart';
import 'package:api_repo/src/auth/src/storage/storage_service.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/adapters.dart';

import 'auth_repo.dart';
import 'models/models.dart';

class AuthRepoImpl implements AuthRepo {
  final Client client;
  final Box box;
  final StorageService storage;

  AuthRepoImpl({
    required this.client,
    required this.box,
  }) : storage = StorageService(box: box) {
    client.token = storage.getToken();
  }

  // final userController = StreamController();

  @override
  Future<ApiResult<ResponseModel>> signUp({required SignUpModel data}) async {
    try {
      final result = await client.post(Endpoints.signUp, data: data.toJson());
      final model = ResponseModel.fromMap((result.data));
      return ApiResult.success(data: model);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<User>> signIn({required SignInModel data}) async {
    try {
      final result = await client.post(Endpoints.signIn, data: data.toMap());
      final model = UserResponse.fromJson((result.data));
      storage.setToken(model.token!);
      storage.setUser(model.data!.user!.toJson());
      return ApiResult.success(data: model.data!.user!);
    } on DioError catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<User>> verifyOtp({required OtpModel otpModel}) async {
    try {
      final result = await client.post(Endpoints.verifyOtp, data: otpModel.toMap());
      final model = UserResponse.fromJson((result.data));
      storage.setToken(model.token!);
      storage.setUser(model.data!.user!.toJson());
      return ApiResult.success(data: model.data!.user!);
    } on DioError catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  User? getUser() => storage.getUser();

  @override
  Future<void> logout() async {
    await Future.wait(
      [
        storage.removeToken(),
        storage.removeUser(),
      ],
    );
  }
}
