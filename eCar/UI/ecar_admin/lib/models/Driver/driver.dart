import 'package:ecar_admin/models/User/user.dart';
import 'package:json_annotation/json_annotation.dart';
part 'driver.g.dart';

@JsonSerializable()
class Driver {
  int? id;
  int? userId;
  User? user;
  int? numberOfHoursAmount;
  int? numberOfClientsAmount;

  Driver(
      {this.id,
      this.userId,
      this.user,
      this.numberOfHoursAmount,
      this.numberOfClientsAmount});

  factory Driver.fromJson(Map<String, dynamic> json) => _$DriverFromJson(json);

  Map<String, dynamic> toJson() => _$DriverToJson(this);
}
