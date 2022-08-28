// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:api_repo/api_repo.dart';

class UsersResponseModel {
  final List<UserData> users;
  UsersResponseModel({
    required this.users,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'users': users.map((x) => x.toJson()).toList(),
    };
  }

  // factory UsersResponseModel.fromMap(Map<String, dynamic> map) {
  //   return UsersResponseModel(
  //     users: List<UserData>.from(
  //       (map['users'] as List<int>).map<UserData>(
  //         (x) => UserData.fromMap(x as Map<String, dynamic>),
  //       ),
  //     ),
  //   );
  // }

  // String toJson() => (toMap());

  factory UsersResponseModel.fromJson(Map<String, dynamic> map) {
    return UsersResponseModel(
      users: List<UserData>.from(
        (map['users']).map<UserData>(
          (x) => UserData.fromJson(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}
