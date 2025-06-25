import 'package:ecar_mobile/models/KategorijaTransakcije25062025/kategorijaTransakcije25062025.dart';
import 'package:ecar_mobile/models/Notification/notification.dart';
import 'package:ecar_mobile/providers/base_provider.dart';

class KategorijaProvider extends BaseProvider<KategorijaTransakcije25062025> {
  KategorijaProvider() : super("KategorijaTranskacije25062025");
  @override
  KategorijaTransakcije25062025 fromJson(data) {
    return KategorijaTransakcije25062025.fromJson(data);
  }
}