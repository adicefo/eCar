import "dart:convert";

import "package:ecar_admin/models/Route/route.dart";
import "package:ecar_admin/providers/base_provider.dart";
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
}
