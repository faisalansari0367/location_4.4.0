// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final int? id;
  final String? role;
  final String? createdAt;
  final String? updatedAt;
  final String? countryCode;
  final String? registerationToken;

  const User({
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.id,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.countryCode,
    this.registerationToken,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  Map<String, dynamic> updateUser() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data[UserKeys.firstName] = firstName;
    // data[UserKeys.lastName] = lastName;
    // data[UserKeys.email] = email;
    // data[UserKeys.phoneNumber] = phoneNumber;
    if (role != 'Admin') {
      data[UserKeys.role] = role;
    }
    data['registrationToken'] = registerationToken;

    return data;
  }

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props {
    return [
      firstName,
      lastName,
      email,
      phoneNumber,
      id,
      role,
      createdAt,
      updatedAt,
      countryCode,
      registerationToken,
    ];
  }
}

class UserKeys {
  static const firstName = 'firstName',
      lastName = 'lastName',
      email = 'email',
      phoneNumber = 'phoneNumber',
      id = 'id',
      role = 'role',
      createdAt = 'createdAt',
      updatedAt = 'updatedAt';
}

// extension UserkeysExt on UserKeys {
//   String get name {
//     switch (this) {
//       case UserKeys.firstName:
//         return 'firstName';
//       case UserKeys.lastName:
//         return 'lastName';
//       case UserKeys.email:
//         return 'email';
//       case UserKeys.phoneNumber:
//         return 'phoneNumber';
//       case UserKeys.id:
//         return 'id';
//       case UserKeys.role:
//         return 'role';
//       case UserKeys.createdAt:
//         return 'createdAt';
//       case UserKeys.updatedAt:
//         return 'updatedAt';
//     }
//   }
// }
