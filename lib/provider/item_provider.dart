import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:style_book/api/item_api.dart';
import 'package:style_book/model/item_model.dart';

class ItemProvider with ChangeNotifier, DiagnosticableTreeMixin {
  final ItemApi _api;

  List<Item> items = [];

  List<Item>? _showWindowList;

  List<Item> get showWindowList => _showWindowList ?? List.empty();

  ItemProvider(this._api);

  getItemList(String shopName) {
    //notifyListeners();
    _api.fetchPage(shopName).then((value) {
      items.clear();
      print("items $value");
      items.addAll(value);
      notifyListeners();
    });
  }

  fetchShowWindowList() {
    _api.fetchPage("").then((value) {
      _showWindowList = value;
      notifyListeners();
    });
  }
}
