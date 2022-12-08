class ApiConstants {
  static const String localUrl = 'http://13.55.174.146:3000';
  static const String liveUrl = 'https://app.itrakassets.com';

  // prdocution envd token url
  static const _envdProdUrl = 'https://auth.integritysystems.com.au/connect/token';

  // production envd graphql url
  static const envdGraphQl = 'https://api.integritysystems.com.au/graphql';

  // uat envd token url
  static const _envdUATUrl = 'https://auth-uat.integritysystems.com.au/connect/token';

  static Map<String, dynamic> get itrackCientUAT {
    return {
      'client_id': 'itrack',
      'client_secret': 'u7euFqDzqZzP2T9SmL7Y',
      'grant_type': 'password',
      'scope': 'lpa_scope',
    };
  }

  static String get envdTokenUrl => _envdProdUrl;

  // static const String baseUrl = kDebugMode ? localUrl : liveUrl;
  static const String baseUrl = liveUrl;

  static const String mapsKey = 'AIzaSyBxMIupdGzYQM6yk1ix1xGhgIyPw_42wlI';
}
