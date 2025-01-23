import 'package:ecar_mobile/models/Notification/notification.dart';
import 'package:ecar_mobile/providers/base_provider.dart';

class NotificationProvider extends BaseProvider<Notification> {
  NotificationProvider() : super("Notification");
  @override
  Notification fromJson(data) {
    return Notification.fromJson(data);
  }
}
