import 'package:ecar_mobile/models/Driver/driver.dart';
import 'package:ecar_mobile/models/Route/route.dart';
import 'package:json_annotation/json_annotation.dart';

part 'request.g.dart';

@JsonSerializable()
class Request {
  int? id;
  bool? isAccepted;
  int? routeId;
  int? driverId;
  Driver? driver;
  Route? route;
  Request(
      {this.id,
      this.isAccepted,
      this.routeId,
      this.driverId,
      this.driver,
      this.route});

  factory Request.fromJson(Map<String, dynamic> json) =>
      _$RequestFromJson(json);

  Map<String, dynamic> toJson() => _$RequestToJson(this);
}
