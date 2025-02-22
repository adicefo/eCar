import 'dart:convert';

import 'package:ecar_mobile/models/Rent/rent.dart';
import 'package:ecar_mobile/providers/base_provider.dart';

class RentProvider extends BaseProvider<Rent> {
  RentProvider() : super("Rent");
  @override
  Rent fromJson(data) {
    return Rent.fromJson(data);
  }

  Future<Rent> updatePaymant(int? id) async {
    var url = "${getBaseUrl()}Rent/UpdatePayment/$id";
    var uri = Uri.parse(url);
    var headers = await createHeaders();

    var response = await http!.put(uri, headers: headers);
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
