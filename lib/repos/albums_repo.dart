import 'package:connectivity/connectivity.dart';
import 'package:musicapp/models/result.dart';
import 'package:musicapp/networking/apis/details_api.dart';
import 'package:musicapp/networking/apis/search_api.dart';
import 'package:musicapp/networking/generic/errors.dart';
import 'package:musicapp/networking/models/album_details.dart';
import 'package:musicapp/networking/models/search_result_list.dart';
import 'package:rxdart/rxdart.dart';

class AlbumsRepo {
  final DetailsApi _detailsApi;
  final SearchApi _searchApi;
  final Connectivity _connectivity;

  AlbumsRepo({
    DetailsApi? detailsApi,
    SearchApi? searchApi,
    Connectivity? connectivity,
  })  : _detailsApi = detailsApi ?? DetailsApi(),
        _searchApi = searchApi ?? SearchApi(),
        _connectivity = connectivity ?? Connectivity();

  Stream<Result<SearchResultList>> searchFor(String key, {int? page}) {
    return Stream.fromFuture(_connectivity.checkConnectivity())
        .flatMap((value) {
      if (value != ConnectivityResult.none) {
        return _searchApi
            .search(key, page: page)
            .map((event) => Result.done(event))
            .onErrorReturnWith((error, stackTrace) {
          if (error is ApiError) {
            return Result<SearchResultList>.error(error);
          } else {
            return Result<SearchResultList>.error(
                ApiError.fromUnknownError(error));
          }
        });
      } else {
        return Stream.value(
            Result<SearchResultList>.error(ApiError.noInternetError()));
      }
    }).startWith(Result<SearchResultList>.inProgress());
  }

  Stream<Result<AlbumDetails>> details(SearchItem item) {
    return Stream.fromFuture(_connectivity.checkConnectivity())
        .flatMap((value) {
      if (value != ConnectivityResult.none) {
        return _detailsApi
            .details(item)
            .map((event) => Result.done(event))
            .onErrorReturnWith((error, stackTrace) {
          if (error is ApiError) {
            return Result<AlbumDetails>.error(error);
          } else {
            return Result<AlbumDetails>.error(ApiError.fromUnknownError(error));
          }
        });
      } else {
        return Stream.value(
            Result<AlbumDetails>.error(ApiError.noInternetError()));
      }
    }).startWith(Result<AlbumDetails>.inProgress());
  }
}
