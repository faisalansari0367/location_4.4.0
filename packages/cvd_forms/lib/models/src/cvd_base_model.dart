import 'cvd_field_data.dart';

abstract class CvdBaseModel {
  CvdFieldData? name;
  CvdFieldData? address;
  CvdFieldData? town;
  CvdFieldData? tel;
  CvdFieldData? fax;
  CvdFieldData? email;
  CvdFieldData? ngr;
  CvdFieldData? pic;

  CvdBaseModel({this.name, this.address, this.town, this.tel, this.fax, this.email, this.ngr, this.pic});

  CvdBaseModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] != null ? CvdFieldData.fromJson(json['name']) : null;
    address = json['address'] != null ? CvdFieldData.fromJson(json['address']) : null;
    town = json['town'] != null ? CvdFieldData.fromJson(json['town']) : null;
    tel = json['tel'] != null ? CvdFieldData.fromJson(json['tel']) : null;
    fax = json['fax'] != null ? CvdFieldData.fromJson(json['fax']) : null;
    email = json['email'] != null ? CvdFieldData.fromJson(json['email']) : null;
    ngr = json['ngr'] != null ? CvdFieldData.fromJson(json['ngr']) : null;
    pic = json['pic'] != null ? CvdFieldData.fromJson(json['pic']) : null;
  }

  void fillData(Map<String, dynamic>? json) {
    fillField(name, json);
    fillField(address, json);
    fillField(town, json);
    fillField(tel, json);
    fillField(fax, json);
    fillField(email, json);
    fillField(ngr, json);
    fillField(pic, json);
  }

  void fillField(CvdFieldData? data, Map<String, dynamic>? json) {
    if (json?.containsKey(data?.key) ?? false) {
      data?.value = json![data.key];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (name != null) {
      data['name'] = name!.toJson();
    }
    if (address != null) {
      data['address'] = address!.toJson();
    }
    if (town != null) {
      data['town'] = town!.toJson();
    }
    if (tel != null) {
      data['tel'] = tel!.toJson();
    }
    if (fax != null) {
      data['fax'] = fax!.toJson();
    }
    if (email != null) {
      data['email'] = email!.toJson();
    }
    if (ngr != null) {
      data['ngr'] = ngr!.toJson();
    }
    if (pic != null) {
      data['pic'] = pic!.toJson();
    }
    return data;
  }
}
