// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_data.g.dart';

enum UserStatus { active, inactive, delete, unknown }

extension UserStatusExt on UserStatus {
  Color get color {
    switch (this) {
      case UserStatus.active:
        return Colors.teal;
      case UserStatus.inactive:
        return Colors.orange;
      case UserStatus.delete:
        return Colors.red;
      case UserStatus.unknown:
        return Colors.grey;
    }
  }
}

@JsonSerializable()
class UserData {
  @JsonKey(fromJson: _parseInt)
  int? postcode;
  int? id;
  String? firstName;
  String? logo;
  String? rego;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? countryCode;
  String? role;
  String? pic;
  String? propertyName;
  String? state;
  String? street;
  String? town;
  String? city;
  String? signature;
  String? logOn;
  String? employeeNumber;
  String? driversLicense;
  String? ddt;
  String? persons;
  String? contactDetails;
  String? reasonForVisit;
  // String? serviceRole;
  String? ohsRequirements;
  String? questionnaire;
  String? location;
  String? region;
  List<String>? company;
  String? picVisiting;
  String? reason;
  String? worksafeQuestionsForm;
  String? countryOfOrigin;
  String? countryVisiting;
  String? entryDate;
  String? exitDate;
  String? passport;
  String? ngr;
  String? businessName;
  String? sector;
  String? contactName;
  String? eventName;
  String? contactEmail;
  String? contactNumber;
  String? edec;
  String? lpaPassword;
  String? lpaUsername;
  String? nlisPassword;
  String? nlisUsername;
  String? msaNumber;
  String? nfasAccreditationNumber;
  String? countryOfResidency;
  String? employerCompany;
  String? temporaryOwner;

  bool? isTemporaryOwner;

  String? emergencyMobileContact;
  String? emergencyEmailContact;
  String? stripeCusId;
  String? officeName;
  String? titleName;
  int? geofenceLimit;

  bool? isSubscribed;

  List<String>? allowedRoles;

  List<String>? species;

  List<String>? cvdForms;

  String? registrationToken;

  @JsonKey(fromJson: getStatus, toJson: statusToJson)
  UserStatus? status;

  @JsonKey(fromJson: _parseDate)
  DateTime? subscriptionStartDate;

  @JsonKey(fromJson: _parseDate)
  DateTime? subscriptionEndDate;

  @JsonKey(fromJson: _parseDate)
  DateTime? startDate;

  @JsonKey(fromJson: _parseDate)
  DateTime? endDate;

  @JsonKey(fromJson: _parseDate)
  DateTime? delegationStartDate;

  @JsonKey(fromJson: _parseDate)
  DateTime? delegationEndDate;

  @JsonKey(fromJson: _parseDate)
  DateTime? createdAt;

  @JsonKey(fromJson: _parseDate)
  DateTime? updatedAt;

  UserData({
    this.species,
    this.employerCompany,
    this.emergencyMobileContact,
    this.temporaryOwner,
    this.delegationEndDate,
    this.delegationStartDate,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.countryCode,
    this.role,
    this.countryOfResidency,
    this.pic,
    this.propertyName,
    this.state,
    this.street,
    this.town,
    this.postcode,
    this.id,
    this.signature,
    this.logOn,
    this.employeeNumber,
    this.driversLicense,
    this.ddt,
    this.persons,
    this.contactDetails,
    this.reasonForVisit,
    // this.serviceRole,
    this.ohsRequirements,
    this.questionnaire,
    this.region,
    this.company,
    this.picVisiting,
    this.reason,
    this.worksafeQuestionsForm,
    this.countryOfOrigin,
    this.countryVisiting,
    this.entryDate,
    this.exitDate,
    this.logo,
    this.passport,
    this.ngr,
    this.businessName,
    this.sector,
    this.contactName,
    this.eventName,
    this.rego,
    this.contactEmail,
    this.contactNumber,
    this.cvdForms,
    this.startDate,
    this.endDate,
    this.edec,
    this.allowedRoles,
    this.registrationToken,
    this.updatedAt,
    this.status,
    this.lpaUsername,
    this.lpaPassword,
    this.nlisUsername,
    this.nlisPassword,
    this.msaNumber,
    this.nfasAccreditationNumber,
    this.stripeCusId,
    this.geofenceLimit,
    this.isSubscribed,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
    this.createdAt,
    this.emergencyEmailContact,
    this.isTemporaryOwner,
    this.city,
    this.location,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return _$UserDataFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UserDataToJson(this);
  }

  static _parseInt(dynamic value) => int.tryParse(value.toString());

  static _parseDate(String? date) {
    if (date == null) return null;
    return DateTime.tryParse(date)?.toLocal();
  }

  String get companies => (company ?? []).join(', ');

  static UserStatus getStatus(String? status) {
    final result = UserStatus.values.where(
        (element) => element.name == (status ?? 'inactive').toLowerCase());
    if (result.isEmpty) return UserStatus.inactive;
    return result.first;
  }

  static statusToJson(UserStatus? status) {
    if (status == null) return null;
    return status.name.replaceFirst(status.name.characters.first,
        status.name.characters.first.toUpperCase());
  }

  String get fullName => '$firstName $lastName';

  Map<String, dynamic> updateStatus() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['status'] = status!.name.replaceFirst(status!.name.characters.first,
        status!.name.characters.first.toUpperCase());
    return data;
  }

  Map<String, dynamic> updateAllowedRoles() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['allowedRoles'] = allowedRoles;
    return data;
  }
}
