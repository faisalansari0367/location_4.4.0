class Options {
  String? label;
  String? value;

  Options({this.label, this.value});

  Options.fromJson(Map json) {
    label = json['label'];
    value = json['value'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['value'] = value;
    return data;
  }
}
