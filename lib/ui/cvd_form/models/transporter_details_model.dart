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

  TransporterDetailsModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] != null ? new CvdFieldData.fromJson(json['name']) : null;
    mobile = json['mobile'] != null ? new CvdFieldData.fromJson(json['mobile']) : null;
    email = json['email'] != null ? new CvdFieldData.fromJson(json['email']) : null;
    company = json['company'] != null ? new CvdFieldData.fromJson(json['company']) : null;
    registration = json['registration'] != null ? new CvdFieldData.fromJson(json['registration']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.name != null) {
      data['name'] = this.name!.toJson();
    }
    if (this.mobile != null) {
      data['mobile'] = this.mobile!.toJson();
    }
    if (this.email != null) {
      data['email'] = this.email!.toJson();
    }
    if (this.company != null) {
      data['company'] = this.company!.toJson();
    }
    if (this.registration != null) {
      data['registration'] = this.registration!.toJson();
    }
    return data;
  }
}
