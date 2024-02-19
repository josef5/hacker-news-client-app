import 'dart:async';
import 'news_api_provider.dart';
import 'news_db_provider.dart';
import '../models/item_model.dart';

class Repository {
  final NewsDbProvider dbProvider = NewsDbProvider();
  final NewsApiProvider apiProvider = NewsApiProvider();

  Future<List<int>> fetchTopIds() {
    return apiProvider.fetchTopIds();
  }

  Future<ItemModel> fetchItem(int id) async {
    // First fetch from DB
    var item = await dbProvider.fetchItem(id);

    if (item != null) {
      return item;
    }

    // If not found in DB, fetch from API
    item = await apiProvider.fetchItem(id);

    dbProvider.addItem(item);

    return item;
  }
}
