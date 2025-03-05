import "package:ecar_admin/models/DriverVehicle/driverVehicle.dart";

import "package:ecar_admin/providers/base_provider.dart";

class DriverVehicleProvider extends BaseProvider<DriverVehicle> {
  DriverVehicleProvider() : super("DriverVehicle");
  @override
  DriverVehicle fromJson(data) {
    return DriverVehicle.fromJson(data);
  }
}
