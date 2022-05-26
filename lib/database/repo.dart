import 'news_db_provider.dart';
import '../services/news_api_services.dart';
import 'dart:async';
import '../models/item_model.dart';

class Repository {
  // NewsDbProvider dbProvider = NewsDbProvider();
  // NewsApiProvider apiProvider = NewsApiProvider();

  List<Source> sources = <Source>[
    newsDbProvider,
    NewsDbProvider(),
  ];

  List<Cache> caches = <Cache>[
    newsDbProvider,
  ];

  Future<List<int>> fetchTopIds() => apiProvider.fetchTopIds();

  Future<ItemModel> fetchItem(int id) async {
    ItemModel? item;
    Source source;

    for (source in sources) {
      item = await source.fetchItem(id);

      if (item != null) {
        break;
      }
    }

    for (var cache in caches) {
      cache.addItem(item!);
    }

    return item!;
  }
}

abstract class Source {
  Future<List<int>>? fetchTopIds();
  Future<ItemModel>? fetchItem(int id);
}

abstract class Cache {
  Future<int>? addItem(ItemModel item);
}
