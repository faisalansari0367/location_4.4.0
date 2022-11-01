// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:api_repo/configs/client.dart';
// import 'package:hive_flutter/adapters.dart';

// import 'envd_repo.dart';

// class EnvdRepoImpl implements EnvdRepo {
//   final Client client;
//   final Box box;
//   EnvdRepoImpl({
//     required this.box,
//     required this.client,
//   });
//   static const envdUrl = 'https://auth-uat.integritysystems.com.au';

//   @override
//   Future<void> getEnvdToken() async {
//     final data = {
//       'client_id': 'itrack',
//       'client_secret': 'u7euFqDzqZzP2T9SmL7Y',
//       'grant_type': 'password',
//       'scope': 'lpa_scope',
//       'username': 'QDZZ3333-2305875',
//       'password': 'Q6qN2VquqqtpkBP!'
//     };
//     final result = await client.build().post(envdUrl + '/connect/token', data: data);
//     final accessToken = result.data['access_token'];
//     print(accessToken);
//   }

//   @override
//   Future<void> getEnvdForms() async {
//     final result = await client.build().post(
//           envdUrl + '/graphql',
//         );
//   }
// }
