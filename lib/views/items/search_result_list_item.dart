import 'package:flutter/material.dart';
import 'package:musicapp/networking/models/search_result_list.dart';
import 'package:transparent_image/transparent_image.dart';

class SearchResultListItem extends StatelessWidget {
  final SearchItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: Offset(2, 3),
            blurRadius: 5)
      ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 10),
            width: 80,
            height: 80,
            child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: item?.mediumImage?.url ?? ''),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${item.artist}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "${item.name}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  const SearchResultListItem({
    required this.item,
  });
}
