import 'cvd_field_data.dart';

class TransporterDetailsModel {
  CvdFieldData? name;
  CvdFieldData? mobile;
  CvdFieldData? email;
  CvdFieldData? company;
  CvdFieldData? registration;

  TransporterDetailsModel({
    this.name,
    this.mobile,
    this.email,
    this.company,
    this.registration,
  });

  TransporterDetailsModel.fromJson(Map json) {
    name = json['name'] != null ? CvdFieldData.fromJson(json['name']) : null;
    mobile = json['mobile'] != null ? CvdFieldData.fromJson(json['mobile']) : null;
    email = json['email'] != null ? CvdFieldData.fromJson(json['email']) : null;
    company = json['company'] != null ? CvdFieldData.fromJson(json['company']) : null;
    registration = json['registration'] != null ? CvdFieldData.fromJson(json['registration']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (name != null) {
      data['name'] = name!.toJson();
    }
    if (mobile != null) {
      data['mobile'] = mobile!.toJson();
    }
    if (email != null) {
      data['email'] = email!.toJson();
    }
    if (company != null) {
      data['company'] = company!.toJson();
    }
    if (registration != null) {
      data['registration'] = registration!.toJson();
    }
    return data;
  }
}
