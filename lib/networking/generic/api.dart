import 'package:musicapp/networking/config/api_config.dart';
import 'package:musicapp/networking/generic/request.dart';

class Api {
  final ApiConfig apiConfig;

  Api({ApiConfig? config}) : apiConfig = config ?? ApiConfig();

  Stream<Request> get request {
    return Stream.value(RequestBuilder().newRequest(config: apiConfig));
  }
}
