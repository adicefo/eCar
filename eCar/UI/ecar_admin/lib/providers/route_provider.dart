import "dart:convert";

import "package:ecar_admin/models/Route/route.dart";
import "package:ecar_admin/providers/base_provider.dart";
import "package:ecar_admin/utils/string_helpers.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:http/http.dart" as http;
import "package:http/http.dart";
import 'package:ecar_admin/models/Route/route.dart' as Model;

class RouteProvider extends BaseProvider<Route> {
  RouteProvider() : super("Route");
  @override
  Route fromJson(data) {
    return Route.fromJson(data);
  }

  Future<Route> updateFinish(int? id) async {
    var url = "${getBaseUrl()}Route/Finish/$id";
    var uri = Uri.parse(url);
    var headers = await createHeaders();

    var response = await http.put(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var result = Route.fromJson(data);
      return result;
    } else if (response.statusCode == 204) {
      return Route();
    } else {
      throw Exception("Unknown error in PUT request");
    }
  }

  Future<double> getForReport(dynamic filter) async {
    var url = "${getBaseUrl()}Route/GetForReport";
    var queryString = StringHelpers.getQueryString(filter);
    url = "$url?$queryString";
    var uri = Uri.parse(url);
    var headers = await createHeaders();

    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      print("Amount is: ${data['fullAmount']}");
      return data['fullAmount'] ?? 0.0;
    } else if (response.statusCode == 204) {
      return 0.0;
    } else {
      throw Exception("Unknown error in GET request");
    }
  }
}
