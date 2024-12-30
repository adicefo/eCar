import 'package:ecar_admin/models/Driver/driver.dart';
import 'package:ecar_admin/utils/PointDTO/point_dto.dart';
import 'package:ecar_admin/models/Client/client.dart' as Model;
import 'package:ecar_admin/models/Client/client.dart';
import 'package:http/http.dart';

import 'package:json_annotation/json_annotation.dart';

part 'route.g.dart';

@JsonSerializable()
class Route {
  int? id;
  Pointdto? sourcePoint;
  Pointdto? destinationPoint;
  String? status;
  DateTime? startDate;
  DateTime? endDate;
  int? duration;
  double? numberOfKilometars;
  double? fullPrice;
  int? driverId;
  int? clientId;
  Driver? driver;
  Model.Client? client;
  Route(
      {this.id,
      this.sourcePoint,
      this.destinationPoint,
      this.status,
      this.startDate,
      this.endDate,
      this.duration,
      this.numberOfKilometars,
      this.fullPrice,
      this.driverId,
      this.clientId,
      this.driver,
      this.client});

  factory Route.fromJson(Map<String, dynamic> json) => _$RouteFromJson(json);

  Map<String, dynamic> toJson() => _$RouteToJson(this);
}
