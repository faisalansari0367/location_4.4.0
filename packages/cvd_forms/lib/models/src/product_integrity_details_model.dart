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
    sourceCheck = json['sourceCheck'] != null ? FieldData.fromJson(json['sourceCheck']) : null;
    materialCheck = json['materialCheck'] != null ? FieldData.fromJson(json['materialCheck']) : null;
    gmoCheck = json['gmoCheck'] != null ? FieldData.fromJson(json['gmoCheck']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (sourceCheck != null) {
      data['sourceCheck'] = sourceCheck!.toJson();
    }
    if (materialCheck != null) {
      data['materialCheck'] = materialCheck!.toJson();
    }
    if (gmoCheck != null) {
      data['gmoCheck'] = gmoCheck!.toJson();
    }
    return data;
  }
}
