// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      surname: json['surname'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      telephoneNumber: json['telephoneNumber'] as String?,
      gender: json['gender'] as String?,
      registrationDate: json['registrationDate'] == null
          ? null
          : DateTime.parse(json['registrationDate'] as String),
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'surname': instance.surname,
      'username': instance.username,
      'email': instance.email,
      'telephoneNumber': instance.telephoneNumber,
      'gender': instance.gender,
      'registrationDate': instance.registrationDate?.toIso8601String(),
      'isActive': instance.isActive,
    };
