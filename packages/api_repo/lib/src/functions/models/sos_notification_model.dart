// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:api_repo/api_repo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sos_notification_model.g.dart';

@JsonSerializable()
class SosNotification {
  final int id;
  // final String? user;

  @JsonKey(name: 'notificationDate', fromJson: _parseDate)
  final DateTime? notificationDate;
  final String locationUrl;

  @JsonKey(name: 'createdAt', fromJson: _parseDate)
  final DateTime createdAt;

  @JsonKey(name: 'updatedAt', fromJson: _parseDate)
  final DateTime updatedAt;

  @JsonKey(name: 'sosDate', fromJson: _parseDate)
  final DateTime? sosDate;

  final UserData? createdBy;
  final Geofence? geofence;

  SosNotification({
    required this.id,
    // this.user,
    required this.notificationDate,
    required this.locationUrl,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.sosDate,
    required this.geofence,
  });

  factory SosNotification.fromJson(Map<String, dynamic> json) =>
      _$SosNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$SosNotificationToJson(this);

  static _parseDate(String? date) {
    if (date == null) return null;
    return DateTime.tryParse(date)?.toLocal();
  }
}
