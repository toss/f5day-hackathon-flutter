import 'dart:async';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:style_book/model/item_model.dart';

class ItemApi {
  String url =
      "https://api.sheety.co/c6dc9c55c800455617966a1d66e8c107/stylebook/item";

  Future<List<Item>> fetchPage(String shopName) async {
    //filter[name]=Herzig
    String path = '$url?filter[shopName]=$shopName';

    List<Item> list = [];
    var response = await http.get(Uri.parse(path));

    if (response.statusCode == 200) {
      final decodeJson = convert.jsonDecode(response.body);
      List shop = decodeJson['item'];
      print('http: $decodeJson');
      shop.forEach((element) => list.add(Item.fromJson(element)));
    }
    print('Number of books about http: $list');

    return list;
  }
}
