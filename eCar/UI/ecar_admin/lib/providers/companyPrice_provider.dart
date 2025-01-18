import 'dart:convert';

import 'package:ecar_admin/models/CompanyPrice/companyPrice.dart';
import 'package:ecar_admin/models/Driver/driver.dart';
import 'package:ecar_admin/providers/base_provider.dart';
import "package:http/http.dart" as http;

class CompanyPriceProvider extends BaseProvider<CompanyPrice> {
  CompanyPriceProvider() : super("CompanyPrice");
  @override
  CompanyPrice fromJson(data) {
    return CompanyPrice.fromJson(data);
  }

  Future<CompanyPrice> getCurrentPrice() async {
    var url = "${getBaseUrl()}CompanyPrice/GetCurrenPrice";
    var uri = Uri.parse(url);
    var headers = await createHeaders();

    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var result = CompanyPrice.fromJson(data);
      return result;
    } else if (response.statusCode == 204) {
      return CompanyPrice();
    } else {
      throw Exception("Unknown error in GET request");
    }
  }
}
