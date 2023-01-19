import 'dart:io';

// ignore: unused_import
import 'package:flutter/foundation.dart';

// ignore: avoid_classes_with_only_static_members
class ApiConstants {
  static const String localUrl = 'http://13.55.174.146:3000';
  static const String liveUrl = 'https://app.itrakassets.com';
  static const String localhost = 'http://localhost:3000';

  static const playStoreid = 'https://play.google.com/store/apps/details?id=com.itrakassets.bioplus';
  static const appStoreid = 'https://apps.apple.com/au/app/bioplus/id6444330345';

  static String get appLink => Platform.isAndroid ? playStoreid : appStoreid;

  static const envdGraphQl = 'https://api.uat.integritysystems.com.au/graphql';
  static const _envdUATUrl = 'https://auth-uat.integritysystems.com.au/connect/token';

  static Map<String, dynamic> get itrackCientUAT => {
        'client_id': 'itrack',
        'client_secret': 'u7euFqDzqZzP2T9SmL7Y',
        'grant_type': 'password',
        'scope': 'lpa_scope',
      };

  static String get envdTokenUrl => _envdUATUrl;

  static bool get isDegugMode => baseUrl == localUrl;
  static const String baseUrl = kDebugMode ? localUrl : liveUrl;
  // static const String baseUrl = liveUrl;

  static const String mapsKey = 'AIzaSyBxMIupdGzYQM6yk1ix1xGhgIyPw_42wlI';
}
