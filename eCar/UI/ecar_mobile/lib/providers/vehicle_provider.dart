import 'dart:convert';

import 'package:ecar_mobile/models/Vehicle/vehicle.dart';
import 'package:ecar_mobile/models/search_result.dart';
import 'package:ecar_mobile/providers/base_provider.dart';

class VehicleProvider extends BaseProvider<Vehicle> {
  VehicleProvider() : super("Vehicle");
  @override
  Vehicle fromJson(data) {
    return Vehicle.fromJson(data);
  }

  Future<SearchResult<Vehicle>> getAvailableForDriver() async {
    var headers = await createHeaders();
    var url = "${getBaseUrl()}Vehicle/GetAvailableForDriver";
    var uri = Uri.parse(url);
    var response = await http!.get(uri, headers: headers);
    print(response.body);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var result = SearchResult<Vehicle>();

      for (var item in data['result']) {
        result.result.add(fromJson(item));
      }
      result.count = data['count'];
      return result;
    } else {
      throw Exception("Unknown error in GET request");
    }
  }
}
