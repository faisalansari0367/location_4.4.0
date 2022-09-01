// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class LogbookEntryModel {
  String? status;
  List<Entries>? data;

  LogbookEntryModel({this.status, this.data});

  LogbookEntryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Entries>[];
      json['data'].forEach((v) {
        data!.add(Entries.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Entries {
  int? id;
  String? date;
  dynamic form;
  String? createdAt;
  String? updatedAt;

  Entries({this.id, this.date, this.form, this.createdAt, this.updatedAt});

  Entries.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    // if (json['form'] != null) {
    //   // form = <Null>[];
    //   // json['form'].forEach((v) {
    //   //   form!.add(void.fromJson(v));
    //   // });
    // }
    form = json['form'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    if (form != null) {
      // data['form'] = form!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  String formmatedDate() {
    final dt = DateTime.parse(createdAt!).toLocal();
    final formatted = DateFormat('E, d MMM yyyy h:mm a').format(dt);
    return formatted;
  }

  @override
  bool operator ==(covariant Entries other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.date == date &&
        listEquals(other.form, form) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ date.hashCode ^ form.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
  }
}
