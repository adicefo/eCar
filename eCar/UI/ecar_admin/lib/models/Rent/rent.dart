import 'package:ecar_admin/models/Client/client.dart';
import 'package:ecar_admin/models/Vehicle/vehicle.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rent.g.dart';

@JsonSerializable()
class Rent {
  int? id;
  DateTime? rentingDate;
  DateTime? endingDate;
  int? numberOfDays;
  double? fullPrice;
  String? status;
  int? vehicleId;
  int? clientId;
  Client? client;
  Vehicle? vehicle;

  Rent(
      {this.id,
      this.rentingDate,
      this.endingDate,
      this.numberOfDays,
      this.fullPrice,
      this.status,
      this.vehicleId,
      this.clientId,
      this.client,
      this.vehicle});

  factory Rent.fromJson(Map<String, dynamic> json) => _$RentFromJson(json);

  Map<String, dynamic> toJson() => _$RentToJson(this);
}
