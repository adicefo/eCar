import 'dart:convert';

import 'package:ecar_mobile/models/Driver/driver.dart';
import 'package:ecar_mobile/models/DriverVehicle/driverVehicle.dart';
import 'package:ecar_mobile/providers/base_provider.dart';

class DriverVehicleProvider extends BaseProvider<DriverVehicle> {
  DriverVehicleProvider() : super("DriverVehicle");
  @override
  DriverVehicle fromJson(data) {
    return DriverVehicle.fromJson(data);
  }

  Future<DriverVehicle?> updateFinish(dynamic request) async {
    var url = "${getBaseUrl()}DriverVehicle/UpdateFinish";
    var uri = Uri.parse(url);
    var headers = await createHeaders();
    var body = jsonEncode(request);

    var response = await http!.put(uri, headers: headers, body: body);
    if (response.statusCode == 204) {
      return null;
    }
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else if (response.statusCode == 204) {
      return null;
    } else {
      throw Exception("Unknown error in PUT request");
    }
  }

  Future<bool> checkIfAssigned(int? driverId) async {
    var url = "${getBaseUrl()}DriverVehicle/CheckIfAssigned/$driverId";
    var uri = Uri.parse(url);
    var headers = await createHeaders();

    var response = await http!.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data['isAssigned'] ?? false;
    } else {
      throw Exception("Error checking assignment: ${response.statusCode}");
    }
  }
}
