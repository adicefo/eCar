import 'package:ecar_admin/models/User/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin.g.dart';

@JsonSerializable()
class Admin {
  int? id;
  int? userId;
  User? user;

  Admin({this.id, this.userId, this.user});

  factory Admin.fromJson(Map<String, dynamic> json) => _$AdminFromJson(json);

  Map<String, dynamic> toJson() => _$AdminToJson(this);
}
