
class ProductIntegrityModel {
  String? field;
  Data? data;

  ProductIntegrityModel({this.field, this.data});

  ProductIntegrityModel.fromJson(Map<String, dynamic> json) {
    field = json['field'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['field'] = field;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Question? question1;
  Question? question2;
  Question? question3;

  Data({this.question1, this.question2, this.question3});

  Data.fromJson(Map<String, dynamic> json) {
    question1 = json['question1'] != null ? Question.fromJson(json['question1']) : null;
    question2 = json['question2'] != null ? Question.fromJson(json['question2']) : null;
    question3 = json['question3'] != null ? Question.fromJson(json['question3']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (question1 != null) {
      data['question1'] = question1!.toJson();
    }
    if (question2 != null) {
      data['question2'] = question2!.toJson();
    }
    if (question3 != null) {
      data['question3'] = question3!.toJson();
    }
    return data;
  }
}

class Question {
  String? field;
  List<IntegrityOptions>? options;

  Question({this.field, this.options});

  Question.fromJson(Map<String, dynamic> json) {
    field = json['field'];
    if (json['options'] != null) {
      options = <IntegrityOptions>[];
      json['options'].forEach((v) {
        options!.add(IntegrityOptions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['field'] = field;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class IntegrityOptions {
  int? id;
  String? value;

  IntegrityOptions({this.id, this.value});

  IntegrityOptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['value'] = value;
    return data;
  }
}
