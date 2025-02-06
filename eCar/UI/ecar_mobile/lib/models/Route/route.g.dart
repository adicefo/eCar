// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Route _$RouteFromJson(Map<String, dynamic> json) => Route(
      id: (json['id'] as num?)?.toInt(),
      sourcePoint: json['sourcePoint'] == null
          ? null
          : Pointdto.fromJson(json['sourcePoint'] as Map<String, dynamic>),
      destinationPoint: json['destinationPoint'] == null
          ? null
          : Pointdto.fromJson(json['destinationPoint'] as Map<String, dynamic>),
      status: json['status'] as String?,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      duration: (json['duration'] as num?)?.toInt(),
      numberOfKilometars: (json['numberOfKilometars'] as num?)?.toDouble(),
      fullPrice: (json['fullPrice'] as num?)?.toDouble(),
      driverID: (json['driverID'] as num?)?.toInt(),
      clientId: (json['clientId'] as num?)?.toInt(),
      driver: json['driver'] == null
          ? null
          : Driver.fromJson(json['driver'] as Map<String, dynamic>),
      client: json['client'] == null
          ? null
          : Model.Client.fromJson(json['client'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RouteToJson(Route instance) => <String, dynamic>{
      'id': instance.id,
      'sourcePoint': instance.sourcePoint,
      'destinationPoint': instance.destinationPoint,
      'status': instance.status,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'duration': instance.duration,
      'numberOfKilometars': instance.numberOfKilometars,
      'fullPrice': instance.fullPrice,
      'driverID': instance.driverID,
      'clientId': instance.clientId,
      'driver': instance.driver,
      'client': instance.client,
    };
