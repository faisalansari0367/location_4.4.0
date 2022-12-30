import 'options.dart';

class FieldData {
  String? field;
  String? value;
  String? key;
  List<Options>? options;

  FieldData({this.field, this.options, this.key});

  FieldData.fromJson(Map json) {
    field = json['field'];
    value = json['value'];
    key = json['key'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['field'] = field;
    data['key'] = key;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    data['value'] = value;
    return data;
  }
}
