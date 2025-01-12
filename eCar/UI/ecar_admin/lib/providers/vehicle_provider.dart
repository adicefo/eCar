import "dart:convert";

import "package:ecar_admin/models/Route/route.dart";
import "package:ecar_admin/models/Vehicle/vehicle.dart";
import "package:ecar_admin/providers/base_provider.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:http/http.dart" as http;
import "package:http/http.dart";

class VehicleProvider extends BaseProvider<Vehicle> {
  VehicleProvider() : super("Vehicle");
  @override
  Vehicle fromJson(data) {
    return Vehicle.fromJson(data);
  }
}
