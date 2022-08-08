enum FieldType {
  text,
  email,
  phoneNumber,
  firstName,
  lastName,
}


extension FieldTypeExt on FieldType {
  bool get isText => this == FieldType.text;
  bool get isEmail => this == FieldType.email;
  bool get isPhoneNumber => this == FieldType.phoneNumber;

}