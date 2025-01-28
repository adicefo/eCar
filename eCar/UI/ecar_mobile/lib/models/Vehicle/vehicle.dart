import 'package:json_annotation/json_annotation.dart';

part 'vehicle.g.dart';

@JsonSerializable()
class Vehicle {
  int? id;
  bool? available;
  double? averageConsumption;
  String? name;
  String? image;
  double? price;

  Vehicle(
      {this.id,
      this.available,
      this.averageConsumption,
      this.name,
      this.image,
      this.price});

  factory Vehicle.fromJson(Map<String, dynamic> json) =>
      _$VehicleFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleToJson(this);
}
