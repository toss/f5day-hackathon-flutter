import 'dart:async';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:style_book/api/api_service.dart';

import '../model/shop_model.dart';

class ProductApi extends AbstractApi {
  ProductApi() : super("https://toss.vn/v1/hackathon/stylebook/shop");

  Future<List<Shop>> fetchPage(String? name) async {
    //filter[name]=Herzig
    String query;

    if (name != null) {
      // ignore: unnecessary_statements
      query = '?filter[name]=$name';
    } else {
      // ignore: unnecessary_statements
      query = "";
    }

    String path = '$baseUrl$query';
    List<Shop> list = [];
    var response = await http.get(Uri.parse(path));
    /*.then((response) => response.body)
        .then(convert.jsonDecode)
        .then((shop) =>
            shop['shop'].forEach((model) => list.add(Product.fromJson(model))));*/

    if (response.statusCode == 200) {
      final decodeJson = convert.jsonDecode(response.body);
      List shop = decodeJson['shop'];
      print('http: $decodeJson');
      shop.forEach((element) => list.add(Shop.fromJson(element)));
    }
    print('Number of books about http: $list');

    return list;
  }
}
