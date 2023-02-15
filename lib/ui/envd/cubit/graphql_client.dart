import 'dart:developer';

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/api_constants.dart';
import 'package:bioplus/ui/add_pic/add_pic.dart';
import 'package:bioplus/ui/envd/cubit/graphql_storage.dart';
import 'package:bioplus/widgets/dialogs/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive_flutter/adapters.dart';

class GraphQlClient {
  static final HttpLink _httpLink = HttpLink(ApiConstants.envdGraphQl);

  static final _instance = GraphQlClient._();
  // late UserData _userData;

  static late String? lpaUsername;
  static late String? lpaPassword;

  factory GraphQlClient({
    required String? username,
    required String? password,
  }) {
    lpaUsername = username;
    lpaPassword = password;
    return _instance;
  }

  GraphQlClient._() {
    init(lpaUsername, lpaPassword);
  }

  late Dio dio = Dio();
  late Box<Map<dynamic, dynamic>?> box;
  late HiveStore hiveStore;
  late GrahphQlStorage storage;

  String? token;

  Future<void> initStorage() async {
    await initHiveForFlutter();
    hiveStore = await HiveStore.open();
  }

  Future<void> clearStorage() async {
    await initStorage();
    await hiveStore.reset();
  }

  Future<bool> init(String? username, String? password) async {
    await initStorage();
    storage = GrahphQlStorage(box: hiveStore.box);
    token = await _getEnvdToken(username, password);
    if (token == null) {
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

  bool _isNull(String? value) {
    return value == null || value.isEmpty;
  }

  bool hasCredentials() {
    if (_isNull(lpaUsername) || _isNull(lpaPassword)) {
      return false;
    } else {
      return true;
    }
  }

  Future<String?> _getEnvdToken(String? username, String? password) async {
    try {
      if (isTokenValid()) {
        return 'Bearer ${storage.getToken()!.accessToken}';
      }
      if (_isNull(username) || _isNull(password)) {
        return null;
      }
      final result = await getEnvdToken();
      final tokenData = await storage.saveToken(result);
      log(tokenData.accessToken);
      return 'Bearer ${tokenData.accessToken}';
    } catch (e) {
      rethrow;
    }
    // return null;
  }

  Future<bool> validateCreds(PicModel pic) async {
    if (!hasCredentials()) {
      const message =
          "Please provide valid LPA credentials in your PIC details to use this feature.";
      await Get.dialog(
        StatusDialog(
          lottieAsset: 'assets/animations/error.json',
          message: message,
          onContinue: () async {
            Get.back();
            Get.to(
              () => AddPicPage(
                pic: pic,
                updatePic: true,
              ),
            );
          },
        ),
      );
      return false;
    }
    return true;
  }

  // Future<void> redirect() async {
  //   final isInit = await init();
  //   final isCredsValid = await validateCreds();
  //   if (!isCredsValid) return;
  //   if (isInit) {
  //     Get.to(() => const EnvdPage());
  //   } else {
  //     DialogService.error(
  //       "Unable to connect with the ISC server currently. Please try again later.",
  //     );
  //   }
  // }

  // Map<String, dynamic> _itrackClientUAT() {
  //   return {
  //     'client_id': 'itrack',
  //     'client_secret': 'u7euFqDzqZzP2T9SmL7Y',
  //     'grant_type': 'password',
  //     'scope': 'lpa_scope',
  //   };
  // }

  Future<dynamic> getEnvdToken() async {
    try {
      final userCreds = <String, dynamic>{
        'username': lpaUsername,
        'password': lpaPassword,
      };

      userCreds.addAll(ApiConstants.itrackCientUAT);

      final result = await dio.post(
        ApiConstants.envdTokenUrl,
        data: userCreds,
        options: Options(headers: _headers),
      );

      log(result.toString());

      return result.data;
    } on DioError catch (e) {
      log(e.toString());
      final response = e.response?.data['error'];
      if (response != null) {
        if (response == 'invalid_client') {
          DialogService.error('$response \n Please contact support');
        }
      } else {
        DialogService.error('Something went wrong');
      }
      rethrow;
    }
  }

  Map<String, dynamic> get _headers {
    return {
      'Content-Type': 'application/x-www-form-urlencoded',
      // 'Content-Type': 'application/json',
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
