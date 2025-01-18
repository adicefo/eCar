// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'companyPrice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyPrice _$CompanyPriceFromJson(Map<String, dynamic> json) => CompanyPrice(
      id: (json['id'] as num?)?.toInt(),
      pricePerKilometar: (json['pricePerKilometar'] as num?)?.toDouble(),
      addingDate: json['addingDate'] == null
          ? null
          : DateTime.parse(json['addingDate'] as String),
    );

Map<String, dynamic> _$CompanyPriceToJson(CompanyPrice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pricePerKilometar': instance.pricePerKilometar,
      'addingDate': instance.addingDate?.toIso8601String(),
    };
