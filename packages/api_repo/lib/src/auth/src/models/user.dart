class User {
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  int? id;
  String? role;
  String? createdAt;
  String? updatedAt;

  User(
      {this.firstName,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.id,
      this.role,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    firstName = json[UserKeys.firstName];
    lastName = json[UserKeys.lastName];
    email = json[UserKeys.email];
    phoneNumber = json[UserKeys.phoneNumber];
    id = json['id'];
    role = json[UserKeys.role];
    createdAt = json[UserKeys.createdAt];
    updatedAt = json['updatedAt'];
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
    return data;
  }


  Map<String, dynamic> updateUser() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[UserKeys.firstName] = firstName;
    data[UserKeys.lastName] = lastName;
    data[UserKeys.email] = email;
    data[UserKeys.phoneNumber] = phoneNumber;
    data[UserKeys.role] = role;
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
