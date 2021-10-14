import 'package:musicapp/networking/generic/api.dart';
import 'package:musicapp/networking/models/search_result_list.dart';
import 'package:rxdart/rxdart.dart';

class SearchApi extends Api {
  static final _accessCodesPath = "2.0/";
  static final _method = "album.search";

  Stream<SearchResultList> search(String key,
      {int? page = 1, int count = 30, String? apiKey, String? format}) {
    return request.flatMap((value) {
      return value.post(_accessCodesPath, params: {
        "album": key,
        "page": "$page",
        "limit": "$count",
        "format": format ?? apiConfig.responseFormat,
        "api_key": apiKey ?? apiConfig.apiKey,
        "method": _method,
      }).map((event) => SearchResultList.fromJson(event));
    });
  }
}
