// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
      id: (json['id'] as num?)?.toInt(),
      heading: json['heading'] as String?,
      content_: json['content_'] as String?,
      image: json['image'] as String?,
      addingDate: json['addingDate'] == null
          ? null
          : DateTime.parse(json['addingDate'] as String),
      isForClient: json['isForClient'] as bool?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'heading': instance.heading,
      'content_': instance.content_,
      'image': instance.image,
      'addingDate': instance.addingDate?.toIso8601String(),
      'isForClient': instance.isForClient,
      'status': instance.status,
    };
