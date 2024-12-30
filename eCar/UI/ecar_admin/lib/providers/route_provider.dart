import "dart:convert";

import "package:ecar_admin/models/Route/route.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:http/http.dart" as http;
import "package:http/http.dart";
import 'package:ecar_admin/models/Route/route.dart' as Model;

class RouteProvider {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  RouteProvider() {}

  Future<List<Route>> get() async {
    var url = "https://localhost:7257/Route";
    var uri = Uri.parse(url);
    var headers = await createHeaders();
    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var result =
          data.map((e) => Model.Route.fromJson(e)).toList().cast<Route>();
      return result;
    } else {
      throw new Exception("Unknown exception");
    }
  }

  bool isValidResponse(Response response) {
    if (response.statusCode < 299) {
      return true;
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    } else {
      var body = jsonDecode(response.body);
      throw Exception(body['title']);
    }
  }

  Future<Map<String, String>> createHeaders() async {
    String token = await _storage.read(key: "jwt") ?? "";
    String bearerAuth = "Bearer $token";
    var headers = {
      "Content-Type": "application/json",
      "Authorization": bearerAuth
    };

    return headers;
  }
}
