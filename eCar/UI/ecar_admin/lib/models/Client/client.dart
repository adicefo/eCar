import 'package:ecar_admin/models/User/user.dart';
import 'package:json_annotation/json_annotation.dart';
part 'client.g.dart';

@JsonSerializable()
class Client {
  int? id;
  int? userId;
  User? user;
  String? image;

  Client({this.id, this.userId, this.user, this.image});

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);

  Map<String, dynamic> toJson() => _$ClientToJson(this);
}
