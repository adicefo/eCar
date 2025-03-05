import "package:ecar_admin/models/Admin/admin.dart";

import "package:ecar_admin/providers/base_provider.dart";

class AdminProvider extends BaseProvider<Admin> {
  AdminProvider() : super("Admin");
  @override
  Admin fromJson(data) {
    return Admin.fromJson(data);
  }
}
