class CvdFieldData {
  String? key;
  String? label;
  String? value;

  CvdFieldData({this.key, this.label, this.value});

  CvdFieldData.fromJson(Map json) {
    key = json['key'];
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['label'] = label;
    data['value'] = value;
    return data;
  }
}
