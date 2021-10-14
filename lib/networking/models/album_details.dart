import 'package:collection/collection.dart';
import 'package:musicapp/extensions/collections.dart';
import 'package:musicapp/networking/models/search_result_list.dart';

class AlbumDetails {
  final String artist;
  final List<ItemImage> images;

  final List<Track> tracks;
  final int listeners;
  final int playcount;

  final Wiki wiki;

  const AlbumDetails({
    required this.artist,
    required this.images,
    required this.tracks,
    required this.listeners,
    required this.playcount,
    required this.wiki,
  });

  ItemImage? get mediumImage {
    return images.firstWhereOrNull(
      (element) => element.type == "medium",
    );
  }

  ItemImage? get largeImage {
    return images.firstWhereOrNull(
      (element) => element.type == "extralarge",
    );
  }

  factory AlbumDetails.fromJson(Map<dynamic, dynamic> json) {
    Map<dynamic, dynamic> album = json["album"];
    List<ItemImage> jsonImages = [];
    List<Track> jsonTracks = [];
    if (album["image"] != null && album["image"] is List) {
      jsonImages = List.from(album["image"])
          .where((element) => element is Map)
          .map((e) => Map.from(e))
          .map((e) => ItemImage.fromJson(e))
          .toList();
    }
    if (album["tracks"] != null &&
        album["tracks"] is Map &&
        album["tracks"]["track"] != null &&
        album["tracks"]["track"] != null is List) {
      jsonTracks = List.from(album["tracks"]["track"])
          .where((element) => element is Map)
          .map((e) => Map.from(e))
          .map((e) => Track.fromJson(e))
          .toList();
    }

    return AlbumDetails(
        artist: album.stringValue('artist'),
        images: jsonImages,
        tracks: jsonTracks,
        listeners: album.intValue("listeners"),
        playcount: album.intValue("playcount"),
        wiki: Wiki.fromJson(album.mapValue("wiki")));
  }
}

class Track {
  final int duration;
  final String url;
  final String name;

  const Track({
    required this.duration,
    required this.url,
    required this.name,
  });

  factory Track.fromJson(Map<dynamic, dynamic> json) {
    return Track(
        duration: json.intValue('duration'),
        url: json.stringValue('url'),
        name: json['name']);
  }
}

class Wiki {
  final String published;
  final String summary;
  final String content;

  const Wiki({
    required this.published,
    required this.summary,
    required this.content,
  });

  factory Wiki.fromJson(Map<dynamic, dynamic> json) {
    return Wiki(
        published: json.stringValue('published'),
        summary: json.stringValue('summary'),
        content: json.stringValue('content'));
  }
}
