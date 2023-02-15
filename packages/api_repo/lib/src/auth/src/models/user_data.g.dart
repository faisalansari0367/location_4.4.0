// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      species:
          (json['species'] as List<dynamic>?)?.map((e) => e as String).toList(),
      employerCompany: json['employerCompany'] as String?,
      emergencyMobileContact: json['emergencyMobileContact'] as String?,
      temporaryOwner: json['temporaryOwner'] as String?,
      delegationEndDate:
          UserData._parseDate(json['delegationEndDate'] as String?),
      delegationStartDate:
          UserData._parseDate(json['delegationStartDate'] as String?),
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      countryCode: json['countryCode'] as String?,
      role: json['role'] as String?,
      countryOfResidency: json['countryOfResidency'] as String?,
      pic: json['pic'] as String?,
      propertyName: json['propertyName'] as String?,
      state: json['state'] as String?,
      street: json['street'] as String?,
      town: json['town'] as String?,
      postcode: UserData._parseInt(json['postcode']),
      id: json['id'] as int?,
      signature: json['signature'] as String?,
      logOn: json['logOn'] as String?,
      employeeNumber: json['employeeNumber'] as String?,
      driversLicense: json['driversLicense'] as String?,
      ddt: json['ddt'] as String?,
      persons: json['persons'] as String?,
      contactDetails: json['contactDetails'] as String?,
      reasonForVisit: json['reasonForVisit'] as String?,
      ohsRequirements: json['ohsRequirements'] as String?,
      questionnaire: json['questionnaire'] as String?,
      region: json['region'] as String?,
      company:
          (json['company'] as List<dynamic>?)?.map((e) => e as String).toList(),
      picVisiting: json['picVisiting'] as String?,
      reason: json['reason'] as String?,
      worksafeQuestionsForm: json['worksafeQuestionsForm'] as String?,
      countryOfOrigin: json['countryOfOrigin'] as String?,
      countryVisiting: json['countryVisiting'] as String?,
      entryDate: json['entryDate'] as String?,
      exitDate: json['exitDate'] as String?,
      logo: json['logo'] as String?,
      passport: json['passport'] as String?,
      ngr: json['ngr'] as String?,
      businessName: json['businessName'] as String?,
      sector: json['sector'] as String?,
      contactName: json['contactName'] as String?,
      eventName: json['eventName'] as String?,
      rego: json['rego'] as String?,
      contactEmail: json['contactEmail'] as String?,
      contactNumber: json['contactNumber'] as String?,
      cvdForms: (json['cvdForms'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      startDate: UserData._parseDate(json['startDate'] as String?),
      endDate: UserData._parseDate(json['endDate'] as String?),
      edec: json['edec'] as String?,
      allowedRoles: (json['allowedRoles'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      registrationToken: json['registrationToken'] as String?,
      updatedAt: UserData._parseDate(json['updatedAt'] as String?),
      status: UserData.getStatus(json['status'] as String?),
      lpaUsername: json['lpaUsername'] as String?,
      lpaPassword: json['lpaPassword'] as String?,
      nlisUsername: json['nlisUsername'] as String?,
      nlisPassword: json['nlisPassword'] as String?,
      msaNumber: json['msaNumber'] as String?,
      nfasAccreditationNumber: json['nfasAccreditationNumber'] as String?,
      stripeCusId: json['stripeCusId'] as String?,
      geofenceLimit: json['geofenceLimit'] as int?,
      isSubscribed: json['isSubscribed'] as bool?,
      subscriptionStartDate:
          UserData._parseDate(json['subscriptionStartDate'] as String?),
      subscriptionEndDate:
          UserData._parseDate(json['subscriptionEndDate'] as String?),
      createdAt: UserData._parseDate(json['createdAt'] as String?),
      emergencyEmailContact: json['emergencyEmailContact'] as String?,
      isTemporaryOwner: json['isTemporaryOwner'] as bool?,
      city: json['city'] as String?,
      location: json['location'] as String?,
    )
      ..officeName = json['officeName'] as String?
      ..titleName = json['titleName'] as String?;

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'postcode': instance.postcode,
      'id': instance.id,
      'firstName': instance.firstName,
      'logo': instance.logo,
      'rego': instance.rego,
      'lastName': instance.lastName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'countryCode': instance.countryCode,
      'role': instance.role,
      'pic': instance.pic,
      'propertyName': instance.propertyName,
      'state': instance.state,
      'street': instance.street,
      'town': instance.town,
      'city': instance.city,
      'signature': instance.signature,
      'logOn': instance.logOn,
      'employeeNumber': instance.employeeNumber,
      'driversLicense': instance.driversLicense,
      'ddt': instance.ddt,
      'persons': instance.persons,
      'contactDetails': instance.contactDetails,
      'reasonForVisit': instance.reasonForVisit,
      'ohsRequirements': instance.ohsRequirements,
      'questionnaire': instance.questionnaire,
      'location': instance.location,
      'region': instance.region,
      'company': instance.company,
      'picVisiting': instance.picVisiting,
      'reason': instance.reason,
      'worksafeQuestionsForm': instance.worksafeQuestionsForm,
      'countryOfOrigin': instance.countryOfOrigin,
      'countryVisiting': instance.countryVisiting,
      'entryDate': instance.entryDate,
      'exitDate': instance.exitDate,
      'passport': instance.passport,
      'ngr': instance.ngr,
      'businessName': instance.businessName,
      'sector': instance.sector,
      'contactName': instance.contactName,
      'eventName': instance.eventName,
      'contactEmail': instance.contactEmail,
      'contactNumber': instance.contactNumber,
      'edec': instance.edec,
      'lpaPassword': instance.lpaPassword,
      'lpaUsername': instance.lpaUsername,
      'nlisPassword': instance.nlisPassword,
      'nlisUsername': instance.nlisUsername,
      'msaNumber': instance.msaNumber,
      'nfasAccreditationNumber': instance.nfasAccreditationNumber,
      'countryOfResidency': instance.countryOfResidency,
      'employerCompany': instance.employerCompany,
      'temporaryOwner': instance.temporaryOwner,
      'isTemporaryOwner': instance.isTemporaryOwner,
      'emergencyMobileContact': instance.emergencyMobileContact,
      'emergencyEmailContact': instance.emergencyEmailContact,
      'stripeCusId': instance.stripeCusId,
      'officeName': instance.officeName,
      'titleName': instance.titleName,
      'geofenceLimit': instance.geofenceLimit,
      'isSubscribed': instance.isSubscribed,
      'allowedRoles': instance.allowedRoles,
      'species': instance.species,
      'cvdForms': instance.cvdForms,
      'registrationToken': instance.registrationToken,
      'status': UserData.statusToJson(instance.status),
      'subscriptionStartDate':
          instance.subscriptionStartDate?.toIso8601String(),
      'subscriptionEndDate': instance.subscriptionEndDate?.toIso8601String(),
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'delegationStartDate': instance.delegationStartDate?.toIso8601String(),
      'delegationEndDate': instance.delegationEndDate?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
