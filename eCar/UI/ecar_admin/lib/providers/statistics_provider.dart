import "package:ecar_admin/models/Statistics/statistics.dart";

import "package:ecar_admin/providers/base_provider.dart";

class StatisticsProvider extends BaseProvider<Statistics> {
  StatisticsProvider() : super("Statistics");
  @override
  Statistics fromJson(data) {
    return Statistics.fromJson(data);
  }
}
