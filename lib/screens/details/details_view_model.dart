import 'package:musicapp/models/result.dart';
import 'package:musicapp/networking/models/album_details.dart';
import 'package:musicapp/networking/models/search_result_list.dart';
import 'package:musicapp/repos/albums_repo.dart';
import 'package:musicapp/rx/rx_listener.dart';
import 'package:rxdart/rxdart.dart';

class AlbumDetailsViewModel {
  late Output _output;
  final AlbumsRepo _albumsRepo;
  final Input input;

  Output get output => _output;

  AlbumDetailsViewModel(
    this.input, {
    AlbumsRepo? albumsRepo,
  }) : _albumsRepo = albumsRepo ?? AlbumsRepo() {
    _output = Output(
        details: input.screenLoad.didChange
            .flatMap((value) => _albumsRepo.details(value)));
  }
}

class Input {
  final RxValueChanged<SearchItem> screenLoad;

  const Input({
    required this.screenLoad,
  });
}

class Output {
  final Stream<Result<AlbumDetails>> details;

  const Output({
    required this.details,
  });
}
