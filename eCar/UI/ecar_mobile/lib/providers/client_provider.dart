import 'package:ecar_mobile/models/Client/client.dart' as Model;
import 'package:ecar_mobile/providers/base_provider.dart';

class ClientProvider extends BaseProvider<Model.Client> {
  ClientProvider() : super("Client");
  @override
  Model.Client fromJson(data) {
    return Model.Client.fromJson(data);
  }
}
