import 'package:json_annotation/json_annotation.dart';
part 'notification.g.dart';

@JsonSerializable()
class Notification {
  int? id;
  String? heading;
  String? content_;
  String? image;
  DateTime? addingDate;
  bool? isForClient;
  String? status;

  Notification({
    this.id,
    this.heading,
    this.content_,
    this.image,
    this.addingDate,
    this.isForClient,
    this.status,
  });

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}
