import 'package:musicapp/networking/generic/api.dart';
import 'package:musicapp/networking/models/album_details.dart';
import 'package:musicapp/networking/models/search_result_list.dart';
import 'package:rxdart/rxdart.dart';

class DetailsApi extends Api {
  static final _accessCodesPath = "2.0/";
  static final _method = "album.getinfo";

  Stream<AlbumDetails> details(SearchItem item,
      {String? apiKey, String? format}) {
    return request.flatMap((value) {
      Map<String, String> params = {
        "format": format ?? apiConfig.responseFormat,
        "api_key": apiKey ?? apiConfig.apiKey,
        "method": _method
      };
      if (item.id.isNotEmpty) {
        params["mbid"] = item.id;
      } else {
        params["album"] = item.name;
        params["artist"] = item.artist;
      }

      return value
          .post(_accessCodesPath, params: params)
          .map((event) => AlbumDetails.fromJson(event));
    });
  }
}
