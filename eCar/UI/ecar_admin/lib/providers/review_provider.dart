import 'dart:convert';

import 'package:ecar_admin/models/Review/review.dart';
import 'package:ecar_admin/providers/base_provider.dart';
import 'package:ecar_admin/utils/string_helpers.dart';
import "package:http/http.dart" as http;

class ReviewProvider extends BaseProvider<Review> {
  ReviewProvider() : super("Review");
  @override
  Review fromJson(data) {
    return Review.fromJson(data);
  }

  Future<Map<String, dynamic>> getForReport(dynamic filter) async {
    var url = "${getBaseUrl()}Review/GetForReport";
    var queryString = StringHelpers.getQueryString(filter);
    url = "$url?$queryString";
    var uri = Uri.parse(url);
    var headers = await createHeaders();

    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      print(response.body);
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Unknown error in GET request");
    }
  }
}
