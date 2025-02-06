import 'package:ecar_mobile/models/Request/request.dart';
import 'package:ecar_mobile/providers/base_provider.dart';

class RequestProvider extends BaseProvider<Request> {
  RequestProvider() : super("Request");
  @override
  Request fromJson(data) {
    return Request.fromJson(data);
  }
}
