import 'news_db_provider.dart';
import '../services/news_api_services.dart';
import 'dart:async';
import '../models/item_model.dart';

class Repository {
  NewsDbProvider dbProvider = NewsDbProvider();
  NewsApiProvider apiProvider = NewsApiProvider();

  fetchTopIds() => apiProvider.fetchTopIds();

  fetchItem(int id) async {
    //* looks for item in Database
    var item = await dbProvider.fetchItem(id);
    if (item != null) {
      return item;
    }

    //* fetches item from API if not found in Database.
    item = await apiProvider.fetchItem(id);

    //* then item which is not in Database is pushed in database.
    dbProvider.addItem(item);

    return item;
  }
}
