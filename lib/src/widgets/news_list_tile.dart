import 'dart:async';
import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../blocs/stories_provider.dart';

class NewsListTile extends StatelessWidget {
  final int itemId;

  const NewsListTile({Key? key, required this.itemId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    return StreamBuilder(
        stream: bloc.items,
        builder:
            (context, AsyncSnapshot<Map<int, Future<ItemModel?>>> snapshot) {
          if (!snapshot.hasData) {
            return Text('Stream still loading $itemId');
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final item = snapshot.data![itemId];

          return FutureBuilder(
              future: item,
              builder: (context, AsyncSnapshot<ItemModel?> itemSnapshot) {
                if (!itemSnapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return buildTile(itemSnapshot.data!);
              });
        });
  }

  Widget buildTile(ItemModel item) {
    return Column(children: [
      ListTile(
        title: Text(item.title),
        subtitle: Text('${item.score} votes'),
        trailing: Column(
          children: <Widget>[
            const Icon(Icons.comment),
            Text('${item.descendants}'),
          ],
        ),
      ),
      const Divider(
        height: 8.0,
      )
    ]);
  }
}
