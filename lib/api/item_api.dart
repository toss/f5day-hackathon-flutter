import 'dart:async';
import 'dart:convert' as convert;

import 'package:style_book/api/api_service.dart';
import 'package:style_book/model/item_model.dart';

class ItemApi extends AbstractApi {
  static const String _url = "https://phobobunbo-cmomufjvuq-as.a.run.app/items";

  ItemApi() : super(_url);

  Future<List<Item>> fetchPage(String shopName) async {
    //filter[name]=Herzig
    String path;

    if (shopName.isEmpty) {
      path = baseUrl;
    } else {
      path = '$baseUrl?shop_name_id=$shopName';
    }

    print('ItemApi http: path $path');
    List<Item> list = [];
    var response = await httpGet(Uri.parse(path));
    if (response.statusCode == 200) {
      Iterable decodeJson = convert.jsonDecode(response.body);
      list.addAll(List<Item>.from(decodeJson.map((e) => Item.fromJson(e))));
    }
    print('ItemApi http result: $list');

    return list;
  }
}
