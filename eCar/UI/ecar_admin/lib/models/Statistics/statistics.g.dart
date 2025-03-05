// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Statistics _$StatisticsFromJson(Map<String, dynamic> json) => Statistics(
      id: (json['id'] as num?)?.toInt(),
      numberOfHours: (json['numberOfHours'] as num?)?.toInt(),
      numberOfClients: (json['numberOfClients'] as num?)?.toInt(),
      priceAmount: (json['priceAmount'] as num?)?.toDouble(),
      beginningOfWork: json['beginningOfWork'] == null
          ? null
          : DateTime.parse(json['beginningOfWork'] as String),
      endOfWork: json['endOfWork'] == null
          ? null
          : DateTime.parse(json['endOfWork'] as String),
      driverId: (json['driverId'] as num?)?.toInt(),
      driver: json['driver'] == null
          ? null
          : Driver.fromJson(json['driver'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StatisticsToJson(Statistics instance) =>
    <String, dynamic>{
      'id': instance.id,
      'numberOfHours': instance.numberOfHours,
      'numberOfClients': instance.numberOfClients,
      'priceAmount': instance.priceAmount,
      'beginningOfWork': instance.beginningOfWork?.toIso8601String(),
      'endOfWork': instance.endOfWork?.toIso8601String(),
      'driverId': instance.driverId,
      'driver': instance.driver,
    };
