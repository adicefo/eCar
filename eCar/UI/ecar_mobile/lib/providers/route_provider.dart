import "dart:convert";

import "package:ecar_mobile/models/Route/route.dart";
import "package:ecar_mobile/providers/base_provider.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:http/http.dart";
import 'package:ecar_mobile/models/Route/route.dart' as Model;

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

    var response = await http!.put(uri, headers: headers);
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
}
