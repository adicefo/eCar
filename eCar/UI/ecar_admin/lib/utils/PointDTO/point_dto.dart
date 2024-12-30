import 'package:json_annotation/json_annotation.dart';

part 'point_dto.g.dart';

@JsonSerializable()
class Pointdto {
  double? latitude;
  double? longitude;
  int? SRID;

  Pointdto({this.latitude, this.longitude, this.SRID});

  // From JSON
  factory Pointdto.fromJson(Map<String, dynamic> json) =>
      _$PointdtoFromJson(json);

  // To JSON
  Map<String, dynamic> toJson() => _$PointdtoToJson(this);
}
