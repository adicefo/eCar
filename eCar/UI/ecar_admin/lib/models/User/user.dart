import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  int? id;
  String? name;
  String? surname;
  String? username;
  String? email;
  String? telephoneNumber;
  String? gender;
  DateTime? registrationDate;
  bool? isActive;

  User({
    this.id,
    this.name,
    this.surname,
    this.username,
    this.email,
    this.telephoneNumber,
    this.gender,
    this.registrationDate,
    this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
