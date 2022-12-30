import 'cvd_field_data.dart';

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
    commodity = json['commodity'] != null ? CvdFieldData.fromJson(json['commodity']) : null;
    variety1 = json['variety1'] != null ? CvdFieldData.fromJson(json['variety1']) : null;
    variety2 = json['variety2'] != null ? CvdFieldData.fromJson(json['variety2']) : null;
    deliveryPeriod = json['deliveryPeriod'] != null ? CvdFieldData.fromJson(json['deliveryPeriod']) : null;
    quantity1 = json['quantity1'] != null ? CvdFieldData.fromJson(json['quantity1']) : null;
    quantity2 = json['quantity2'] != null ? CvdFieldData.fromJson(json['quantity2']) : null;
    totalQuantity = json['totalQuantity'] != null ? CvdFieldData.fromJson(json['totalQuantity']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (commodity != null) {
      data['commodity'] = commodity!.toJson();
    }
    if (variety1 != null) {
      data['variety1'] = variety1!.toJson();
    }
    if (variety2 != null) {
      data['variety2'] = variety2!.toJson();
    }
    if (deliveryPeriod != null) {
      data['deliveryPeriod'] = deliveryPeriod!.toJson();
    }
    if (quantity1 != null) {
      data['quantity1'] = quantity1!.toJson();
    }
    if (quantity2 != null) {
      data['quantity2'] = quantity2!.toJson();
    }
    if (totalQuantity != null) {
      data['totalQuantity'] = totalQuantity!.toJson();
    }
    return data;
  }
}
