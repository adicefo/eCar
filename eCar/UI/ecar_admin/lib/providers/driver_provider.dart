import "dart:convert";

import "package:ecar_admin/models/Route/route.dart";
import "package:ecar_admin/providers/base_provider.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:http/http.dart" as http;
import "package:http/http.dart";
import 'package:ecar_admin/models/Driver/driver.dart';

class DriverProvider extends BaseProvider<Driver> {
  DriverProvider() : super("Driver");
  @override
  Driver fromJson(data) {
    return Driver.fromJson(data);
  }
}