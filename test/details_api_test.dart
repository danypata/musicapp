import 'package:musicapp/networking/apis/details_api.dart';
import 'package:musicapp/networking/config/api_config.dart';
import 'package:musicapp/networking/models/search_result_list.dart';
import 'package:test/test.dart';

void main() {
  test('Test successfull api cal with id', () {
    ApiConfig().setEnv(ConfigEnv.staging);
    DetailsApi api = DetailsApi();
    SearchItem item = SearchItem(
        name: "",
        artist: "",
        url: "",
        streamable: false,
        id: "1e0b1828-a697-48ad-b34f-51508bb02e66",
        images: []);
    api.details(item).listen(expectAsync1((event) {
      expect(event, isNotNull);
    }));
  });

  test('Test successfull api cal without id', () {
    ApiConfig().setEnv(ConfigEnv.staging);
    DetailsApi api = DetailsApi();
    SearchItem item = SearchItem(
        name: "Greatest Hits CD 1",
        artist: "Rammstein",
        url: "",
        streamable: false,
        id: "",
        images: []);
    api.details(item).listen(expectAsync1((event) {
      expect(event, isNotNull);
      expect(event.wiki, isNotNull);
    }));
  });
}
