import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicapp/models/result.dart';
import 'package:musicapp/networking/models/search_result_list.dart';
import 'package:musicapp/rx/dispose_bag.dart';
import 'package:musicapp/rx/rx_listener.dart';
import 'package:musicapp/screens/details/details_screen.dart';
import 'package:musicapp/screens/search/search_view_model.dart';
import 'package:musicapp/views/items/search_result_list_item.dart';
import 'package:musicapp/views/states/disposable_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends DisposableState<SearchScreen> {
  late SearchViewModel _viewModel;
  late ScrollController _controller;
  UIData? _uiData;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _viewModel = SearchViewModel(
        input: Input(
            controller: TextEditingController(),
            clearButtonListener: RxListener(),
            loadMore: RxListener(),
            searchListener: RxListener()));
    _bindViewModel();
  }

  void _bindViewModel() {
    _viewModel.output.data.listen((event) {
      setState(() {
        _uiData = event;
      });
    }).disposeBy(bag);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Music App"),
      ),
      body: Column(
        children: [_textField(), Expanded(child: _body())],
      ),
    );
  }

  Widget _body() {
    if (_uiData == null) {
      return Container(
        alignment: Alignment.center,
        child: Text(
          "Search for albums",
          style: Theme.of(context).textTheme.headline3,
        ),
      );
    } else if (_uiData?.status == ResultStatus.error) {
      return Container(
        alignment: Alignment.center,
        child: Text(
          "Search error: ${_uiData?.errorMessage ?? ""}",
          style: Theme.of(context)
              .textTheme
              .headline3
              ?.copyWith(color: Colors.red),
        ),
      );
    } else if (_uiData?.status == ResultStatus.progres) {
      if ((_uiData?.resultList?.results.isEmpty ?? true)) {
        return Container(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        );
      }
      return _searchList();
    } else {
      if (_uiData?.resultList != null) {
        if ((_uiData?.resultList?.results.length ?? 0) > 0) {
          return _searchList();
        } else {
          return Container(
            alignment: Alignment.center,
            child: Text(
              "No results found for your serch",
              style: Theme.of(context).textTheme.headline3,
            ),
          );
        }
      }
    }
    return Container(
      alignment: Alignment.center,
      child: Text(
        "Search for albums",
        style: Theme.of(context).textTheme.headline3,
      ),
    );
  }

  Widget _textField() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10)),
            child: TextField(
              controller: _viewModel.input.controller,
              decoration: InputDecoration(
                  hintText: "Search for album",
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.highlight_remove_outlined),
                    onPressed: _viewModel.input.clearButtonListener.onPressed,
                  )),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: ElevatedButton(
            onPressed: _viewModel.input.searchListener.onPressed,
            style: ElevatedButton.styleFrom(
                primary: (_uiData?.enableSearch ?? false)
                    ? Colors.blue
                    : Colors.grey),
            child: Text("Search"),
          ),
        )
      ],
    );
  }

  Widget _searchList() {
    List<SearchItem>? list = _uiData?.resultList?.results;
    if (list == null) {
      return Container();
    }
    return NotificationListener<ScrollNotification>(
      child: ListView.builder(
        controller: _controller,
        itemBuilder: (context, index) {
          return SearchResultListItem(
            item: list[index],
            onTap: (SearchItem value) {
              Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
                return AlbumDetailsScreen(
                  searchItem: value,
                );
              }));
            },
          );
        },
        itemCount: list.length,
      ),
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          if (_controller.position.extentAfter == 0) {
            _viewModel.input.loadMore.onPressed();
          }
        }

        return false;
      },
    );
  }
}
