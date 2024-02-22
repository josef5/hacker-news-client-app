import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import '../models/item_model.dart';
import 'repository.dart';

class NewsDbProvider implements Source, Cache {
  late Database db;

  NewsDbProvider() {
    init();
  }

  void init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, "item.db");

    db = await openDatabase(path, version: 1,
        onCreate: (Database newDb, int version) {
      newDb.execute("""
        CREATE TABLE Items
          (
            id INTEGER PRIMARY KEY,
            type TEXT,
            by TEXT,
            time INTEGER,
            text TEXT,
            dead INTEGER,
            deleted INTEGER,
            parent INTEGER,
            kids BLOB,
            url TEXT,
            score INTEGER,
            title TEXT,
            descendants INTEGER
          )
      """);
    });
  }

  @override
  Future<List<int>> fetchTopIds() async {
    return List.empty();
  }

  @override
  Future<ItemModel?> fetchItem(int id) async {
    final maps = await db.query(
      "Items",
      columns: null,
      where: "id = ?",
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ItemModel.fromDb(maps.first);
    }

    return null;
  }

  @override
  Future<int> addItem(ItemModel item) {
    return db.insert("Items", item.toMapForDb(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<int> clear() {
    return db.delete("Items");
  }
}

final newsDbProvider = NewsDbProvider();
