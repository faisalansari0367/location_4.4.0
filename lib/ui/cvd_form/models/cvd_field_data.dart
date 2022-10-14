import 'package:background_location/ui/cvd_form/models/cvd_list_item.dart';

class CvdFieldData {
  String? key;
  String? label;
  String? value;
 

  CvdFieldData({this.key, this.label, this.value});

  CvdFieldData.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['label'] = this.label;
    data['value'] = this.value;
    return data;
  }
}
