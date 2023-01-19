import 'dart:developer';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

import 'api_logger.dart';

export 'package:dio/dio.dart'
    show DioError, Response, Dio, Options, ProgressCallback;

class Client {
  // String baseUrl = '';
  // String apiKey = '';
  final String baseUrl;
  String? token;
  final String? apiKey;
  final void Function(DioError, ErrorInterceptorHandler)? onError;

  Dio? _dio;

  BaseOptions options = BaseOptions(
    connectTimeout: 1000 * 300,
    receiveTimeout: 1000 * 300,
  );

  // String? token;
  Map<String, Object>? header;
  Client({
    required this.baseUrl,
    this.onError,
    this.token,
    this.apiKey,
    this.header,
  });

  // Client({this.token, this.baseUrl});

  void setToken(String token) {
    this.token = token;
  }

  Client builder({bool logging = true}) {
    header = <String, Object>{};
    header!.putIfAbsent('Accept', () => 'application/json');
    if (apiKey != null) {
      header!.putIfAbsent('apikey', () => apiKey!);
    }
    header!.putIfAbsent('Content-Type', () => 'application/json');
    _dio = Dio(options);
    _dio!.interceptors.add(dioInterceptor);
    // final dioPrinter = PrettyDioLogger(requestHeader: true, requestBody: true, responseHeader: true);
    if (logging) {
      _dio!.interceptors.add(dioPrinter);
    } else {
      _dio!.interceptors.remove(dioPrinter);
      // _dio!.interceptors.add(PrettyDioLogger(requestHeader: true, requestBody: false, responseHeader: true));
    }
    // _dio!.interceptors.add(ApiInterceptors());

    _dio!.options.baseUrl = baseUrl;
    _dio!.options.headers = header;
    return this;
  }

  PrettyDioLogger get dioPrinter => PrettyDioLogger(
      requestHeader: true, requestBody: true, responseHeader: true);

  // Client pdfBuilder() {
  //   header = <String, Object>{};
  //   if (apiKey != null) {
  //     header!.putIfAbsent('apikey', () => apiKey!);
  //   }
  //   header!.putIfAbsent('Content-Type', () => 'application/json');

  //   _dio = Dio(options);
  //   _dio!.interceptors.add(dioInterceptor);
  //   _dio!.options.baseUrl = baseUrl;
  //   _dio!.options.headers = header;
  //   return this;
  // }

  // Client simpleBuilder({bool logging = false}) {
  //   header = <String, Object>{};
  //   header!.putIfAbsent('Accept', () => 'application/json');
  //   if (apiKey != null) {
  //     header!.putIfAbsent('apikey', () => apiKey!);
  //   }
  //   header!.putIfAbsent('Content-Type', () => 'application/json');
  //   _dio = Dio(options);
  //   if (!logging) {
  //     // final logger = PrettyDioLogger(requestHeader: true, requestBody: false, responseHeader: true);
  //     // _dio!.interceptors.remove(logger);
  //     _dio!.interceptors.clear(); // _dio!.interceptors.add(dioInterceptor);
  //   }

  //   _dio!.options.baseUrl = "";
  //   _dio!.options.headers = header;
  //   return this;
  // }

  Client setUrlEncoded() {
    // header!.remove('Content-Type');
    // header!.putIfAbsent('Content-Type', () => 'application/x-www-form-urlencoded');
    _dio!.options.headers = header;
    return this;
  }

  // Client removeContentType() {
  //   header!.remove('Content-Type');
  //   return this;
  // }

  // Client removeAndAddAccept() {
  //   header!.remove('Accept');
  //   header!.putIfAbsent("Accept", () => "*/*");
  //   return this;
  // }

  // Client setMultipartFormDataHeader() {
  //   header!.remove('Content-Type');
  //   header!.putIfAbsent('Content-Type', () => 'multipart/form-data');
  //   _dio!.options.headers = header;
  //   return this;
  // }

  Client setProtectedApiHeader() {
    if (token == null) return this;
    header!.putIfAbsent('Authorization', () => 'Bearer $token');
    return this;
  }

  Dio build({bool logging = true}) {
    (_dio!.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    if (!logging) {
      _dio!.interceptors.removeWhere((element) => element is PrettyDioLogger);
    }

    return _dio!;
  }

  Future<Response<T>> get<T>(
    String path, {
    bool logging = true,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    final headers = builder(logging: logging).setProtectedApiHeader();
    final dio = headers.setUrlEncoded().build();
    if (!logging) {
      log('$baseUrl$path');
    }

    return await dio.get(
      baseUrl + path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    final headers = builder().setProtectedApiHeader();
    final dio = headers.setUrlEncoded().build();
    final result = await dio.post<T>(
      baseUrl + path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      data: data,
    );
    // log('$baseUrl$path');
    return result;
  }

  Future<Response<T>> uploadFile<T>(
    String path, {
    required String fileName,
    required File file,
    required List<MapEntry<String, String>> fields,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    final headers = builder().setProtectedApiHeader();
    final dio = headers.setUrlEncoded().build();
    final fromFile =
        await MultipartFile.fromFile(file.path, filename: fileName);
    final FormData formData = FormData.fromMap({"photo": fromFile});
    formData.fields.add(MapEntry("file", fileName));
    formData.fields.addAll(fields);
    final result = await dio.post<T>(
      baseUrl + path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      data: formData,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
    );
    // log('$baseUrl$path');
    return result;
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    final headers = builder().setProtectedApiHeader();
    final dio = headers.setUrlEncoded().build();
    final result = await dio.patch<T>(
      baseUrl + path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      data: data,
    );
    // log('$baseUrl$path');

    return result;
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    final headers = builder().setProtectedApiHeader();
    final dio = headers.setUrlEncoded().build();
    final result = await dio.delete<T>(
      baseUrl + path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      data: data,
    );
    return result;
  }

  InterceptorsWrapper get dioInterceptor => InterceptorsWrapper(
        onRequest: (options, handler) {
          // _firebasePerformanceService.startHttpTracking(options.uri.toString());
          return handler.next(options); //continue
        },
        onResponse: (response, handler) {
          // print("RESPONSE 00 :- " + response.data.length.toString());
          // _firebasePerformanceService.stopHttpTracking(response.statusCode ?? 400);
          return handler.next(response); // continue
        },
        onError: onError ?? _onError,
      );

  void _onError(DioError e, handler) async {
    Response? response = e.response;

    if (response != null) {
      int? statusCode = response.statusCode;

      if (statusCode != null) {
        // print("RESPONSE 11 :- " + _response.data.toString());

        // _firebasePerformanceService.stopHttpTrackingWithError(
        //     responseCode: statusCode);
        if ((statusCode / 100).floor() == 5) {
          // CrashlyticsService _crashlyticsService =
          //     locator<CrashlyticsService>();
          // await _crashlyticsService
          //     .addError(_response.statusMessage ?? "" + " -- " + e.toString());
        } else if ((statusCode / 100).floor() == 4) {
          // BaseModel _baseViewModelAuth = locator<BaseModel>();
          // stackService.DialogService _dilogService = locator<stackService.DialogService>();
          // stackService.NavigationService _navigationService = locator<stackService.NavigationService>();
          // await _baseViewModelAuth.logout();
          // _navigationService.clearStackAndShow(Routes.googleLoginView);
          // await _dilogService.showCustomDialog(variant: dilogenum.failure,title: "Log out",description: "You logged of from cupidknot because of security concern");
        }
      } else {
        // _firebasePerformanceService.stopHttpTrackingWithError();
      }
    } else {
      // _firebasePerformanceService.stopHttpTrackingWithError();
    }

    // return DioExceptions(e);
    return handler.next(e); //continue
  }
}

// FirebasePerformanceService _firebasePerformanceService =
//     locator<FirebasePerformanceService>();

