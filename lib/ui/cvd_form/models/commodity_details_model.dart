import 'package:bioplus/ui/cvd_form/models/cvd_field_data.dart';

class CommodityDetailsModel {
  CvdFieldData? commodity;
  CvdFieldData? variety1;
  CvdFieldData? variety2;
  CvdFieldData? deliveryPeriod;
  CvdFieldData? quantity1;
  CvdFieldData? quantity2;
  CvdFieldData? totalQuantity;

  CommodityDetailsModel(
      {this.commodity,
      this.variety1,
      this.variety2,
      this.deliveryPeriod,
      this.quantity1,
      this.quantity2,
      this.totalQuantity});
  CommodityDetailsModel.fromJson(Map json) {
    commodity = json['commodity'] != null ? new CvdFieldData.fromJson(json['commodity']) : null;
    variety1 = json['variety1'] != null ? new CvdFieldData.fromJson(json['variety1']) : null;
    variety2 = json['variety2'] != null ? new CvdFieldData.fromJson(json['variety2']) : null;
    deliveryPeriod = json['deliveryPeriod'] != null ? new CvdFieldData.fromJson(json['deliveryPeriod']) : null;
    quantity1 = json['quantity1'] != null ? new CvdFieldData.fromJson(json['quantity1']) : null;
    quantity2 = json['quantity2'] != null ? new CvdFieldData.fromJson(json['quantity2']) : null;
    totalQuantity = json['totalQuantity'] != null ? new CvdFieldData.fromJson(json['totalQuantity']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.commodity != null) {
      data['commodity'] = this.commodity!.toJson();
    }
    if (this.variety1 != null) {
      data['variety1'] = this.variety1!.toJson();
    }
    if (this.variety2 != null) {
      data['variety2'] = this.variety2!.toJson();
    }
    if (this.deliveryPeriod != null) {
      data['deliveryPeriod'] = this.deliveryPeriod!.toJson();
    }
    if (this.quantity1 != null) {
      data['quantity1'] = this.quantity1!.toJson();
    }
    if (this.quantity2 != null) {
      data['quantity2'] = this.quantity2!.toJson();
    }
    if (this.totalQuantity != null) {
      data['totalQuantity'] = this.totalQuantity!.toJson();
    }
    return data;
  }
}
