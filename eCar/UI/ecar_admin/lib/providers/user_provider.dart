import "dart:convert";

import "package:ecar_admin/models/Route/route.dart";
import "package:ecar_admin/providers/base_provider.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:http/http.dart" as http;
import "package:http/http.dart";
import 'package:ecar_admin/models/User/user.dart' as Model;

class UserProvider extends BaseProvider<Model.User> {
  UserProvider() : super("Users");
  @override
  Model.User fromJson(data) {
    return Model.User.fromJson(data);
  }

  Future<Model.User> getUserFromToken() async {
    var headers = await createHeaders();
    var token = headers['Authorization']?.substring(7);
    var url = "${getBaseUrl()}Users/token/$token";
    var uri = Uri.parse(url);
    var response = await http.get(uri, headers: headers);
    print(response.body);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var result = Model.User.fromJson(data);
      return result;
    } else {
      throw Exception("Unknown error in GET request");
    }
  }
}
