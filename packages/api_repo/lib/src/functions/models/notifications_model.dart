import 'package:api_repo/api_repo.dart';

class NotificationResponseModel {
  String? status;
  List<SentNotification>? data;

  NotificationResponseModel({this.status, this.data});

  NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <SentNotification>[];
      json['data'].forEach((v) {
        data!.add(SentNotification.fromJson(v));
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

class SentNotification {
  int? id;
  List<String>? user;
  DateTime? notificationDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  Geofence? geofence;
  UserData? createdBy;

  SentNotification(
      {this.id, this.user, this.notificationDate, this.createdAt, this.updatedAt, this.geofence, this.createdBy});

  SentNotification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'].cast<String>();
    notificationDate = DateTime.tryParse(json['notificationDate'])?.toLocal();
    createdAt = _toDate(json['createdAt']);
    updatedAt = _toDate(json['updatedAt']);
    geofence = json['geofence'] != null ? Geofence.fromJson(json['geofence']) : null;
    createdBy = json['createdBy'] != null ? UserData.fromJson(json['createdBy']) : null;
  }

  DateTime? _toDate(String? date) => date != null ? DateTime.tryParse(date)?.toLocal() : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user'] = user;
    data['notificationDate'] = notificationDate;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (geofence != null) {
      data['geofence'] = geofence!.toJson();
    }
    if (createdBy != null) {
      data['createdBy'] = createdBy!.toJson();
    }
    return data;
  }
}
