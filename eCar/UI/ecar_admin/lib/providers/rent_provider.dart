import 'dart:convert';

import 'package:ecar_admin/models/Rent/rent.dart';
import 'package:ecar_admin/providers/base_provider.dart';
import "package:http/http.dart" as http;

class RentProvider extends BaseProvider<Rent> {
  RentProvider() : super("Rent");
  @override
  Rent fromJson(data) {
    return Rent.fromJson(data);
  }

  Future<bool> checkAvailability(int? id, dynamic request) async {
    var url = "${getBaseUrl()}Rent/ChechAvailability/$id";
    var uri = Uri.parse(url);
    var headers = await createHeaders();
    var jsonRequest = jsonEncode(request);

    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data['isAvailable'] ??
          false; // Safely extract and return the `isAvailable` field
    } else {
      throw Exception("Error checking availability: ${response.statusCode}");
    }
  }

  Future<Rent> updateActive(int? id) async {
    var url = "${getBaseUrl()}Rent/Active/$id";
    var uri = Uri.parse(url);
    var headers = await createHeaders();

    var response = await http.put(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var result = Rent.fromJson(data);
      return result;
    } else if (response.statusCode == 204) {
      return Rent();
    } else {
      throw Exception("Unknown error in PUT request");
    }
  }

  Future<Rent> updateFinish(int? id) async {
    var url = "${getBaseUrl()}Rent/Finish/$id";
    var uri = Uri.parse(url);
    var headers = await createHeaders();

    var response = await http.put(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var result = Rent.fromJson(data);
      return result;
    } else if (response.statusCode == 204) {
      return Rent();
    } else {
      throw Exception("Unknown error in PUT request");
    }
  }
}
