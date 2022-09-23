// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

// import 'package:auth_repo/src/auth_repo_impl.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

// import '../repositories/auth/auth_repository.dart';
import 'api_logger.dart';

class Client {
  // String baseUrl = '';
  // String apiKey = '';
  final String baseUrl;
  String? token;
  final String? apiKey;

  Dio? _dio;

  BaseOptions options = BaseOptions(
    connectTimeout: 1000 * 300,
    receiveTimeout: 1000 * 300,
  );

  // String? token;
  Map<String, Object>? header;
  Client({
    required this.baseUrl,
    this.token,
    this.apiKey,
    this.header,
  });

  // Client({this.token, this.baseUrl});

  Client builder() {
    header = <String, Object>{};
    header!.putIfAbsent('Accept', () => 'application/json');
    if (apiKey != null) {
      header!.putIfAbsent('apikey', () => apiKey!);
    }
    header!.putIfAbsent('Content-Type', () => 'application/json');
    _dio = Dio(options);
    _dio!.interceptors
        .add(PrettyDioLogger(requestHeader: true, requestBody: true, responseHeader: true));
    // .add(ApiInterceptors());

    _dio!.options.baseUrl = baseUrl;
    _dio!.options.headers = header;
    return this;
  }

  Client pdfBuilder() {
    header = <String, Object>{};
    if (apiKey != null) {
      header!.putIfAbsent('apikey', () => apiKey!);
    }
    header!.putIfAbsent('Content-Type', () => 'application/json');

    _dio = Dio(options);
    _dio!.interceptors.add(dioInterceptor);
    _dio!.options.baseUrl = baseUrl;
    _dio!.options.headers = header;
    return this;
  }

  Client simpleBuilder() {
    header = <String, Object>{};
    header!.putIfAbsent('Accept', () => 'application/json');
    if (apiKey != null) {
      header!.putIfAbsent('apikey', () => apiKey!);
    }
    header!.putIfAbsent('Content-Type', () => 'application/json');
    _dio = Dio(options);
    _dio!.interceptors.add(dioInterceptor);
    _dio!.interceptors
        .add(PrettyDioLogger(requestHeader: true, requestBody: true, responseHeader: true));

    _dio!.options.baseUrl = "";
    _dio!.options.headers = header;
    return this;
  }

  Client setUrlEncoded() {
    header!.remove('Content-Type');
    header!.putIfAbsent('Content-Type', () => 'application/x-www-form-urlencoded');
    _dio!.options.headers = header;
    return this;
  }

  Client removeContentType() {
    header!.remove('Content-Type');
    return this;
  }

  Client removeAndAddAccept() {
    header!.remove('Accept');
    header!.putIfAbsent("Accept", () => "*/*");
    return this;
  }

  Client setMultipartFormDataHeader() {
    header!.remove('Content-Type');
    header!.putIfAbsent('Content-Type', () => 'multipart/form-data');
    _dio!.options.headers = header;
    return this;
  }

  Client setProtectedApiHeader() {
    // final authRepository = AuthRepoImpl(_client);
    // final token = StorageService(box: ).getToken();
    if (token == null) return this;
    header!.putIfAbsent('Authorization', () => 'Bearer $token');
    return this;
  }

  Dio build() {
    // print("DIO IS CALLING");

    (_dio!.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    return _dio!;
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    final headers = builder().setProtectedApiHeader();
    final dio = headers.setUrlEncoded().build();
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
}

// FirebasePerformanceService _firebasePerformanceService =
//     locator<FirebasePerformanceService>();

InterceptorsWrapper dioInterceptor = InterceptorsWrapper(
  onRequest: (options, handler) {
    // _firebasePerformanceService.startHttpTracking(options.uri.toString());
    return handler.next(options); //continue
  },
  onResponse: (response, handler) {
    print("RESPONSE 00 :- " + response.data.length.toString());
    // _firebasePerformanceService.stopHttpTracking(response.statusCode ?? 400);
    return handler.next(response); // continue
  },
  onError: (DioError e, handler) async {
    Response? _response = e.response;

    if (_response != null) {
      int? statusCode = _response.statusCode;

      if (statusCode != null) {
        print("RESPONSE 11 :- " + _response.data.toString());

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
  },
);
