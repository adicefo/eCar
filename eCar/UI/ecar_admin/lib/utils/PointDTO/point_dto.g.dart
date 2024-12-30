// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pointdto _$PointdtoFromJson(Map<String, dynamic> json) => Pointdto(
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      SRID: (json['SRID'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PointdtoToJson(Pointdto instance) => <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'SRID': instance.SRID,
    };
