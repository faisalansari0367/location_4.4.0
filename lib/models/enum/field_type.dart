import 'package:get/get.dart';

enum FieldType {
  text,
  email,
  phoneNumber,
  firstName,
  lastName,
  signature,
  pic,
  address,
  date,
  entryDate,
  exitDate,
  country,
  countryOfOrigin,
  countryVisiting,
  companyAddress,
  region,
  passport,
  driversLicense,
  propertyName,
  city,
  town,
  company,
  species,
  licenseCategory,
}

extension FieldTypeExt on FieldType {
  bool get isText => this == FieldType.text;
  bool get isEmail => this == FieldType.email;
  bool get isPhoneNumber => this == FieldType.phoneNumber;
  bool get isFirstName => this == FieldType.firstName;
  bool get isLastName => this == FieldType.lastName;
  bool get isSignature => this == FieldType.signature;
  bool get isPic => this == FieldType.pic;
  bool get isAddress => this == FieldType.address;
  bool get isDate => this == FieldType.date;
  bool get isCountry => this == FieldType.country;
  bool get isEntryDate => this == FieldType.entryDate;
  bool get isExitDate => this == FieldType.exitDate;
  bool get isCountryOfOrigin => this == FieldType.countryOfOrigin;
  bool get isCountryVisiting => this == FieldType.countryVisiting;
  bool get isCompanyAddress => this == FieldType.companyAddress;
  bool get isRegion => this == FieldType.region;
  bool get isDriversLicense => this == FieldType.driversLicense;
  bool get isPropertyName => this == FieldType.propertyName;
  bool get isCompany => this == FieldType.company;
  bool get isPassport => this == FieldType.passport;
  bool get isSpecies => this == FieldType.species;
  bool get isLicenceCategory => this == FieldType.licenseCategory;

  String get label {
    final index = name.codeUnits
        .firstWhereOrNull((element) => element >= 65 && element <= 90);
    if (index != null) {
      final first = name.substring(0, name.indexOf(String.fromCharCode(index)));
      final second = name.substring(name.indexOf(String.fromCharCode(index)));
      return '${first.capitalize} $second';
    } else {
      return name.capitalize!;
    }
  }
}
