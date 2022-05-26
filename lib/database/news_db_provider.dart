import 'dart:async';
import 'dart:io';

import 'package:hackernews/database/repo.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/item_model.dart';

class NewsDbProvider implements Source, Cache {
  Database? db;

  NewsDbProvider() {
    init();
  }

  @override
  Future<List<int>> fetchTopIds() => null!;

  void init() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, "Items.db");
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) {
        newDb.execute(
          """
          CREATE TABLE Items
            (
              id INTEGER PRIMARY KEY,
              type TEXT,
              by TEXT,
              time INTEGER,
              parent INTEGER,
              kids BLOB,
              dead INTEGER,
              deleted INTEGER,
              url TEXT,
              score INTEGER,
              title TEXT,
              descendants INTEGER
            )
        """,
        );
      },
    );
  }

  @override
  Future<ItemModel> fetchItem(int id) async {
    final maps = await db?.query(
      "Items",
      columns: null,
      where: "id = ?",
      whereArgs: [id],
    );

    if (maps!.isNotEmpty) {
      return ItemModel.fromDb(maps.first);
    }

    return null!;
  }

  //* This function adds items to database
  @override
  Future<int>? addItem(ItemModel item) => db?.insert(
        "Items",
        item.toMapForDb(),
      );
}

final newsDbProvider = NewsDbProvider();
