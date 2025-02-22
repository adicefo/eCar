// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rent _$RentFromJson(Map<String, dynamic> json) => Rent(
      id: (json['id'] as num?)?.toInt(),
      rentingDate: json['rentingDate'] == null
          ? null
          : DateTime.parse(json['rentingDate'] as String),
      endingDate: json['endingDate'] == null
          ? null
          : DateTime.parse(json['endingDate'] as String),
      numberOfDays: (json['numberOfDays'] as num?)?.toInt(),
      fullPrice: (json['fullPrice'] as num?)?.toDouble(),
      paid: json['paid'] as bool?,
      status: json['status'] as String?,
      vehicleId: (json['vehicleId'] as num?)?.toInt(),
      clientId: (json['clientId'] as num?)?.toInt(),
      client: json['client'] == null
          ? null
          : Client.fromJson(json['client'] as Map<String, dynamic>),
      vehicle: json['vehicle'] == null
          ? null
          : Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RentToJson(Rent instance) => <String, dynamic>{
      'id': instance.id,
      'rentingDate': instance.rentingDate?.toIso8601String(),
      'endingDate': instance.endingDate?.toIso8601String(),
      'numberOfDays': instance.numberOfDays,
      'fullPrice': instance.fullPrice,
      'paid': instance.paid,
      'status': instance.status,
      'vehicleId': instance.vehicleId,
      'clientId': instance.clientId,
      'client': instance.client,
      'vehicle': instance.vehicle,
    };
