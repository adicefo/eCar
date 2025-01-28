// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driverVehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverVehicle _$DriverVehicleFromJson(Map<String, dynamic> json) =>
    DriverVehicle(
      id: (json['id'] as num?)?.toInt(),
      driverId: (json['driverId'] as num?)?.toInt(),
      vehicleId: (json['vehicleId'] as num?)?.toInt(),
      datePickUp: json['datePickUp'] == null
          ? null
          : DateTime.parse(json['datePickUp'] as String),
      dateDropOff: json['dateDropOff'] == null
          ? null
          : DateTime.parse(json['dateDropOff'] as String),
      driver: json['driver'] == null
          ? null
          : Driver.fromJson(json['driver'] as Map<String, dynamic>),
      vehicle: json['vehicle'] == null
          ? null
          : Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DriverVehicleToJson(DriverVehicle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'driverId': instance.driverId,
      'vehicleId': instance.vehicleId,
      'datePickUp': instance.datePickUp?.toIso8601String(),
      'dateDropOff': instance.dateDropOff?.toIso8601String(),
      'driver': instance.driver,
      'vehicle': instance.vehicle,
    };
