import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../blocs/stories_provider.dart';
import '../widgets/news_list_tile.dart';
import '../widgets/refresh.dart';

class NewsList extends StatelessWidget {
  const NewsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    return Scaffold(
      appBar: AppBar(
          title: const Text('Hacker News'),
          titleTextStyle: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24.0, color: Colors.black),
          backgroundColor: Color(int.parse('FFFF6600', radix: 16)),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          )),
      body: buildList(bloc),
    );
  }

  Widget buildList(StoriesBloc bloc) {
    return StreamBuilder(
        stream: bloc.topIds,
        builder: (context, AsyncSnapshot<List<int>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return Refresh(
              child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, int index) {
              bloc.fetchItem(snapshot.data![index]);
              return NewsListTile(itemId: snapshot.data![index]);
            },
          ));
        });
  }
}
