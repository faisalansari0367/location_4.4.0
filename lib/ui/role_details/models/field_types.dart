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
}


extension FieldTypeExt on FieldType {
  bool get isText => this == FieldType.text;
  bool get isEmail => this == FieldType.email;
  bool get isPhoneNumber => this == FieldType.phoneNumber;
  bool get isFirstName => this == FieldType.firstName;
  bool get isLastName => this == FieldType.lastName;
  bool get isSignature => this == FieldType.signature;
  bool get isPic => this == FieldType.pic;
  // address
  bool get isAddress => this == FieldType.address;
  bool get isDate => this == FieldType.date;

}