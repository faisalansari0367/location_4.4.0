import 'dart:developer';

import 'package:api_repo/api_repo.dart';
import 'package:api_repo/configs/client.dart';
import 'package:background_location/ui/envd/cubit/graphql_storage.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive_flutter/adapters.dart';

class GraphQlClient {
  static const _envdUrl = 'https://auth-uat.integritysystems.com.au';
  static final HttpLink _httpLink = HttpLink('https://api.uat.integritysystems.com.au/graphql');

  static final _instance = GraphQlClient._();
  late UserData _userData;

  GraphQlClient._();

  factory GraphQlClient({UserData? userData}) {
    if (userData != null) {
      _instance._userData = userData;
    }

    return _instance;
  }

  late Dio dio = Dio();
  late Box<Map<dynamic, dynamic>?> box;
  late HiveStore hiveStore;
  late GrahphQlStorage storage;

  String? token;

  // static const accessToken =
  //     'eyJhbGciOiJSUzI1NiIsImtpZCI6IjJlN2YwYmQwYzk5OTcxMzdjYmYzZmE5MmQ0YjUzOTkyIiwidHlwIjoiSldUIn0.eyJuYmYiOjE2NjcyODQ3MzUsImV4cCI6MTY2NzM3MTEzNSwiaXNzIjoiaHR0cHM6Ly9hdXRoLXVhdC5pbnRlZ3JpdHlzeXN0ZW1zLmNvbS5hdSIsImF1ZCI6WyJodHRwczovL2F1dGgtdWF0LmludGVncml0eXN5c3RlbXMuY29tLmF1L3Jlc291cmNlcyIsImxwYSJdLCJjbGllbnRfaWQiOiJpdHJhY2siLCJzdWIiOiJRRFpaMzMzMy0yMzA1ODc1IiwiYXV0aF90aW1lIjoxNjY3Mjg0NzM1LCJpZHAiOiJsb2NhbCIsIlVUQyI6IjEvMTEvMjAyMiA2OjQzOjMxIEFNIiwiUElDIjoiUURaWjMzMzMiLCJVc2VySWQiOiIyMzA1ODc1IiwiTFBBIjoiQSIsIkVudGl0eU5hbWUiOiJFTlZEIFRlc3QiLCJMb2NhdGlvbkFkZHJlc3MiOiI0MCBNT1VOVCBTVCIsIkxvY2F0aW9uVG93biI6Ik5PUlRIIFNZRE5FWSIsIkxvY2F0aW9uU3RhdGUiOiJOU1ciLCJMb2NhdGlvblBvc3Rjb2RlIjoiMjA2MCIsIkdpdmVuTmFtZSI6IlBldGVyIiwiU3VybmFtZSI6IlF1aWdsZXkiLCJFVSI6IllFUyIsIk1TQSI6Ik5PIiwiTVNBTWVtYmVyTnVtIjoiTk9ORSIsIkVVR0ZIUUIiOiJZRVMiLCJORkFTIjoiWUVTIiwic2NvcGUiOlsibHBhX3Njb3BlIl0sImFtciI6WyJwd2QiXX0.H9F680h7g7gtxeoEFDymfanVM-YrfA0ZjiAljtY-A-jykrEBpqHHIi7olvd2Rn6oHlOj-x3upxd7M50DvNTaH8LEm4_AoSZZRWc90A3UbUmq77Gua-tVZKKaSX_x_olTQD6MLFN4janZedn-dF-FUXxGNdkn7JVGcFz1jyFv2Z53A4peEUL6tHvptMsPPitYV4p6zXA5LsqsJDDry6mwQtAq3SxXbfICHv5IYCPrnwn-oiZpFP2IH4ed-9CvmEekYG04C3CpIt5r9IijbAa1zaQB-gr-twS5aP_cV4yrCX3LFtX9raIIpPKeyszaAcZzF7xW7MmiWC30Fbe-BPpIxw';

  // GraphQlClient() {
  //   init();/
  // }

  Future<bool> init() async {
    await initHiveForFlutter();
    hiveStore = await HiveStore.open();
    storage = GrahphQlStorage(box: hiveStore.box);
    token = await _getEnvdToken();
    if (token == null) {
      DialogService.error(
        "Unable to connect with the MLA server currently. Please try again later.",
      );
      return false;
    }
    return true;
  }

  bool isTokenValid() {
    final map = storage.getToken();
    if (map == null) {
      return false;
    }
    final duration = DateTime.now().difference(map.createdAt).inSeconds;
    return duration < map.expiresIn;
  }

  Future<String?> _getEnvdToken() async {
    try {
      if (isTokenValid()) {
        return 'Bearer ${storage.getToken()!.accessToken}';
      }
      final result = await getEnvdToken(_userData.lpaUsername!, _userData.lpaPassword!);
      // final data = {
      //   'client_id': 'itrack',
      //   'client_secret': 'u7euFqDzqZzP2T9SmL7Y',
      //   'grant_type': 'password',
      //   'scope': 'lpa_scope',
      //   'username': _userData.lpaUsername,
      //   'password': _userData.lpaPassword,
      // };
      // final url = 'https://auth-uat.integritysystems.com.au/connect/token';
      // final result = await dio.post(
      //   url,
      //   data: data,
      //   options: Options(headers: _headers),
      // );
      final tokenData = await storage.saveToken(result.data);
      log(tokenData.accessToken);
      return 'Bearer ${tokenData.accessToken}';
    } catch (e) {
      rethrow;
    }
    // return null;
  }

  Future<dynamic> getEnvdToken(String lpaUsername, String lpaPassword) async {
    try {
      final data = {
        'client_id': 'itrack',
        'client_secret': 'u7euFqDzqZzP2T9SmL7Y',
        'grant_type': 'password',
        'scope': 'lpa_scope',
        'username': lpaUsername,
        'password': lpaPassword,
      };
      final url = 'https://auth-uat.integritysystems.com.au/connect/token';
      final result = await dio.post(
        url,
        data: data,
        options: Options(headers: _headers),
      );

      log(result.toString());

      return result.data;
    } catch (e) {
      log(e.toString());

      rethrow;
    }
  }

  Map<String, dynamic> get _headers {
    return {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
  }

  AuthLink get authLink => AuthLink(getToken: () => 'Bearer $token');

  ValueNotifier<GraphQLClient> get client => ValueNotifier(
        GraphQLClient(
          link: authLink.concat(_httpLink),
          cache: GraphQLCache(store: hiveStore),
        ),
      );
}
