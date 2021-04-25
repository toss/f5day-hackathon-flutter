import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:style_book/api/item_api.dart';
import 'package:style_book/model/item_model.dart';

class ItemProvider with ChangeNotifier, DiagnosticableTreeMixin {
  final ItemApi _api;

  List<Item> items = [];

  ItemProvider(this._api);

  getItemList(String shopName) {
    items.clear();
    //notifyListeners();
    _api.fetchPage(shopName).then((value) {
      print("items $value");
      items.addAll(value);
      notifyListeners();
    });
  }
}
