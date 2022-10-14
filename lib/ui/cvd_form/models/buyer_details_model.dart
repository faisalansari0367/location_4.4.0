import 'package:background_location/ui/cvd_form/models/cvd_base_model.dart';
import 'package:background_location/ui/cvd_form/models/cvd_field_data.dart';

class BuyerDetailsModel extends CvdBaseModel {
  CvdFieldData? contractNo;

  BuyerDetailsModel();

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    contractNo?.key = this.contractNo?.toJson() as String?;
    return data;
  }

  @override
  void fillData(Map<String, dynamic>? json) {
    super.fillField(contractNo, json);
    super.fillData(json);
  }

  @override
  BuyerDetailsModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] != null ? CvdFieldData.fromJson(json['name']) : null;
    address = json['address'] != null ? CvdFieldData.fromJson(json['address']) : null;
    town = json['town'] != null ? CvdFieldData.fromJson(json['town']) : null;
    tel = json['tel'] != null ? CvdFieldData.fromJson(json['tel']) : null;
    fax = json['fax'] != null ? CvdFieldData.fromJson(json['fax']) : null;
    email = json['email'] != null ? CvdFieldData.fromJson(json['email']) : null;
    ngr = json['ngr'] != null ? CvdFieldData.fromJson(json['ngr']) : null;
    pic = json['pic'] != null ? CvdFieldData.fromJson(json['pic']) : null;
    contractNo = json['contractNo'] != null ? CvdFieldData.fromJson(json['contractNo']) : null;
  }
}
