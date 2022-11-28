import 'package:flutter/foundation.dart';

class ApiConstants {
  static const localUrl = 'http://13.55.174.146:3000';
  static const liveUrl = 'https://app.itrakassets.com';
  // static const devBaseUrl = 'http://13.55.174.146:3001';

  static const baseUrl = kDebugMode ? localUrl : liveUrl;
  //

  static const mapsKey = 'AIzaSyBxMIupdGzYQM6yk1ix1xGhgIyPw_42wlI';
}
