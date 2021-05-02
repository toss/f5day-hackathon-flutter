import 'dart:async';
import 'dart:convert' as convert;

import 'package:style_book/api/api_service.dart';

import '../model/shop_model.dart';

class ShopApi extends AbstractApi {
  static const String _url = "https://phobobunbo-cmomufjvuq-as.a.run.app/shops";

  ShopApi() : super(_url);

  Future<List<Shop>> fetchPage(String? name) async {
    //filter[name]=Herzig
    String query;

    if (name != null) {
      // ignore: unnecessary_statements
      query = '/$name';
    } else {
      // ignore: unnecessary_statements
      query = "";
    }

    String path = '$baseUrl$query';
    List<Shop> list = [];
    var response =
        await httpGet(Uri.parse(path)); //await http.get(Uri.parse(path));
    /*.then((response) => response.body)
        .then(convert.jsonDecode)
        .then((shop) =>
            shop['shop'].forEach((model) => list.add(Product.fromJson(model))));*/

    if (response.statusCode == 200) {
      Iterable decodeJson = convert.jsonDecode(response.body);
      list.addAll(List<Shop>.from(decodeJson.map((e) => Shop.fromJson(e))));
      print('http decodeJson : $decodeJson');
      //  list.addAll(List<Shop>.from(decodeJson));
      //  List shop = decodeJson['shops'];
      //   decodeJson.forEach((element) => list.add(Shop.fromJson(element)));
    } else {
      print("http : $response");
    }
    print('Number of books about http: $list');

    return list;
  }
}
