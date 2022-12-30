// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

enum UserStatus { active, inactive, delete }

extension UserStatusExt on UserStatus {
  Color get color {
    switch (this) {
      case UserStatus.active:
        return Colors.teal;

      case UserStatus.inactive:
        return Colors.orange;
      case UserStatus.delete:
        return Colors.red;
    }
  }
}

class UserData {
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
  int? postcode;
  int? id;
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
  DateTime? startDate;
  DateTime? endDate;
  String? edec;
  String? lpaPassword;
  String? lpaUsername;
  String? nlisPassword;
  String? nlisUsername;
  String? msaNumber;
  String? nfasAccreditationNumber;
  String? countryOfResidency;

  List<String> allowedRoles = const [];
  List<String> cvdForms = const [];

  String? registrationToken;
  DateTime? createdAt, updatedAt;
  UserStatus? status;

  UserData({
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
  });

  static UserStatus getStatus(String? status) {
    final result = UserStatus.values.where((element) => element.name == (status ?? 'inactive').toLowerCase());
    if (result.isEmpty) return UserStatus.inactive;
    return result.first;
  }

  String get fullName => '$firstName $lastName';

  UserData.fromJson(Map<String, dynamic> json) {
    allowedRoles = List<String>.from(json['allowedRoles'] ?? []);
    countryOfResidency = json['countryOfResidency'];
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
    createdAt = json['createdAt'] == null ? null : DateTime.tryParse(json['createdAt'])?.toLocal();
    updatedAt = json['updatedAt'] == null ? null : DateTime.tryParse(json['updatedAt'])?.toLocal();
    businessName = json['businessName'];
    sector = json['sector'];
    contactName = json['contactName'];
    eventName = json['eventName'];
    contactEmail = json['contactEmail'];
    contactNumber = json['contactNumber'];
    startDate = json['startDate'] == null ? null : DateTime.tryParse(json['startDate'])?.toLocal();
    endDate = json['endDate'] == null ? null : DateTime.tryParse(json['endDate'])?.toLocal();
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

    startDate = json['startDate'] == null ? null : DateTime.tryParse(json['startDate'])?.toLocal();
    endDate = json['endDate'] == null ? null : DateTime.tryParse(json['endDate'])?.toLocal();
    edec = json['edec'];
  }

  Map<String, dynamic> updateStatus() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['status'] =
        status!.name.replaceFirst(status!.name.characters.first, status!.name.characters.first.toUpperCase());
    return data;
  }

  Map<String, dynamic> updateAllowedRoles() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['allowedRoles'] = allowedRoles;
    return data;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['allowedRoles'] = allowedRoles;
    data['status'] = status == null
        ? null
        : status!.name.replaceFirst(status!.name.characters.first, status!.name.characters.first.toUpperCase());
    data['firstName'] = firstName;
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
    data['createdAt'] = createdAt?.toIso8601String();
    data['updatedAt'] = updatedAt?.toIso8601String();
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
    data['startDate'] = startDate?.toIso8601String();
    data['endDate'] = endDate?.toIso8601String();
    data['edec'] = edec;

    return data;
  }

  // create a merge constructor
  UserData merge(UserData other) {
    return UserData(
      firstName: other.firstName ?? firstName,
      lastName: other.lastName ?? lastName,
      email: other.email ?? email,
      phoneNumber: other.phoneNumber ?? phoneNumber,
      countryCode: other.countryCode ?? countryCode,
      role: other.role ?? role,
      pic: other.pic ?? pic,
      propertyName: other.propertyName ?? propertyName,
      state: other.state ?? state,
      street: other.street ?? street,
      town: other.town ?? town,
      postcode: other.postcode ?? postcode,
      id: other.id ?? id,
      signature: other.signature ?? signature,
      logOn: other.logOn ?? logOn,
      employeeNumber: other.employeeNumber ?? employeeNumber,
      driversLicense: other.driversLicense ?? driversLicense,
      ddt: other.ddt ?? ddt,
      persons: other.persons ?? persons,
      contactDetails: other.contactDetails ?? contactDetails,
      reasonForVisit: other.reasonForVisit ?? reasonForVisit,
      serviceRole: other.serviceRole ?? serviceRole,
      ohsRequirements: other.ohsRequirements ?? ohsRequirements,
      questionnaire: other.questionnaire ?? questionnaire,
      region: other.region ?? region,
      company: other.company ?? company,
      picVisiting: other.picVisiting ?? picVisiting,
      reason: other.reason ?? reason,
      worksafeQuestionsForm: other.worksafeQuestionsForm ?? worksafeQuestionsForm,
      countryOfOrigin: other.countryOfOrigin ?? countryOfOrigin,
      countryVisiting: other.countryVisiting ?? countryVisiting,
      entryDate: other.entryDate ?? entryDate,
      exitDate: other.exitDate ?? exitDate,
      passport: other.passport ?? passport,
      ngr: other.ngr ?? ngr,
      businessName: other.businessName ?? businessName,
      sector: other.sector ?? sector,
      contactName: other.contactName ?? contactName,
      eventName: other.eventName ?? eventName,
      contactEmail: other.contactEmail ?? contactEmail,
      contactNumber: other.contactNumber ?? contactNumber,
      startDate: other.startDate ?? startDate,
      endDate: other.endDate ?? endDate,
      edec: other.edec ?? edec,
      lpaPassword: other.lpaPassword ?? lpaPassword,
      lpaUsername: other.lpaUsername ?? lpaUsername,
      nlisPassword: other.nlisPassword ?? nlisPassword,
    );
  }
}
