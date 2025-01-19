import 'dart:convert';
import 'dart:io';

import 'package:ecar_mobile/main.dart';
import 'package:ecar_mobile/models/Auth/login_response.dart';
import 'package:ecar_mobile/utils/authorization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http/io_client.dart';

class AuthProvider with ChangeNotifier {
  static String? _baseUrl;
  String _endpoint = "";
  final _storage = const FlutterSecureStorage();
  HttpClient client = HttpClient();
  IOClient? http;
  AuthProvider(String endpoint) {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "https://10.0.2.2:7257/");
    _endpoint = endpoint;

    if (_baseUrl!.endsWith("/") == false) {
      _baseUrl = "${_baseUrl!}/";
    }
    client.badCertificateCallback = (cert, host, port) => true;
    http = IOClient(client);
  }

  Future<LoginResponse> login() async {
    var url = "$_baseUrl$_endpoint";
    var uri = Uri.parse(url);

    var body = {
      "email": Authorization.email,
      "password": Authorization.password
    };
    var headers = await createHeaders();
    var response =
        await http!.post(uri, headers: headers, body: jsonEncode(body));

    if (isValidResponse(response)) {
      var data = LoginResponse.fromJson(jsonDecode(response.body));
      if (data.result == 0) {
        _storage.write(key: "jwt", value: data.token);
      }
      return data;
    } else {
      throw Exception("Unknown error");
    }
  }

  void logout(BuildContext context) {
    _storage.delete(key: "jwt");
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  bool isValidResponse(Response response) {
    if (response.statusCode < 299) {
      return true;
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    } else {
      throw Exception(
          "${response.statusCode} Something bad happened, please try again later.");
    }
  }

  Future<Map<String, String>> createHeaders() async {
    String token = await _storage.read(key: "jwt") ?? "";
    String bearerAuth = "Bearer $token";
    var headers = {
      "Content-Type": "application/json",
    };

    if (token != "") {
      headers["Authorization"] = bearerAuth;
    }

    return headers;
  }
}
