class ChemicalUseDetailsModel {
  String? field;
  FieldData? chemicalCheck;
  FieldData? qaCheck;
  FieldData? qaProgram;
  FieldData? certificateNumber;
  FieldData? cvdCheck;
  FieldData? cropList;
  FieldData? riskCheck;
  FieldData? nataCheck;

  ChemicalUseDetailsModel({
    this.field,
    this.chemicalCheck,
    this.qaCheck,
    this.qaProgram,
    this.certificateNumber,
    this.cvdCheck,
    this.cropList,
    this.riskCheck,
    this.nataCheck,
  });

  ChemicalUseDetailsModel.fromJson(Map<String, dynamic> json) {
    field = json['field'];
    chemicalCheck = json['chemicalCheck'] != null ? new FieldData.fromJson(json['chemicalCheck']) : null;
    qaCheck = json['qaCheck'] != null ? new FieldData.fromJson(json['qaCheck']) : null;
    qaProgram = json['qaProgram'] != null ? new FieldData.fromJson(json['qaProgram']) : null;
    certificateNumber = json['certificateNumber'] != null ? new FieldData.fromJson(json['certificateNumber']) : null;
    cvdCheck = json['cvdCheck'] != null ? new FieldData.fromJson(json['cvdCheck']) : null;
    cropList = json['cropList'] != null ? new FieldData.fromJson(json['cropList']) : null;
    riskCheck = json['riskCheck'] != null ? new FieldData.fromJson(json['riskCheck']) : null;
    nataCheck = json['nataCheck'] != null ? new FieldData.fromJson(json['nataCheck']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['field'] = this.field;
    if (this.chemicalCheck != null) {
      data['chemicalCheck'] = this.chemicalCheck!.toJson();
    }
    if (this.qaCheck != null) {
      data['qaCheck'] = this.qaCheck!.toJson();
    }
    if (this.qaProgram != null) {
      data['qaProgram'] = this.qaProgram!.toJson();
    }
    if (this.certificateNumber != null) {
      data['certificateNumber'] = this.certificateNumber!.toJson();
    }
    if (this.cvdCheck != null) {
      data['cvdCheck'] = this.cvdCheck!.toJson();
    }
    if (this.cropList != null) {
      data['cropList'] = this.cropList!.toJson();
    }
    if (this.riskCheck != null) {
      data['riskCheck'] = this.riskCheck!.toJson();
    }
    if (this.nataCheck != null) {
      data['nataCheck'] = this.nataCheck!.toJson();
    }
    return data;
  }
}

// class ChemicalCheck {
//   String? field;
//   String? value;
//   List<Options>? options;

//   ChemicalCheck({this.field, this.value, this.options});

//   ChemicalCheck.fromJson(Map<String, dynamic> json) {
//     field = json['field'];
//     value = json['value'];
//     if (json['options'] != null) {
//       options = <Options>[];
//       json['options'].forEach((v) {
//         options!.add(new Options.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['field'] = this.field;
//     data['value'] = this.value;
//     if (this.options != null) {
//       data['options'] = this.options!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

class Options {
  String? label;
  String? value;

  Options({this.label, this.value});

  Options.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['value'] = this.value;
    return data;
  }
}

// class QaCheck {
//   String? field;
//   String? value;
//   List<Options>? options;
//   String? note;

//   QaCheck({this.field, this.value, this.options, this.note});

//   QaCheck.fromJson(Map<String, dynamic> json) {
//     field = json['field'];
//     value = json['value'];
//     if (json['options'] != null) {
//       options = <Options>[];
//       json['options'].forEach((v) {
//         options!.add(new Options.fromJson(v));
//       });
//     }
//     note = json['note'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['field'] = this.field;
//     data['value'] = this.value;
//     if (this.options != null) {
//       data['options'] = this.options!.map((v) => v.toJson()).toList();
//     }
//     data['note'] = this.note;
//     return data;
//   }
// }

// class QaProgram {
//   String? field;
//   String? value;

//   QaProgram({this.field, this.value});

//   QaProgram.fromJson(Map<String, dynamic> json) {
//     field = json['field'];
//     value = json['value'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['field'] = this.field;
//     data['value'] = this.value;
//     return data;
//   }
// }

class FieldData {
  String? field;
  String? value;
  List<Options>? options;

  FieldData({this.field, this.options});

  FieldData.fromJson(Map<String, dynamic> json) {
    field = json['field'];
    value = json['value'];
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
    data['value'] = this.value;
    return data;
  }
}

// class CropList {
//   String? field;
//   List<String>? options;

//   CropList({this.field, this.options});

//   CropList.fromJson(Map<String, dynamic> json) {
//     field = json['field'];
//     options = List<String>.from(json['options'] ?? []);
//     // if (json['options'] != null) {
//     //   options = <Null>[];
//     //   json['options'].forEach((v) {
//     //     options!.add(new Null.fromJson(v));
//     //   });
//     // }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['field'] = this.field;
//     if (this.options != null) {
//       data['options'] = this.options;
//     }
//     return data;
//   }
// }
