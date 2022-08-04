class SignUpModel {
  String? firstName;
  String? lastName;
  String? email;
  int? phoneNumber;
  String? password;

  SignUpModel({
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.password,
  });

  SignUpModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName?.trim();
    data['lastName'] = lastName?.trim();
    data['email'] = email?.trim();
    data['phoneNumber'] = phoneNumber;
    data['password'] = password?.trim();
    return data;
  }
}
