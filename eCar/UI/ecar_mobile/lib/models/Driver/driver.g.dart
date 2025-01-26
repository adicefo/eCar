// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Driver _$DriverFromJson(Map<String, dynamic> json) => Driver(
      id: (json['id'] as num?)?.toInt(),
      userID: (json['userID'] as num?)?.toInt(),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      numberOfHoursAmount: (json['numberOfHoursAmount'] as num?)?.toInt(),
      numberOfClientsAmount: (json['numberOfClientsAmount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DriverToJson(Driver instance) => <String, dynamic>{
      'id': instance.id,
      'userID': instance.userID,
      'user': instance.user,
      'numberOfHoursAmount': instance.numberOfHoursAmount,
      'numberOfClientsAmount': instance.numberOfClientsAmount,
    };
