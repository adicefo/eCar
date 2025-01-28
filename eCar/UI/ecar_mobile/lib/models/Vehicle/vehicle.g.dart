// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vehicle _$VehicleFromJson(Map<String, dynamic> json) => Vehicle(
      id: (json['id'] as num?)?.toInt(),
      available: json['available'] as bool?,
      averageConsumption: (json['averageConsumption'] as num?)?.toDouble(),
      name: json['name'] as String?,
      image: json['image'] as String?,
      price: (json['price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$VehicleToJson(Vehicle instance) => <String, dynamic>{
      'id': instance.id,
      'available': instance.available,
      'averageConsumption': instance.averageConsumption,
      'name': instance.name,
      'image': instance.image,
      'price': instance.price,
    };
