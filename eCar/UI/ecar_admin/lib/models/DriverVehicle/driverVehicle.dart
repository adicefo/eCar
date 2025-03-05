import 'package:ecar_admin/models/Driver/driver.dart';
import 'package:ecar_admin/models/Vehicle/vehicle.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driverVehicle.g.dart';

@JsonSerializable()
class DriverVehicle {
  int? id;
  int? driverId;
  int? vehicleId;
  DateTime? datePickUp;
  DateTime? dateDropOff;
  Driver? driver;
  Vehicle? vehicle;

  DriverVehicle(
      {this.id,
      this.driverId,
      this.vehicleId,
      this.datePickUp,
      this.dateDropOff,
      this.driver,
      this.vehicle});

  factory DriverVehicle.fromJson(Map<String, dynamic> json) =>
      _$DriverVehicleFromJson(json);

  Map<String, dynamic> toJson() => _$DriverVehicleToJson(this);
}
