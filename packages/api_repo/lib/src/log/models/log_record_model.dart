// ignore_for_file: public_member_api_docs, sort_constructors_first
class LogRecordModel {
  final String form;
  final String id;
  final String geofenceId;
  final String pic;
  final bool isExiting;


  LogRecordModel({
    this.isExiting = false,
    required this.form,
    required this.id,
    required this.geofenceId,
    required this.pic,
  });

  factory LogRecordModel.fromJson(Map<String, dynamic> json) {
    return LogRecordModel(
      form: json['form'],
      id: json['id'],
      geofenceId: json['geofenceId'],
      pic: json['pic'],
      isExiting: json['isExiting'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'form': form,
      'id': id,
      'geofenceId': geofenceId,
      'pic': pic,
      'isExiting': isExiting,
    };
  }
}
