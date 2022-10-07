// class UserFormsData {
//   UserFormsData({
//     required this.data,
//     required this.status,
//   });

//   FormData data;
//   String status;

//   factory UserFormsData.fromJson(Map<String, dynamic> json) {
//     return UserFormsData(
//       data: FormData.fromJson(json['data']),
//       status: json['status'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     data['data'] = this.data.toJson();
//     return data;
//   }
// }

// class FormData {
//   FormData({
//     required this.forms,
//     required this.qrCode,
//   });

//   List<List> forms;
//   String qrCode;

//   factory FormData.fromJson(Map<String, dynamic> json) {
//     return FormData(forms: List<List>.from(json['forms']), qrCode: json['qrCode']);
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['forms'] = forms;
//     data['qrCode'] = qrCode;
//     return data;
//   }
// }

class UserFormsData {
  String? status;
  FormsData? data;

  UserFormsData({this.status, this.data});

  UserFormsData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? FormsData.fromJson(Map<String, dynamic>.from(json['data'])) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class FormsData {
  List<Forms>? forms;
  String? qrCode;

  FormsData({this.forms, this.qrCode});

  FormsData.fromJson(Map<String, dynamic> json) {
    if (json['forms'] != null) {
      forms = <Forms>[];
      json['forms'].forEach((v) {
        forms!.add(Forms.fromJson(Map<String, dynamic>.from(v)));
      });
    }
    qrCode = json['qrCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (forms != null) {
      data['forms'] = forms!.map((v) => v.toJson()).toList();
    }
    data['qrCode'] = qrCode;
    return data;
  }
}

class Forms {
  String? id;
  List<String>? questions;

  Forms({this.id, this.questions});

  Forms.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questions = json['questions'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['questions'] = questions;
    return data;
  }
}
