import 'package:ecar_admin/models/Client/client.dart';
import 'package:ecar_admin/models/Driver/driver.dart';
import 'package:ecar_admin/models/Route/route.dart';
import 'package:json_annotation/json_annotation.dart';

part 'review.g.dart';

@JsonSerializable()
class Review {
  int? id;
  int? value;
  String? description;
  int? reviewsId;
  int? reviewedId;
  int? routeId;
  Driver? reviewed;
  Client? reviews;
  Route? route;

  Review(
      {this.id,
      this.value,
      this.description,
      this.reviewsId,
      this.reviewedId,
      this.routeId,
      this.reviewed,
      this.reviews,
      this.route});

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}
