// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sos_notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SosNotification _$SosNotificationFromJson(Map<String, dynamic> json) =>
    SosNotification(
      id: json['id'] as int,
      notificationDate:
          SosNotification._parseDate(json['notificationDate'] as String?),
      locationUrl: json['locationUrl'] as String,
      createdAt: SosNotification._parseDate(json['createdAt'] as String?),
      updatedAt: SosNotification._parseDate(json['updatedAt'] as String?),
      createdBy: json['createdBy'] == null
          ? null
          : UserData.fromJson(json['createdBy'] as Map<String, dynamic>),
      sosDate: SosNotification._parseDate(json['sosDate'] as String?),
      geofence: json['geofence'] == null
          ? null
          : Geofence.fromJson(json['geofence'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SosNotificationToJson(SosNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'notificationDate': instance.notificationDate?.toIso8601String(),
      'locationUrl': instance.locationUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'sosDate': instance.sosDate?.toIso8601String(),
      'createdBy': instance.createdBy,
      'geofence': instance.geofence,
    };
