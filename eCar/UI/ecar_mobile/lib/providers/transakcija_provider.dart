import 'dart:convert';

import 'package:ecar_mobile/models/KategorijaTransakcije25062025/kategorijaTransakcije25062025.dart';
import 'package:ecar_mobile/models/Notification/notification.dart';
import 'package:ecar_mobile/models/Transkacija25062025/transakcija25062025.dart';
import 'package:ecar_mobile/providers/base_provider.dart';
import 'package:ecar_mobile/utils/string_helpers.dart';

class TransakcijaProvider extends BaseProvider<Transakcija25062025> {
  TransakcijaProvider() : super("Transakcija25062025");
  @override
  Transakcija25062025 fromJson(data) {
    return Transakcija25062025.fromJson(data);
  }

  Future<dynamic> getTotalHrana(dynamic filter) async {
    var url = "${getBaseUrl()}Transakcija25062025/GetTotalHrana";
    var queryString = StringHelpers.getQueryString(filter);
    url = "$url?$queryString";
    var uri = Uri.parse(url);
    var headers = await createHeaders();

    var response = await http!.get(uri, headers: headers);
    if (isValidResponse(response)) {
      print(response.body);
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Unknown error in GET request");
    }
  }

  Future<dynamic> getTotalPlata(dynamic filter) async {
    var url = "${getBaseUrl()}Transakcija25062025/GetTotalPlata";
    var queryString = StringHelpers.getQueryString(filter);
    url = "$url?$queryString";
    var uri = Uri.parse(url);
    var headers = await createHeaders();

    var response = await http!.get(uri, headers: headers);
    if (isValidResponse(response)) {
      print(response.body);
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Unknown error in GET request");
    }
  }

  Future<dynamic> getTotalZabava(dynamic filter) async {
    var url = "${getBaseUrl()}Transakcija25062025/GetTotalZabava";
    var queryString = StringHelpers.getQueryString(filter);
    url = "$url?$queryString";
    var uri = Uri.parse(url);
    var headers = await createHeaders();

    var response = await http!.get(uri, headers: headers);
    if (isValidResponse(response)) {
      print(response.body);
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Unknown error in GET request");
    }
  }
}
