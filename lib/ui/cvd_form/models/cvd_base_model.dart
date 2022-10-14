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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.name != null) {
      data['name'] = this.name!.toJson();
    }
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    if (this.town != null) {
      data['town'] = this.town!.toJson();
    }
    if (this.tel != null) {
      data['tel'] = this.tel!.toJson();
    }
    if (this.fax != null) {
      data['fax'] = this.fax!.toJson();
    }
    if (this.email != null) {
      data['email'] = this.email!.toJson();
    }
    if (this.ngr != null) {
      data['ngr'] = this.ngr!.toJson();
    }
    if (this.pic != null) {
      data['pic'] = this.pic!.toJson();
    }
    return data;
  }
}
