// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

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

class UserData {
  int? postcode;
  int? id;
  String? firstName;
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
  String? signature;
  String? logOn;
  String? employeeNumber;
  String? driversLicense;
  String? ddt;
  String? persons;
  String? contactDetails;
  String? reasonForVisit;
  String? serviceRole;
  String? ohsRequirements;
  String? questionnaire;
  String? region;
  String? company;
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
  String? emergencyMobileContact;

  dynamic stripeCusId;
  int? geofenceLimit;
  bool isSubscribed = false;
  DateTime? subscriptionStartDate;
  DateTime? subscriptionEndDate;

  DateTime? startDate;
  DateTime? endDate;
  DateTime? delegationStartDate;
  DateTime? delegationEndDate;
  DateTime? createdAt;
  DateTime? updatedAt;

  List<String> allowedRoles = const [];
  List<String> species = const <String>[];
  List<String> cvdForms = const [];

  String? registrationToken;
  UserStatus? status;

  UserData({
    this.species = const <String>[],
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
    this.serviceRole,
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
    this.passport,
    this.ngr,
    this.businessName,
    this.sector,
    this.contactName,
    this.eventName,
    this.contactEmail,
    this.contactNumber,
    this.cvdForms = const [],
    this.startDate,
    this.endDate,
    this.edec,
    this.allowedRoles = const [],
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
    this.isSubscribed = false,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
    this.createdAt,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    species = List<String>.from(json['species'] ?? []);
    employerCompany = json['employerCompany'] ?? '';
    temporaryOwner = json['temporaryOwner'];
    allowedRoles = List<String>.from(json['allowedRoles'] ?? []);
    countryOfResidency = json['countryOfResidency'];
    emergencyMobileContact = json['emergencyMobileContact'];

    status = getStatus(json['status']);
    ngr = json['ngr'];
    cvdForms = json['cvdForms'] ?? [];

    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    countryCode = json['countryCode'];
    role = json['role'];
    pic = json['pic'];
    propertyName = json['propertyName'];
    state = json['state'];
    street = json['street'];
    town = json['town'];
    postcode = int.tryParse(json['postcode'].toString());
    signature = json['signature'];
    logOn = json['logOn'];
    employeeNumber = json['employeeNumber'];
    driversLicense = json['driversLicense'];
    ddt = json['ddt'];
    persons = json['persons'];
    contactDetails = json['contactDetails'];
    reasonForVisit = json['reasonForVisit'];
    serviceRole = json['serviceRole'];
    ohsRequirements = json['ohsRequirements'];
    questionnaire = json['questionnaire'];
    region = json['region'];
    company = json['company'];
    picVisiting = json['picVisiting'];
    reason = json['reason'];
    worksafeQuestionsForm = json['worksafeQuestionsForm'];
    countryOfOrigin = json['countryOfOrigin'];
    countryVisiting = json['countryVisiting'];
    entryDate = json['entryDate'];
    exitDate = json['exitDate'];
    passport = json['passport'];
    registrationToken = json['registrationToken'];
    businessName = json['businessName'];
    sector = json['sector'];
    contactName = json['contactName'];
    eventName = json['eventName'];
    contactEmail = json['contactEmail'];
    contactNumber = json['contactNumber'];
    edec = json['edec'];

    lpaUsername = json['lpaUsername'];
    lpaPassword = json['lpaPassword'];
    nlisUsername = json['nlisUsername'];
    nlisPassword = json['nlisPassword'];
    msaNumber = json['msaNumber'];
    nfasAccreditationNumber = json['nfasAccreditationNumber'];
    businessName = json['businessName'];
    sector = json['sector'];
    contactName = json['contactName'];
    eventName = json['eventName'];
    contactEmail = json['contactEmail'];
    contactNumber = json['contactNumber'];

    edec = json['edec'];
    stripeCusId = json['stripeCusId'];
    geofenceLimit = json['geofenceLimit'];
    isSubscribed = json['isSubscribed'] ?? false;

    subscriptionStartDate = _parseDate(json['subscriptionStartDate']);
    subscriptionEndDate = _parseDate(json['subscriptionEndDate']);
    createdAt = _parseDate(json['createdAt']);
    updatedAt = _parseDate(json['updatedAt']);
    startDate = _parseDate(json['startDate']);
    endDate = _parseDate(json['endDate']);
    startDate = _parseDate(json['startDate']);
    endDate = _parseDate(json['endDate']);
    delegationEndDate = _parseDate(json['delegationEndDate']);
    delegationStartDate = _parseDate(json['delegationStartDate']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['species'] = List<String>.from(species);
    data['employerCompany'] = employerCompany;
    data['allowedRoles'] = allowedRoles;
    data['status'] = status == null
        ? null
        : status!.name.replaceFirst(status!.name.characters.first,
            status!.name.characters.first.toUpperCase());
    data['firstName'] = firstName;
    data['emergencyMobileContact'] = emergencyMobileContact;
    data['lastName'] = lastName;
    data['countryOfResidency'] = countryOfResidency;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['id'] = id;
    data['countryCode'] = countryCode;
    data['role'] = role;
    data['pic'] = pic;
    data['propertyName'] = propertyName;
    data['state'] = state;
    data['street'] = street;
    data['town'] = town;
    data['postcode'] = postcode;
    data['signature'] = signature;
    data['logOn'] = logOn;
    data['employeeNumber'] = employeeNumber;
    data['driversLicense'] = driversLicense;
    data['ddt'] = ddt;
    data['persons'] = persons;
    data['contactDetails'] = contactDetails;
    data['reasonForVisit'] = reasonForVisit;
    data['serviceRole'] = serviceRole;
    data['ohsRequirements'] = ohsRequirements;
    data['questionnaire'] = questionnaire;
    data['region'] = region;
    data['company'] = company;
    data['picVisiting'] = picVisiting;
    data['reason'] = reason;
    data['worksafeQuestionsForm'] = worksafeQuestionsForm;
    data['countryOfOrigin'] = countryOfOrigin;
    data['countryVisiting'] = countryVisiting;
    data['entryDate'] = entryDate;
    data['exitDate'] = exitDate;
    data['passport'] = passport;
    data['registrationToken'] = registrationToken;

    data['ngr'] = ngr;

    data['lpaUsername'] = lpaUsername;
    data['lpaPassword'] = lpaPassword;

    data['nlisUsername'] = nlisUsername;
    data['nlisPassword'] = nlisPassword;

    data['msaNumber'] = msaNumber;
    data['nfasAccreditationNumber'] = nfasAccreditationNumber;

    data['businessName'] = businessName;
    data['sector'] = sector;
    data['contactName'] = contactName;
    data['eventName'] = eventName;
    data['contactEmail'] = contactEmail;
    data['contactNumber'] = contactNumber;
    data['edec'] = edec;

    data['stripeCusId'] = stripeCusId;
    data['geofenceLimit'] = geofenceLimit;
    data['isSubscribed'] = isSubscribed;
    data['subscriptionStartDate'] = subscriptionStartDate?.toIso8601String();
    data['subscriptionEndDate'] = subscriptionEndDate?.toIso8601String();

    data['createdAt'] = createdAt?.toIso8601String();
    data['updatedAt'] = updatedAt?.toIso8601String();
    data['startDate'] = startDate?.toIso8601String();
    data['endDate'] = endDate?.toIso8601String();
    data['delegationStartDate'] = delegationStartDate?.toIso8601String();
    data['delegationEndDate'] = delegationEndDate?.toIso8601String();
    data['temporaryOwner'] = temporaryOwner;

    return data;
  }

  static _parseDate(String? date) {
    if (date == null) return null;
    return DateTime.tryParse(date)?.toLocal();
  }

  static UserStatus getStatus(String? status) {
    final result = UserStatus.values.where(
        (element) => element.name == (status ?? 'inactive').toLowerCase());
    if (result.isEmpty) return UserStatus.inactive;
    return result.first;
  }

  String get fullName => '$firstName $lastName';
  bool get isTemporaryOwner =>
      temporaryOwner != null && temporaryOwner!.isNotEmpty;

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
