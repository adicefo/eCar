import 'package:ecar_mobile/models/User/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver.g.dart';

@JsonSerializable()
class Driver {
  int? id;
  int? userID;
  User? user;
  int? numberOfHoursAmount;
  int? numberOfClientsAmount;

  Driver(
      {this.id,
      this.userID,
      this.user,
      this.numberOfHoursAmount,
      this.numberOfClientsAmount});

  factory Driver.fromJson(Map<String, dynamic> json) => _$DriverFromJson(json);

  Map<String, dynamic> toJson() => _$DriverToJson(this);
}
