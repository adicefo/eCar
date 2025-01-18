import 'package:json_annotation/json_annotation.dart';

part 'companyPrice.g.dart';

@JsonSerializable()
class CompanyPrice {
  int? id;
  double? pricePerKilometar;
  DateTime? addingDate;

  CompanyPrice({this.id, this.pricePerKilometar, this.addingDate});

  factory CompanyPrice.fromJson(Map<String, dynamic> json) =>
      _$CompanyPriceFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyPriceToJson(this);
}
