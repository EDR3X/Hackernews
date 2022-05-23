import 'dart:convert';

import 'package:http/http.dart' show Client;
import '../models/item_model.dart';

const _root = 'https://hacker-news.firebaseio.com/v0';

class NewsApiProvider {
  Client client = Client();

  fetchTopIds() async {
    Uri url = Uri.parse('$_root/topstories.json');

    final res = await client.get(url);
    final ids = json.decode(res.body);

    return ids;
  }

  fetchItem(int id) async {
    Uri url = Uri.parse('$_root/item/$id.json');

    final res = await client.get(url);
    final out = json.decode(res.body);

    return ItemModel.fromJson(out);
  }
}
