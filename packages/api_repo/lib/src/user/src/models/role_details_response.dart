import 'package:api_repo/api_repo.dart';

class RoleDetailsResponse {
  String? status;
  UserData? data;

  RoleDetailsResponse({this.status, this.data});

  RoleDetailsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

// class Data {
//   int? id;
//   String? firstName;
//   String? lastName;
//   String? email;
//   String? phoneNumber;
//   String? countryCode;
//   String? role;
//   String? createdAt;
//   String? updatedAt;
//   String? pic;
//   String? propertyName;
//   String? street;
//   String? town;
//   String? postcode;
//   String? signature;
//   String? logOn;
//   String? employeeNumber;
//   String? driverLicense;
//   String? ddt;
//   String? persons;
//   String? contactDetails;
//   String? reasonForVisit;
//   String? serviceRole;
//   String? ohsRequirements;
//   String? questionnaire;
//   String? rego;
//   String? company;
//   String? picVisiting;
//   String? reason;
//   String? worksafeQuestionsForm;
//   String? address;
//   String? countryOfOrigin;
//   String? countryVisiting;
//   String? entryDate;
//   String? exitDate;
//   String? passport;
//   String? state;

//   Data(
//       {this.id,
//       this.firstName,
//       this.lastName,
//       this.email,
//       this.phoneNumber,
//       this.countryCode,
//       this.role,
//       this.createdAt,
//       this.updatedAt,
//       this.pic,
//       this.propertyName,
//       this.street,
//       this.town,
//       this.postcode,
//       this.signature,
//       this.logOn,
//       this.employeeNumber,
//       this.driverLicense,
//       this.ddt,
//       this.persons,
//       this.contactDetails,
//       this.reasonForVisit,
//       this.serviceRole,
//       this.ohsRequirements,
//       this.questionnaire,
//       this.rego,
//       this.company,
//       this.picVisiting,
//       this.reason,
//       this.worksafeQuestionsForm,
//       this.address,
//       this.countryOfOrigin,
//       this.countryVisiting,
//       this.entryDate,
//       this.exitDate,
//       this.state,
//       this.passport});

//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     firstName = json['firstName'];
//     lastName = json['lastName'];
//     email = json['email'];
//     phoneNumber = json['phoneNumber'];
//     countryCode = json['countryCode'];
//     role = json['role'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     pic = json['pic'];
//     propertyName = json['propertyName'];
//     street = json['street'];
//     town = json['town'];
//     postcode = json['postcode'] == null ? null : json['postcode'].toString();
//     signature = json['signature'];
//     logOn = json['logOn'];
//     employeeNumber = json['employeeNumber'];
//     driverLicense = json['driverLicense'];
//     ddt = json['ddt'];
//     persons = json['persons'];
//     contactDetails = json['contactDetails'];
//     reasonForVisit = json['reasonForVisit'];
//     serviceRole = json['serviceRole'];
//     ohsRequirements = json['ohsRequirements'];
//     questionnaire = json['questionnaire'];
//     rego = json['rego'];
//     company = json['company'];
//     picVisiting = json['picVisiting'];
//     reason = json['reason'];
//     worksafeQuestionsForm = json['worksafeQuestionsForm'];
//     address = json['address'];
//     countryOfOrigin = json['countryOfOrigin'];
//     countryVisiting = json['countryVisiting'];
//     entryDate = json['entryDate'];
//     exitDate = json['exitDate'];
//     passport = json['passport'];
//     state = json['state'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['firstName'] = firstName;
//     data['lastName'] = lastName;
//     data['email'] = email;
//     data['phoneNumber'] = phoneNumber;
//     data['countryCode'] = countryCode;
//     data['role'] = role;
//     data['createdAt'] = createdAt;
//     data['updatedAt'] = updatedAt;
//     data['pic'] = pic;
//     data['propertyName'] = propertyName;
//     data['street'] = street;
//     data['town'] = town;
//     data['postcode'] = postcode;
//     data['signature'] = signature;
//     data['logOn'] = logOn;
//     data['employeeNumber'] = employeeNumber;
//     data['driverLicense'] = driverLicense;
//     data['ddt'] = ddt;
//     data['persons'] = persons;
//     data['contactDetails'] = contactDetails;
//     data['reasonForVisit'] = reasonForVisit;
//     data['state'] = state;
//     data['serviceRole'] = serviceRole;
//     data['ohsRequirements'] = ohsRequirements;
//     data['questionnaire'] = questionnaire;
//     data['rego'] = rego;
//     data['company'] = company;
//     data['picVisiting'] = picVisiting;
//     data['reason'] = reason;
//     data['worksafeQuestionsForm'] = worksafeQuestionsForm;
//     data['address'] = address;
//     data['countryOfOrigin'] = countryOfOrigin;
//     data['countryVisiting'] = countryVisiting;
//     data['entryDate'] = entryDate;
//     data['exitDate'] = exitDate;
//     data['passport'] = passport;
//     return data;
//   }
// }
