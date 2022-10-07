class ChemicalUseModel {
  String? field;
  Question4? question4;
  Question5? question5;
  Question6? question6;
  Question7? question7;
  Question6? question8;
  Question6? question9;

  ChemicalUseModel({
    this.field,
    this.question4,
    this.question5,
    this.question6,
    this.question7,
    this.question8,
    this.question9,
  });

  ChemicalUseModel.fromJson(Map<String, dynamic> json) {
    field = json['field'];
    question4 = json['question4'] != null ? Question4.fromJson(json['question4']) : null;
    question5 = json['question5'] != null ? Question5.fromJson(json['question5']) : null;
    question6 = json['question6'] != null ? Question6.fromJson(json['question6']) : null;
    question7 = json['question7'] != null ? Question7.fromJson(json['question7']) : null;
    question8 = json['question8'] != null ? Question6.fromJson(json['question8']) : null;
    question9 = json['question9'] != null ? Question6.fromJson(json['question9']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['field'] = field;
    if (question4 != null) {
      data['question4'] = question4!.toJson();
    }
    if (question5 != null) {
      data['question5'] = question5!.toJson();
    }
    if (question6 != null) {
      data['question6'] = question6!.toJson();
    }
    if (question7 != null) {
      data['question7'] = question7!.toJson();
    }
    if (question8 != null) {
      data['question8'] = question8!.toJson();
    }
    if (question9 != null) {
      data['question9'] = question9!.toJson();
    }
    return data;
  }
}

class Question4 {
  String? field;
  List<String>? options;
  List? tableHeader;

  Question4({this.field, this.options, this.tableHeader});

  Question4.fromJson(Map<String, dynamic> json) {
    field = json['field'];
    options = json['options'].cast<String>();
    tableHeader = json['tableHeader'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['field'] = field;
    data['options'] = options;
    data['tableHeader'] = tableHeader;
    return data;
  }
}

class Question5 {
  String? field;
  List<String>? options;
  String? qAProgram;
  String? accreditationCertificationNumber;
  String? note;

  Question5({this.field, this.options, this.qAProgram, this.accreditationCertificationNumber, this.note});

  Question5.fromJson(Map<String, dynamic> json) {
    field = json['field'];
    options = json['options'].cast<String>();
    qAProgram = json['QA program'];
    accreditationCertificationNumber = json['Accreditation/ Certification Number'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['field'] = field;
    data['options'] = options;
    data['QA program'] = qAProgram;
    data['Accreditation/ Certification Number'] = accreditationCertificationNumber;
    data['note'] = note;
    return data;
  }
}

class Question6 {
  String? field;
  List<String>? options;

  Question6({this.field, this.options});

  Question6.fromJson(Map<String, dynamic> json) {
    field = json['field'];
    options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['field'] = field;
    data['options'] = options;
    return data;
  }
}

class Question7 {
  String? field;
  String? options;

  Question7({this.field, this.options});

  Question7.fromJson(Map<String, dynamic> json) {
    field = json['field'];
    options = json['options'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['field'] = field;
    data['options'] = options;
    return data;
  }
}
