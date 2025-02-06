// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Request _$RequestFromJson(Map<String, dynamic> json) => Request(
      id: (json['id'] as num?)?.toInt(),
      isAccepted: json['isAccepted'] as bool?,
      routeId: (json['routeId'] as num?)?.toInt(),
      driverId: (json['driverId'] as num?)?.toInt(),
      driver: json['driver'] == null
          ? null
          : Driver.fromJson(json['driver'] as Map<String, dynamic>),
      route: json['route'] == null
          ? null
          : Route.fromJson(json['route'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RequestToJson(Request instance) => <String, dynamic>{
      'id': instance.id,
      'isAccepted': instance.isAccepted,
      'routeId': instance.routeId,
      'driverId': instance.driverId,
      'driver': instance.driver,
      'route': instance.route,
    };
