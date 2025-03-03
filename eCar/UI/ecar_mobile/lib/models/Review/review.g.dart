// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
      id: (json['id'] as num?)?.toInt(),
      value: (json['value'] as num?)?.toInt(),
      description: json['description'] as String?,
      reviewsId: (json['reviewsId'] as num?)?.toInt(),
      reviewedId: (json['reviewedId'] as num?)?.toInt(),
      addedDate: json['addedDate'] == null
          ? null
          : DateTime.parse(json['addedDate'] as String),
      routeId: (json['routeId'] as num?)?.toInt(),
      reviewed: json['reviewed'] == null
          ? null
          : Driver.fromJson(json['reviewed'] as Map<String, dynamic>),
      reviews: json['reviews'] == null
          ? null
          : Client.fromJson(json['reviews'] as Map<String, dynamic>),
      route: json['route'] == null
          ? null
          : Route.fromJson(json['route'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
      'description': instance.description,
      'reviewsId': instance.reviewsId,
      'reviewedId': instance.reviewedId,
      'addedDate': instance.addedDate?.toIso8601String(),
      'routeId': instance.routeId,
      'reviewed': instance.reviewed,
      'reviews': instance.reviews,
      'route': instance.route,
    };
