import 'package:flutter/cupertino.dart';
import 'package:musicapp/models/result.dart';
import 'package:musicapp/networking/models/search_result_list.dart';
import 'package:musicapp/repos/albums_repo.dart';
import 'package:musicapp/rx/rx_listener.dart';
import 'package:rxdart/rxdart.dart';

class SearchViewModel {
  final AlbumsRepo _albumsRepo;
  final Input input;

  late Output _output;

  Output get output => _output;

  SearchResultList? _lastResult;

  SearchViewModel({
    required this.input,
    AlbumsRepo? albumsRepo,
  }) : _albumsRepo = albumsRepo ?? AlbumsRepo() {
    Stream<UIData> result = input.searchListener.rxOnPressed.flatMap((value) {
      return _albumsRepo.searchFor(input.controller.text);
    }).map((event) {
      _lastResult = event.data;
      return UIData(event.status, event.data, false, event.apiError?.message);
    });
    PublishSubject<UIData> clear = PublishSubject();
    input.controller.addListener(() {
      if (input.controller.text.isEmpty) {
        clear.add(UIData(ResultStatus.done, _lastResult, false, null));
      } else {
        clear.add(UIData(ResultStatus.done, _lastResult, true, null));
      }
    });
    Stream<UIData> clearButton =
        input.clearButtonListener.rxOnPressed.map((event) {
      input.controller.text = "";
      return UIData(ResultStatus.done, _lastResult, true, null);
    });
    Stream<UIData> loadMore = input.loadMore.rxOnPressed
        .flatMap((value) {
          if ((_lastResult?.results?.length ?? 0) <
              (_lastResult?.availableResults ?? 0)) {
            return _albumsRepo.searchFor(input.controller.text,
                page: (_lastResult?.index ?? 0) + 1);
          }
          return Stream.value(null);
        })
        .where((event) => event != null)
        .map((event) => event!)
        .map((data) {
          _lastResult = _lastResult?.copyWith(
              index: data.data?.index ?? 1,
              results: _lastResult?.results?..addAll(data.data?.results ?? []));
          return UIData(data.status, _lastResult, true, data.apiError?.message);
        });
    _output = Output(Rx.merge([
      result,
      clear.startWith(UIData(ResultStatus.done, _lastResult, false, null)),
      clearButton,
      loadMore
    ]));
  }
}

class Input {
  final TextEditingController controller;
  final RxListener clearButtonListener;
  final RxListener searchListener;
  final RxListener loadMore;

  const Input({
    required this.controller,
    required this.clearButtonListener,
    required this.searchListener,
    required this.loadMore,
  });
}

class Output {
  final Stream<UIData> data;

  Output(this.data);
}

class UIData {
  final ResultStatus status;
  final SearchResultList? resultList;
  final bool enableSearch;
  final String? errorMessage;

  UIData(this.status, this.resultList, this.enableSearch, this.errorMessage);
}
