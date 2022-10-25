import 'chemical_use.dart';

class ProductIntegrityDetailsModel {
  FieldData? sourceCheck;
  FieldData? materialCheck;
  FieldData? gmoCheck;

  ProductIntegrityDetailsModel({
    this.sourceCheck,
    this.materialCheck,
    this.gmoCheck,
  });

  ProductIntegrityDetailsModel.fromJson(Map json) {
    sourceCheck = json['sourceCheck'] != null ? new FieldData.fromJson(json['sourceCheck']) : null;
    materialCheck = json['materialCheck'] != null ? new FieldData.fromJson(json['materialCheck']) : null;
    gmoCheck = json['gmoCheck'] != null ? new FieldData.fromJson(json['gmoCheck']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sourceCheck != null) {
      data['sourceCheck'] = this.sourceCheck!.toJson();
    }
    if (this.materialCheck != null) {
      data['materialCheck'] = this.materialCheck!.toJson();
    }
    if (this.gmoCheck != null) {
      data['gmoCheck'] = this.gmoCheck!.toJson();
    }
    return data;
  }
}
