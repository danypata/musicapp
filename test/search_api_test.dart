import 'package:musicapp/networking/apis/search_api.dart';
import 'package:musicapp/networking/config/api_config.dart';
import 'package:test/test.dart';

void main() {
  test('Test successfull api cal', () {
    ApiConfig().setEnv(ConfigEnv.staging);
    SearchApi api = SearchApi();

    api.search("ramm").listen(expectAsync1((event) {
      expect(event, isNotNull);
      expect(event.index, equals(0));
      expect(event.itemsPerPage, equals(30));
      expect(event.availableResults, isNot(0));
    }));
  });

  test('Test succesffull api params', () {
    ApiConfig().setEnv(ConfigEnv.staging);
    SearchApi api = SearchApi();

    api.search("ramm", page: 2, count: 20).listen(expectAsync1((event) {
      expect(event, isNotNull);
      expect(event.index, equals(2));
      expect(event.itemsPerPage, equals(20));
      expect(event.availableResults, isNot(0));
    }));
  });
}
