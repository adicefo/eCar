import 'dart:convert';

import 'package:ecar_mobile/models/Rent/rent.dart';
import 'package:ecar_mobile/providers/base_provider.dart';

class RentProvider extends BaseProvider<Rent> {
  RentProvider() : super("Rent");
  @override
  Rent fromJson(data) {
    return Rent.fromJson(data);
  }
}
