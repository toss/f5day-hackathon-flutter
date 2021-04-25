import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:style_book/api/shop_api.dart';

import '../model/shop_model.dart';

class ShopProvider with ChangeNotifier, DiagnosticableTreeMixin {
  List<Shop> shopList = [];

  final ShopApi _shopApi;

  ShopProvider(this._shopApi);

  void getProductList() {
    _shopApi.fetchPage(null).then((value) {
      shopList.clear();
      shopList.addAll(value);
      notifyListeners();
    });
  }
}
