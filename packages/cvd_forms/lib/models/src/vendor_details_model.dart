import 'cvd_base_model.dart';
import 'cvd_field_data.dart';

class VendorDetailsModel extends CvdBaseModel {
  CvdFieldData? refrenceNo;

  VendorDetailsModel();

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    if (refrenceNo != null) {
      data[refrenceNo!.key!] = refrenceNo!.toJson();
    }
    return data;
  }

  @override
  void fillData(Map<String, dynamic>? json) {
    super.fillField(refrenceNo, json);
    super.fillData(json);
  }

  @override
  VendorDetailsModel.fromJson(Map json) {
    name = json['name'] != null ? CvdFieldData.fromJson(json['name']) : null;
    address = json['address'] != null ? CvdFieldData.fromJson(json['address']) : null;
    town = json['town'] != null ? CvdFieldData.fromJson(json['town']) : null;
    tel = json['tel'] != null ? CvdFieldData.fromJson(json['tel']) : null;
    fax = json['fax'] != null ? CvdFieldData.fromJson(json['fax']) : null;
    email = json['email'] != null ? CvdFieldData.fromJson(json['email']) : null;
    ngr = json['ngr'] != null ? CvdFieldData.fromJson(json['ngr']) : null;
    pic = json['pic'] != null ? CvdFieldData.fromJson(json['pic']) : null;
    refrenceNo = json['referenceNo'] != null ? CvdFieldData.fromJson(json['referenceNo']) : null;
  }
}
