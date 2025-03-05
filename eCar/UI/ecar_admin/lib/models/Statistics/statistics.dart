import 'package:ecar_admin/models/Driver/driver.dart';
import 'package:json_annotation/json_annotation.dart';

part 'statistics.g.dart';

@JsonSerializable()
class Statistics {
  int? id;
  int? numberOfHours;
  int? numberOfClients;
  double? priceAmount;
  DateTime? beginningOfWork;
  DateTime? endOfWork;
  int? driverId;
  Driver? driver;

  Statistics(
      {this.id,
      this.numberOfHours,
      this.numberOfClients,
      this.priceAmount,
      this.beginningOfWork,
      this.endOfWork,
      this.driverId,
      this.driver});

  factory Statistics.fromJson(Map<String, dynamic> json) =>
      _$StatisticsFromJson(json);

  Map<String, dynamic> toJson() => _$StatisticsToJson(this);
}
