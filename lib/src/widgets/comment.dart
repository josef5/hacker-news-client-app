import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news/src/widgets/loading_container.dart';
import 'package:html/parser.dart' show parse;
import '../models/item_model.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel?>> itemMap;
  final int depth;

  const Comment(
      {Key? key,
      required this.itemId,
      required this.itemMap,
      required this.depth})
      : super(key: key);

  @override
  Widget build(context) {
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel?> snapshot) {
        if (!snapshot.hasData) {
          return const LoadingContainer();
        }

        final item = snapshot.data!;

        final children = <Widget>[
          ListTile(
            title: buildText(item),
            subtitle: item.by == "" ? const Text('Deleted') : Text(item.by),
            contentPadding:
                EdgeInsets.only(left: depth * 16.0 + 16.0, right: 16.0),
          ),
          const Divider()
        ];

        for (var kidId in item.kids) {
          children.add(
            Comment(itemId: kidId, itemMap: itemMap, depth: depth + 1),
          );
        }

        return Column(
          children: children,
        );
      },
    );
  }

  Widget buildText(ItemModel item) {
    final document = parse(item.text);
    final text = document.body!.text;

    return Text(text);
  }
}
