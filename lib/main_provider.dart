import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:style_book/api/shop_api.dart';

import 'model/shop_model.dart';

class MainProvider with ChangeNotifier, DiagnosticableTreeMixin {
  List<Shop> items = [];

  final ProductApi _productApi;

  MainProvider(this._productApi);

  void getProductList() {
    _productApi.fetchPage(null).then((value) {
      items.clear();
      items.addAll(value);
      notifyListeners();
    });
  }
}
