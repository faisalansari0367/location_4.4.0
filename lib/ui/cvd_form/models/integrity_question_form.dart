class ProductIntegrityModel {
  String? field;
  Data? data;

  ProductIntegrityModel({this.field, this.data});

  ProductIntegrityModel.fromJson(Map<String, dynamic> json) {
    field = json['field'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['field'] = this.field;
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
    question1 = json['question1'] != null ? new Question.fromJson(json['question1']) : null;
    question2 = json['question2'] != null ? new Question.fromJson(json['question2']) : null;
    question3 = json['question3'] != null ? new Question.fromJson(json['question3']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.question1 != null) {
      data['question1'] = this.question1!.toJson();
    }
    if (this.question2 != null) {
      data['question2'] = this.question2!.toJson();
    }
    if (this.question3 != null) {
      data['question3'] = this.question3!.toJson();
    }
    return data;
  }
}

class Question {
  String? field;
  List<Options>? options;

  Question({this.field, this.options});

  Question.fromJson(Map<String, dynamic> json) {
    field = json['field'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['field'] = this.field;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  int? id;
  String? value;

  Options({this.id, this.value});

  Options.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.value;
    return data;
  }
}
