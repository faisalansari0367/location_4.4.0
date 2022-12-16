// ignore_for_file: public_member_api_docs, sort_constructors_first
class SignUpModel {
  String? firstName;
  String? lastName;
  String? email;
  int? phoneNumber;
  String? password;
  String? countryCode;
  String? countryOfResidency;

  SignUpModel({
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.countryOfResidency,
    this.password,
    this.countryCode,
  });

  SignUpModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    password = json['password'];
    countryCode = json['countryCode'];
    countryOfResidency = json['countryOfResidency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName?.trim();
    data['countryOfResidency'] = countryOfResidency?.trim();
    data['lastName'] = lastName?.trim();
    data['email'] = email?.trim();
    data['phoneNumber'] = phoneNumber.toString();
    data['password'] = password?.trim();
    data['countryCode'] = countryCode?.trim();
    return data;
  }
}
