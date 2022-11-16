// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:api_repo/api_repo.dart';
import 'package:api_repo/api_result/api_result.dart';
import 'package:api_repo/api_result/network_exceptions/network_exceptions.dart';
import 'package:api_repo/configs/client.dart';
import 'package:api_repo/configs/endpoint.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
// export 'package:api_repo/src/functions/models/notifications_model.dart';

abstract class FunctionsRepo {
  Future<ApiResult<List<UserData>>> sendEmergencyNotification({required List<int> ids});
  Future<Uint8List> downloadPdf(String url, {void Function(int, int)? onReceiveProgress});
  Future<ApiResult<NotificationResponseModel>> getSentNotifications();
  // Future<void> getEnvdForms();
}

class FunctionsRepoImpl implements FunctionsRepo {
  final Client client;
  FunctionsRepoImpl({
    required this.client,
  });
  @override
  Future<ApiResult<List<UserData>>> sendEmergencyNotification({required List<int> ids}) async {
    try {
      final response = await client.post(
        Endpoints.sendEmergencyNotification,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        // data: {'geofences': ids},
        data: {'geofences': ids},
      );

      final data = response.data['data'] as List;
      final users = data.map((e) => UserData.fromJson(e)).toList();
      return ApiResult.success(data: users);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<NotificationResponseModel>> getSentNotifications() async {
    try {
      final response = await client.get(
        Endpoints.getSentNotifications,
        // options: Options(
        //   headers: {
        //     'Content-Type': 'application/json',
        //   },
        // ),
        // data: {'geofences': ids},
        // data: {'geofences': ids},
      );

      final data = NotificationResponseModel.fromJson(response.data);

      return ApiResult.success(data: data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  // downloadFile

  @override
  Future<Uint8List> downloadPdf(String url, {void Function(int, int)? onReceiveProgress}) async {
    try {
      final response = await client.build().get(
            url,
            options: Options(responseType: ResponseType.bytes),
            onReceiveProgress: onReceiveProgress,
          );
      return response.data;
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }
}
