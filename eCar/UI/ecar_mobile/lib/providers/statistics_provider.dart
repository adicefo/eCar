import 'dart:convert';

import 'package:ecar_mobile/models/Statistics/statistics.dart';
import 'package:ecar_mobile/providers/base_provider.dart';

class StatisticsProvider extends BaseProvider<Statistics> {
  StatisticsProvider() : super("Statistics");
  @override
  Statistics fromJson(data) {
    return Statistics.fromJson(data);
  }

  Future<Statistics> updateFinish(int? id) async {
    var url = "${getBaseUrl()}Statistics/Finish/$id";
    var uri = Uri.parse(url);
    var headers = await createHeaders();

    var response = await http!.put(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var result = Statistics.fromJson(data);
      return result;
    } else if (response.statusCode == 204) {
      return Statistics();
    } else {
      throw Exception("Unknown error in PUT request");
    }
  }
}
