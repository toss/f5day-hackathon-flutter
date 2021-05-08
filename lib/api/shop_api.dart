import 'dart:async';
import 'dart:convert' as convert;

import 'package:style_book/api/api_service.dart';

import '../model/shop_model.dart';

class ShopApi extends AbstractApi {
  static const String _url = "https://phobobunbo-cmomufjvuq-as.a.run.app/shops";

  ShopApi() : super(_url);

  Future<List<Shop>> fetchPage(String? name) async {
    String query;

    if (name != null) {
      query = '/$name';
    } else {
      query = "";
    }

    String path = '$baseUrl$query';
    List<Shop> list = [];
    var response =
        await httpGet(Uri.parse(path)); //await http.get(Uri.parse(path));

    if (response.statusCode == 200) {
      Iterable decodeJson = convert.jsonDecode(response.body);
      list.addAll(List<Shop>.from(decodeJson.map((e) => Shop.fromJson(e))));
      print('http decodeJson : $decodeJson');
    } else {
      print("http : $response");
    }
    print('Number of books about http: $list');

    return list;
  }

  Future<Shop?> getShop(String shopNameId) async {
    //shop_name_id=thedelia.45ochodua

    if (shopNameId.isEmpty) {
      return null;
    }

    String path = "$baseUrl?shop_name_id=$shopNameId";
    print("getShop path : $path");
    final response = await httpGet(Uri.parse(path));
    if (response.statusCode == 200) {
      return Shop.fromJson(convert.jsonDecode(response.body)[0]);
    } else {
      return null;
    }
  }
}
