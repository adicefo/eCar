import "dart:convert";

import "package:ecar_admin/models/Route/route.dart";
import "package:ecar_admin/providers/base_provider.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:http/http.dart" as http;
import "package:http/http.dart";
import 'package:ecar_admin/models/Client/client.dart' as Model;

class ClientProvider extends BaseProvider<Model.Client> {
  ClientProvider() : super("Client");
  @override
  Model.Client fromJson(data) {
    return Model.Client.fromJson(data);
  }
}
