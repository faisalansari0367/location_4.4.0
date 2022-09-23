// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  int? id;
  String? role;
  String? createdAt;
  String? updatedAt;
  String? countryCode;
  String? registerationToken;

  User({
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

  User.fromJson(Map<String, dynamic> json) {
    firstName = json[UserKeys.firstName];
    lastName = json[UserKeys.lastName];
    email = json[UserKeys.email];
    phoneNumber = json[UserKeys.phoneNumber];
    id = json['id'];
    role = json[UserKeys.role];
    createdAt = json[UserKeys.createdAt];
    updatedAt = json['updatedAt'];
    countryCode = json['countryCode'];
    registerationToken = json['registrationToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[UserKeys.firstName] = firstName;
    data[UserKeys.lastName] = lastName;
    data[UserKeys.email] = email;
    data[UserKeys.phoneNumber] = phoneNumber;
    data[UserKeys.id] = id;
    data[UserKeys.role] = role;
    data[UserKeys.createdAt] = createdAt;
    data[UserKeys.updatedAt] = updatedAt;
    data['countryCode'] = countryCode;
    data['registrationToken'] = registerationToken;
    return data;
  }

  Map<String, dynamic> updateUser() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data[UserKeys.firstName] = firstName;
    // data[UserKeys.lastName] = lastName;
    // data[UserKeys.email] = email;
    // data[UserKeys.phoneNumber] = phoneNumber;
    data[UserKeys.role] = role;
    data['registrationToken'] = registerationToken;

    return data;
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
