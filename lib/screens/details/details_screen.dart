import 'package:flutter/material.dart';
import 'package:musicapp/extensions/numbers.dart';
import 'package:musicapp/models/result.dart';
import 'package:musicapp/networking/models/album_details.dart';
import 'package:musicapp/networking/models/search_result_list.dart';
import 'package:musicapp/rx/dispose_bag.dart';
import 'package:musicapp/rx/rx_listener.dart';
import 'package:musicapp/screens/details/details_view_model.dart';
import 'package:musicapp/views/states/disposable_state.dart';
import 'package:transparent_image/transparent_image.dart';

class AlbumDetailsScreen extends StatefulWidget {
  final SearchItem searchItem;

  const AlbumDetailsScreen({Key? key, required this.searchItem})
      : super(key: key);

  @override
  _AlbumDetailsScreenState createState() => _AlbumDetailsScreenState();
}

class _AlbumDetailsScreenState extends DisposableState<AlbumDetailsScreen> {
  late AlbumDetailsViewModel _viewModel;
  Result<AlbumDetails>? _albumDetails;

  @override
  void initState() {
    super.initState();
    _viewModel = AlbumDetailsViewModel(Input(screenLoad: RxValueChanged()));
    _viewModel.output.details.listen((event) {
      setState(() {
        _albumDetails = event;
      });
    }).disposeBy(bag);
    _viewModel.input.screenLoad.onLoad(widget.searchItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _body()),
      appBar: AppBar(
        title: Text("Details"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Widget _body() {
    if (_albumDetails == null ||
        _albumDetails?.status == ResultStatus.progres) {
      return Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      );
    }
    AlbumDetails? details = _albumDetails?.data;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          if (details?.mediumImage?.url.isNotEmpty ?? false)
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: [
                  Center(
                    child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        fit: BoxFit.cover,
                        image: details?.largeImage?.url ?? ''),
                  ),
                  Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      top: MediaQuery.of(context).size.width * 0.5,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.5),
                              Colors.white.withOpacity(0.5)
                            ],
                          ),
                        ),
                      )),
                  Positioned(
                      bottom: 14,
                      left: 14,
                      right: 14,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Artist: ${details?.artist ?? ""}",
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                ?.copyWith(color: Colors.white),
                          ),
                          Text(
                            "Listeners: ${details?.listeners ?? ""}",
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                ?.copyWith(color: Colors.white),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          Text(
            "Tracks",
            style: Theme.of(context).textTheme.headline5,
          ),
          ..._tracks()
        ],
      ),
    );
  }

  List<Widget> _tracks() {
    return _albumDetails?.data?.tracks?.map((e) {
          return Container(
            margin: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(child: Text("${e.name}")),
                Text("${e.duration.timeString()}")
              ],
            ),
          );
        })?.toList() ??
        [];
  }
}
