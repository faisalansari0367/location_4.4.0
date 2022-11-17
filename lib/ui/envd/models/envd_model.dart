import 'package:flutter/material.dart';

import '../../../constants/my_decoration.dart';

class EnvdResponseModel {
  EnvdData? data;

  EnvdResponseModel({this.data});

  EnvdResponseModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new EnvdData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class EnvdData {
  Consignments? consignments;

  EnvdData({this.consignments});

  EnvdData.fromJson(Map<String, dynamic> json) {
    consignments = json['consignments'] != null ? new Consignments.fromJson(json['consignments']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.consignments != null) {
      data['consignments'] = this.consignments!.toJson();
    }
    return data;
  }
}

class Consignments {
  int? totalCount;
  List<Items>? items;

  Consignments({this.totalCount, this.items});

  Consignments.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCount'] = this.totalCount;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? number;
  List<Forms>? forms;
  String? pdfUrl;
  String? submittedAt;
  String? updatedAt;
  String? updatedBy;
  String? status;
  String? species;
  Owner? owner;
  Owner? destination;
  Owner? consignee;
  Owner? origin;
  Declaration? declaration;
  List<Questions>? questions;
  List<Answers>? answers;

  Items(
      {this.number,
      this.forms,
      this.pdfUrl,
      this.submittedAt,
      this.updatedAt,
      this.updatedBy,
      this.status,
      this.species,
      this.owner,
      this.destination,
      this.consignee,
      this.origin,
      this.declaration,
      this.questions,
      this.answers});

  Items.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    if (json['forms'] != null) {
      forms = <Forms>[];
      json['forms'].forEach((v) {
        forms!.add(new Forms.fromJson(v));
      });
    }
    pdfUrl = json['pdfUrl'];
    submittedAt = json['submittedAt'];
    updatedAt = json['updatedAt'];
    updatedBy = json['updatedBy'];
    status = json['status'];
    species = json['species'];
    owner = json['owner'] != null ? new Owner.fromJson(json['owner']) : null;
    destination = json['destination'] != null ? new Owner.fromJson(json['destination']) : null;
    consignee = json['consignee'] != null ? new Owner.fromJson(json['consignee']) : null;
    origin = json['origin'] != null ? new Owner.fromJson(json['origin']) : null;
    declaration = json['declaration'] != null ? new Declaration.fromJson(json['declaration']) : null;
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(new Questions.fromJson(v));
      });
    }
    if (json['answers'] != null) {
      answers = <Answers>[];
      json['answers'].forEach((v) {
        answers!.add(new Answers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    if (this.forms != null) {
      data['forms'] = this.forms!.map((v) => v.toJson()).toList();
    }
    data['pdfUrl'] = this.pdfUrl;
    data['submittedAt'] = this.submittedAt;
    data['updatedAt'] = this.updatedAt;
    data['updatedBy'] = this.updatedBy;
    data['status'] = this.status;
    data['species'] = this.species;
    if (this.owner != null) {
      data['owner'] = this.owner!.toJson();
    }
    if (this.destination != null) {
      data['destination'] = this.destination!.toJson();
    }
    if (this.consignee != null) {
      data['consignee'] = this.consignee!.toJson();
    }
    if (this.origin != null) {
      data['origin'] = this.origin!.toJson();
    }
    if (this.declaration != null) {
      data['declaration'] = this.declaration!.toJson();
    }
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    if (this.answers != null) {
      data['answers'] = this.answers!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String getAccredentials() {
    List<String> availableTypes = [];
    final ahsType = 'HS${species!.characters.first}';
    final msaType = 'MSA${species!.characters.first}';
    final nfasType = 'NFAS${species!.characters.first}';

    final ahsResults = forms!.where((element) => (element.type ?? '').contains(ahsType));
    if (ahsResults.isNotEmpty) availableTypes.add('AHS');
    final msaResults = forms!.where((element) => (element.type ?? '').contains(msaType));
    if (msaResults.isNotEmpty) availableTypes.add('MSA');
    final nfasResults = forms!.where((element) => (element.type ?? '').contains(nfasType));
    if (nfasResults.isNotEmpty) availableTypes.add('NFAS');
    return availableTypes.join(' , ');
  }

  String getQuantity() {
    final data = (answers ?? []).where((element) => element.questionId == '3');
    if (data.isEmpty) return '';
    return data.first.value!;
  }

  String createdAt() {
    return submittedAt != null || updatedAt != null
        ? MyDecoration.formatDate(DateTime.parse(submittedAt ?? updatedAt!))
        : '';
  }

  Answers? _findById(String id) {
    final data = (answers ?? []).where((element) => element.questionId == id);
    if (data.isEmpty) return null;
    return data.first;
  }

  String get fromPIC => origin?.pic ?? '';
  String get transporter => _findById('158')?.value ?? '';
  String get toPIC => destination?.pic ?? '';
}

class Forms {
  String? type;
  String? serialNumber;

  Forms({this.type, this.serialNumber});

  Forms.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    serialNumber = json['serialNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['serialNumber'] = this.serialNumber;
    return data;
  }
}

class Owner {
  Address? address;
  String? name;
  String? pic;

  Owner({this.address, this.name, this.pic});

  Owner.fromJson(Map<String, dynamic> json) {
    address = json['address'] != null ? new Address.fromJson(json['address']) : null;
    name = json['name'];
    pic = json['pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    data['name'] = this.name;
    data['pic'] = this.pic;
    return data;
  }
}

class Address {
  String? line1;
  String? postcode;
  String? state;
  String? town;

  Address({this.line1, this.postcode, this.state, this.town});

  Address.fromJson(Map<String, dynamic> json) {
    line1 = json['line1'];
    postcode = json['postcode'];
    state = json['state'];
    town = json['town'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['line1'] = this.line1;
    data['postcode'] = this.postcode;
    data['state'] = this.state;
    data['town'] = this.town;
    return data;
  }
}

class Declaration {
  bool? accept;
  Address? address;
  String? certificateNumber;
  String? date;
  String? email;
  String? fullName;
  String? phone;
  String? signature;

  Declaration(
      {this.accept,
      this.address,
      this.certificateNumber,
      this.date,
      this.email,
      this.fullName,
      this.phone,
      this.signature});

  Declaration.fromJson(Map<String, dynamic> json) {
    accept = json['accept'];
    address = json['address'] != null ? new Address.fromJson(json['address']) : null;
    certificateNumber = json['certificateNumber'];
    date = json['date'];
    email = json['email'];
    fullName = json['fullName'];
    phone = json['phone'];
    signature = json['signature'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accept'] = this.accept;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    data['certificateNumber'] = this.certificateNumber;
    data['date'] = this.date;
    data['email'] = this.email;
    data['fullName'] = this.fullName;
    data['phone'] = this.phone;
    data['signature'] = this.signature;
    return data;
  }
}

class Questions {
  String? id;
  String? text;
  String? help;
  String? type;
  List<AcceptableAnswers>? acceptableAnswers;
  List<ChildQuestions>? childQuestions;

  Questions({this.id, this.text, this.help, this.type, this.acceptableAnswers, this.childQuestions});

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    help = json['help'];
    type = json['type'];
    if (json['acceptableAnswers'] != null) {
      acceptableAnswers = <AcceptableAnswers>[];
      json['acceptableAnswers'].forEach((v) {
        acceptableAnswers!.add(new AcceptableAnswers.fromJson(v));
      });
    }
    if (json['childQuestions'] != null) {
      childQuestions = <ChildQuestions>[];
      json['childQuestions'].forEach((v) {
        childQuestions!.add(new ChildQuestions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    data['help'] = this.help;
    data['type'] = this.type;
    if (this.acceptableAnswers != null) {
      data['acceptableAnswers'] = this.acceptableAnswers!.map((v) => v.toJson()).toList();
    }
    if (this.childQuestions != null) {
      data['childQuestions'] = this.childQuestions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AcceptableAnswers {
  String? displayName;
  String? value;

  AcceptableAnswers({this.displayName, this.value});

  AcceptableAnswers.fromJson(Map<String, dynamic> json) {
    displayName = json['displayName'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['displayName'] = this.displayName;
    data['value'] = this.value;
    return data;
  }
}

class ChildQuestions {
  String? id;
  String? text;
  String? help;
  String? type;
  List<AcceptableAnswers>? acceptableAnswers;
  List<Triggers>? triggers;

  ChildQuestions({this.id, this.text, this.help, this.type, this.acceptableAnswers, this.triggers});

  ChildQuestions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    help = json['help'];
    type = json['type'];
    if (json['acceptableAnswers'] != null) {
      acceptableAnswers = <AcceptableAnswers>[];
      json['acceptableAnswers'].forEach((v) {
        acceptableAnswers!.add(new AcceptableAnswers.fromJson(v));
      });
    }
    if (json['triggers'] != null) {
      triggers = <Triggers>[];
      json['triggers'].forEach((v) {
        triggers!.add(new Triggers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    data['help'] = this.help;
    data['type'] = this.type;
    if (this.acceptableAnswers != null) {
      data['acceptableAnswers'] = this.acceptableAnswers!.map((v) => v.toJson()).toList();
    }
    if (this.triggers != null) {
      data['triggers'] = this.triggers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Triggers {
  String? questionId;
  String? value;

  Triggers({this.questionId, this.value});

  Triggers.fromJson(Map<String, dynamic> json) {
    questionId = json['questionId'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['questionId'] = this.questionId;
    data['value'] = this.value;
    return data;
  }
}

class Answers {
  String? questionId;
  String? value;
  num? index;

  Answers({this.questionId, this.value, this.index});

  Answers.fromJson(Map<String, dynamic> json) {
    questionId = json['questionId'];
    value = json['value'];
    index = json['index'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['questionId'] = this.questionId;
    data['value'] = this.value;
    data['index'] = this.index;
    return data;
  }
}
