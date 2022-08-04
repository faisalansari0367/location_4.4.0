import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'network_exceptions/network_exceptions.dart';

part 'api_result.freezed.dart';

@freezed
abstract class ApiResult<T> with _$ApiResult<T> {
  const factory ApiResult.success({required T data}) = Success<T>;

  const factory ApiResult.failure({required NetworkExceptions error}) = Failure<T>;
}

// class ApiResponse<T> {
//   Future<void> when({
//     required void Function(T) success,
//     required void Function(dynamic) failure,
//   }) async {}
// }

// final result= ApiResponse().when(success: success, failure: failure);


// class ApiResult<T> {
//   ApiResult.success({required T data});
//   ApiResult.failure({required DioError error});
//   ApiResult.when({required T Function(T) success, required void Function(DioError) failure });

//   // when({required T Function(T) success, required void Function(DioError) failure })

// }