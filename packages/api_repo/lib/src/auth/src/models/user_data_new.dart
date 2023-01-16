// import 'package:api_repo/api_repo.dart';

// class UserDataNew {
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
//   String? state;
//   String? street;
//   String? town;
//   String? city;
//   int? postcode;
//   String? countryOfResidency;
//   String? signature;
//   dynamic logOn;
//   String? employerCompany;
//   String? employeeNumber;
//   String? driversLicense;
//   String? licenseCategory;
//   String? licenseExpiryDate;
//   String? ddt;
//   String? persons;
//   String? contactDetails;
//   String? reasonForVisit;
//   String? ohsRequirements;
//   String? questionnaire;
//   String? location;
//   String? company;
//   String? picVisiting;
//   String? reason;
//   String? worksafeQuestionsForm;
//   String? countryOfOrigin;
//   String? countryVisiting;
//   String? entryDate;
//   String? exitDate;
//   String? passport;
//   String? registrationToken;
//   String? status;
//   String? ngr;
//   String? businessName;
//   String? sector;
//   String? contactName;
//   String? eventName;
//   String? contactEmail;
//   String? contactNumber;
//   DateTime startDate;
//   DateTime endDate;
//   String? edec;
//   String? lpaUsername;
//   String? lpaPassword;
//   String? nlisUsername;
//   String? nlisPassword;
//   String? msaNumber;
//   String? nfasAccreditationNumber;
//   String? emergencyEmailContact;
//   dynamic longitude;
//   dynamic latitude;
//   dynamic stripeCusId;
//   int? geofenceLimit;
//   bool isSubscribed;
//   DateTime? subscriptionStartDate;
//   DateTime? subscriptionEndDate;
//   DateTime? delegationStartDate;
//   DateTime? delegationEndDate;
//   String? temporaryOwner;
//   bool isTemporaryOwner;

//   List<String> cvdForms;
//   List<String>? species;
//   List<String>? allowedRoles;

//   UserDataNew({
//     this.id,
//     this.firstName,
//     this.lastName,
//     this.email,
//     this.phoneNumber,
//     this.countryCode,
//     this.role,
//     this.createdAt,
//     this.updatedAt,
//     this.pic,
//     this.propertyName,
//     this.state,
//     this.street,
//     this.town,
//     this.city,
//     this.postcode,
//     this.countryOfResidency,
//     this.signature,
//     this.logOn,
//     this.employerCompany,
//     this.employeeNumber,
//     this.driversLicense,
//     this.licenseCategory,
//     this.licenseExpiryDate,
//     this.ddt,
//     this.persons,
//     this.contactDetails,
//     this.reasonForVisit,
//     this.ohsRequirements,
//     this.questionnaire,
//     this.location,
//     this.company,
//     this.picVisiting,
//     this.reason,
//     this.worksafeQuestionsForm,
//     this.countryOfOrigin,
//     this.countryVisiting,
//     this.entryDate,
//     this.exitDate,
//     this.passport,
//     this.registrationToken,
//     this.status,
//     this.species,
//     this.allowedRoles,
//     this.ngr,
//     this.businessName,
//     this.sector,
//     this.contactName,
//     this.eventName,
//     this.contactEmail,
//     this.contactNumber,
//     this.startDate,
//     this.endDate,
//     this.edec,
//     this.lpaUsername,
//     this.lpaPassword,
//     this.nlisUsername,
//     this.nlisPassword,
//     this.msaNumber,
//     this.nfasAccreditationNumber,
//     this.cvdForms,
//     this.emergencyEmailContact,
//     this.longitude,
//     this.latitude,
//     this.stripeCusId,
//     this.geofenceLimit,
//     this.isSubscribed,
//     this.subscriptionStartDate,
//     this.subscriptionEndDate,
//     this.delegationStartDate,
//     this.delegationEndDate,
//     this.temporaryOwner,
//     this.isTemporaryOwner,
//   });

//   UserDataNew.fromJson(Map<String, dynamic> json) {
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
//     state = json['state'];
//     street = json['street'];
//     town = json['town'];
//     city = json['city'];
//     postcode = json['postcode'];
//     countryOfResidency = json['countryOfResidency'];
//     signature = json['signature'];
//     logOn = json['logOn'];
//     employerCompany = json['employerCompany'];
//     employeeNumber = json['employeeNumber'];
//     driversLicense = json['driversLicense'];
//     licenseCategory = json['licenseCategory'];
//     licenseExpiryDate = json['licenseExpiryDate'];
//     ddt = json['ddt'];
//     persons = json['persons'];
//     contactDetails = json['contactDetails'];
//     reasonForVisit = json['reasonForVisit'];
//     ohsRequirements = json['ohsRequirements'];
//     questionnaire = json['questionnaire'];
//     location = json['location'];
//     company = json['company'];
//     picVisiting = json['picVisiting'];
//     reason = json['reason'];
//     worksafeQuestionsForm = json['worksafeQuestionsForm'];
//     countryOfOrigin = json['countryOfOrigin'];
//     countryVisiting = json['countryVisiting'];
//     entryDate = json['entryDate'];
//     exitDate = json['exitDate'];
//     passport = json['passport'];
//     registrationToken = json['registrationToken'];
//     status = json['status'];
//     species = json['species'].cast<String>();
//     allowedRoles = json['allowedRoles'].cast<String>();
//     ngr = json['ngr'];
//     businessName = json['businessName'];
//     sector = json['sector'];
//     contactName = json['contactName'];
//     eventName = json['eventName'];
//     contactEmail = json['contactEmail'];
//     contactNumber = json['contactNumber'];
//     startDate = json['startDate'];
//     endDate = json['endDate'];
//     edec = json['edec'];
//     lpaUsername = json['lpaUsername'];
//     lpaPassword = json['lpaPassword'];
//     nlisUsername = json['nlisUsername'];
//     nlisPassword = json['nlisPassword'];
//     msaNumber = json['msaNumber'];
//     nfasAccreditationNumber = json['nfasAccreditationNumber'];
//     cvdForms = json['cvdForms'];
//     emergencyEmailContact = json['emergencyEmailContact'];
//     longitude = json['longitude'];
//     latitude = json['latitude'];
//     stripeCusId = json['stripeCusId'];
//     geofenceLimit = json['geofenceLimit'];
//     isSubscribed = json['isSubscribed'];
//     subscriptionStartDate = json['subscriptionStartDate'];
//     subscriptionEndDate = json['subscriptionEndDate'];
//     delegationStartDate = json['delegationStartDate'];
//     delegationEndDate = json['delegationEndDate'];
//     temporaryOwner = json['temporaryOwner'];
//     isTemporaryOwner = json['isTemporaryOwner'];
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
//     data['state'] = state;
//     data['street'] = street;
//     data['town'] = town;
//     data['city'] = city;
//     data['postcode'] = postcode;
//     data['countryOfResidency'] = countryOfResidency;
//     data['signature'] = signature;
//     data['logOn'] = logOn;
//     data['employerCompany'] = employerCompany;
//     data['employeeNumber'] = employeeNumber;
//     data['driversLicense'] = driversLicense;
//     data['licenseCategory'] = licenseCategory;
//     data['licenseExpiryDate'] = licenseExpiryDate;
//     data['ddt'] = ddt;
//     data['persons'] = persons;
//     data['contactDetails'] = contactDetails;
//     data['reasonForVisit'] = reasonForVisit;
//     data['ohsRequirements'] = ohsRequirements;
//     data['questionnaire'] = questionnaire;
//     data['location'] = location;
//     data['company'] = company;
//     data['picVisiting'] = picVisiting;
//     data['reason'] = reason;
//     data['worksafeQuestionsForm'] = worksafeQuestionsForm;
//     data['countryOfOrigin'] = countryOfOrigin;
//     data['countryVisiting'] = countryVisiting;
//     data['entryDate'] = entryDate;
//     data['exitDate'] = exitDate;
//     data['passport'] = passport;
//     data['registrationToken'] = registrationToken;
//     data['status'] = status;
//     data['species'] = species;
//     data['allowedRoles'] = allowedRoles;
//     data['ngr'] = ngr;
//     data['businessName'] = businessName;
//     data['sector'] = sector;
//     data['contactName'] = contactName;
//     data['eventName'] = eventName;
//     data['contactEmail'] = contactEmail;
//     data['contactNumber'] = contactNumber;
//     data['startDate'] = startDate;
//     data['endDate'] = endDate;
//     data['edec'] = edec;
//     data['lpaUsername'] = lpaUsername;
//     data['lpaPassword'] = lpaPassword;
//     data['nlisUsername'] = nlisUsername;
//     data['nlisPassword'] = nlisPassword;
//     data['msaNumber'] = msaNumber;
//     data['nfasAccreditationNumber'] = nfasAccreditationNumber;
//     data['cvdForms'] = cvdForms;
//     data['emergencyEmailContact'] = emergencyEmailContact;
//     data['longitude'] = longitude;
//     data['latitude'] = latitude;
//     data['stripeCusId'] = stripeCusId;
//     data['geofenceLimit'] = geofenceLimit;
//     data['isSubscribed'] = isSubscribed;
//     data['subscriptionStartDate'] = subscriptionStartDate;
//     data['subscriptionEndDate'] = subscriptionEndDate;
//     data['delegationStartDate'] = delegationStartDate;
//     data['delegationEndDate'] = delegationEndDate;
//     data['temporaryOwner'] = temporaryOwner;
//     data['isTemporaryOwner'] = isTemporaryOwner;
//     return data;
//   }



//   UserStatus _getStatus(String? status) {
//     if(status == null) {
//       return UserStatus.unknown;
//     }
//     return 
//         status.name.replaceFirst(status.name.characters.first,
//             status.name.characters.first.toUpperCase())
//   }
// }
