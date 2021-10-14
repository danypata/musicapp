import 'package:collection/collection.dart';
import 'package:musicapp/extensions/collections.dart';

class SearchResultList {
  final int availableResults;
  final int index;
  final int itemsPerPage;
  final List<SearchItem> results;

  SearchResultList copyWith({
    int? availableResults,
    int? index,
    int? itemsPerPage,
    List<SearchItem>? results,
  }) {
    return SearchResultList(
      availableResults: availableResults ?? this.availableResults,
      index: index ?? this.index,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      results: results ?? this.results,
    );
  }

  const SearchResultList({
    required this.availableResults,
    required this.index,
    required this.itemsPerPage,
    required this.results,
  });

  factory SearchResultList.fromJson(Map<dynamic, dynamic> json) {
    List<SearchItem> results = [];
    json = json["results"] as Map<dynamic, dynamic>;

    if (json["albummatches"] != null) {
      var matches = json["albummatches"];
      if (matches is Map<dynamic, dynamic> &&
          matches["album"] != null &&
          matches["album"] is List<dynamic>) {
        results = List.from(matches["album"])
            .where((element) => element is Map<dynamic, dynamic>)
            .map((e) => Map.from(e as Map))
            .map((e) => SearchItem.fromJson(e))
            .toList();
      }
    }
    Map<String, dynamic> queryData = json["opensearch:Query"];
    int page = queryData.intValue("startPage");
    return SearchResultList(
        availableResults: json.intValue("opensearch:totalResults"),
        index: page,
        itemsPerPage: json.intValue("opensearch:itemsPerPage"),
        results: results);
  }
}

class SearchItem {
  String name;
  String artist;
  String url;
  bool streamable;
  String id;
  List<ItemImage> images;

  ItemImage? get mediumImage {
    return images.firstWhereOrNull(
      (element) => element.type == "medium",
    );
  }

  ItemImage? get largeImage {
    return images.firstWhereOrNull(
      (element) => element.type == "large",
    );
  }

  SearchItem({
    required this.name,
    required this.artist,
    required this.url,
    required this.streamable,
    required this.id,
    required this.images,
  });

  factory SearchItem.fromJson(Map<dynamic, dynamic> json) {
    List<ItemImage> images = [];
    if (json["image"] != null) {
      images = List.from(json["image"] as List)
          .map((e) => Map.from(e as Map))
          .map((e) => ItemImage.fromJson(e))
          .toList();
    }
    return SearchItem(
        name: json.stringValue("name"),
        artist: json.stringValue("artist"),
        url: json.stringValue("url"),
        streamable: json.boolValue("streamable"),
        id: json.stringValue("mbid"),
        images: images);
  }
}

class ItemImage {
  final String url;
  final String type;

  const ItemImage({
    required this.url,
    required this.type,
  });

  factory ItemImage.fromJson(Map<dynamic, dynamic> json) {
    return ItemImage(
        url: "${json["#text"] ?? ""}", type: "${json["size"] ?? "medium"}");
  }

  ItemImage copyWith({
    String? url,
    String? type,
  }) {
    return ItemImage(
      url: url ?? this.url,
      type: type ?? this.type,
    );
  }
}
