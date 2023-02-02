import 'package:bioplus/constants/my_decoration.dart';
import 'package:flutter/material.dart';

class EnvdResponseModel {
  EnvdData? data;

  EnvdResponseModel({this.data});

  EnvdResponseModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? EnvdData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    consignments = json['consignments'] != null
        ? Consignments.fromJson(json['consignments'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (consignments != null) {
      data['consignments'] = consignments!.toJson();
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
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalCount'] = totalCount;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
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

  Items({
    this.number,
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
    this.answers,
  });

  Items.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    if (json['forms'] != null) {
      forms = <Forms>[];
      json['forms'].forEach((v) {
        forms!.add(Forms.fromJson(v));
      });
    }
    pdfUrl = json['pdfUrl'];
    submittedAt = json['submittedAt'];
    updatedAt = json['updatedAt'];
    updatedBy = json['updatedBy'];
    status = json['status'];
    species = json['species'];
    owner = json['owner'] != null ? Owner.fromJson(json['owner']) : null;
    destination = json['destination'] != null
        ? Owner.fromJson(json['destination'])
        : null;
    consignee =
        json['consignee'] != null ? Owner.fromJson(json['consignee']) : null;
    origin = json['origin'] != null ? Owner.fromJson(json['origin']) : null;
    declaration = json['declaration'] != null
        ? Declaration.fromJson(json['declaration'])
        : null;
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(Questions.fromJson(v));
      });
    }
    if (json['answers'] != null) {
      answers = <Answers>[];
      json['answers'].forEach((v) {
        answers!.add(Answers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['number'] = number;
    if (forms != null) {
      data['forms'] = forms!.map((v) => v.toJson()).toList();
    }
    data['pdfUrl'] = pdfUrl;
    data['submittedAt'] = submittedAt;
    data['updatedAt'] = updatedAt;
    data['updatedBy'] = updatedBy;
    data['status'] = status;
    data['species'] = species;
    if (owner != null) {
      data['owner'] = owner!.toJson();
    }
    if (destination != null) {
      data['destination'] = destination!.toJson();
    }
    if (consignee != null) {
      data['consignee'] = consignee!.toJson();
    }
    if (origin != null) {
      data['origin'] = origin!.toJson();
    }
    if (declaration != null) {
      data['declaration'] = declaration!.toJson();
    }
    if (questions != null) {
      data['questions'] = questions!.map((v) => v.toJson()).toList();
    }
    if (answers != null) {
      data['answers'] = answers!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String getAccredentials() {
    final List<String> availableTypes = [];
    final ahsType = 'HS${species!.characters.first}';
    final msaType = 'MSA${species!.characters.first}';
    final nfasType = 'NFAS${species!.characters.first}';

    final ahsResults =
        forms!.where((element) => (element.type ?? '').contains(ahsType));
    if (ahsResults.isNotEmpty) availableTypes.add('Animal Health Statement');
    final msaResults =
        forms!.where((element) => (element.type ?? '').contains(msaType));
    if (msaResults.isNotEmpty) availableTypes.add('MSA');
    final nfasResults =
        forms!.where((element) => (element.type ?? '').contains(nfasType));
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['serialNumber'] = serialNumber;
    return data;
  }
}

class Owner {
  Address? address;
  String? name;
  String? pic;

  Owner({this.address, this.name, this.pic});

  Owner.fromJson(Map<String, dynamic> json) {
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    name = json['name'];
    pic = json['pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['name'] = name;
    data['pic'] = pic;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['line1'] = line1;
    data['postcode'] = postcode;
    data['state'] = state;
    data['town'] = town;
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

  Declaration({
    this.accept,
    this.address,
    this.certificateNumber,
    this.date,
    this.email,
    this.fullName,
    this.phone,
    this.signature,
  });

  Declaration.fromJson(Map<String, dynamic> json) {
    accept = json['accept'];
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    certificateNumber = json['certificateNumber'];
    date = json['date'];
    email = json['email'];
    fullName = json['fullName'];
    phone = json['phone'];
    signature = json['signature'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accept'] = accept;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['certificateNumber'] = certificateNumber;
    data['date'] = date;
    data['email'] = email;
    data['fullName'] = fullName;
    data['phone'] = phone;
    data['signature'] = signature;
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

  Questions(
      {this.id,
      this.text,
      this.help,
      this.type,
      this.acceptableAnswers,
      this.childQuestions});

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    help = json['help'];
    type = json['type'];
    if (json['acceptableAnswers'] != null) {
      acceptableAnswers = <AcceptableAnswers>[];
      json['acceptableAnswers'].forEach((v) {
        acceptableAnswers!.add(AcceptableAnswers.fromJson(v));
      });
    }
    if (json['childQuestions'] != null) {
      childQuestions = <ChildQuestions>[];
      json['childQuestions'].forEach((v) {
        childQuestions!.add(ChildQuestions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['text'] = text;
    data['help'] = help;
    data['type'] = type;
    if (acceptableAnswers != null) {
      data['acceptableAnswers'] =
          acceptableAnswers!.map((v) => v.toJson()).toList();
    }
    if (childQuestions != null) {
      data['childQuestions'] = childQuestions!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['displayName'] = displayName;
    data['value'] = value;
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

  ChildQuestions(
      {this.id,
      this.text,
      this.help,
      this.type,
      this.acceptableAnswers,
      this.triggers});

  ChildQuestions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    help = json['help'];
    type = json['type'];
    if (json['acceptableAnswers'] != null) {
      acceptableAnswers = <AcceptableAnswers>[];
      json['acceptableAnswers'].forEach((v) {
        acceptableAnswers!.add(AcceptableAnswers.fromJson(v));
      });
    }
    if (json['triggers'] != null) {
      triggers = <Triggers>[];
      json['triggers'].forEach((v) {
        triggers!.add(Triggers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['text'] = text;
    data['help'] = help;
    data['type'] = type;
    if (acceptableAnswers != null) {
      data['acceptableAnswers'] =
          acceptableAnswers!.map((v) => v.toJson()).toList();
    }
    if (triggers != null) {
      data['triggers'] = triggers!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['questionId'] = questionId;
    data['value'] = value;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['questionId'] = questionId;
    data['value'] = value;
    data['index'] = index;
    return data;
  }
}
