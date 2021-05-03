import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:style_book/api/shop_api.dart';

import '../model/item_model.dart';
import '../model/shop_model.dart';

class ShopProvider with ChangeNotifier, DiagnosticableTreeMixin {
  StreamController<ItemDetailEvent?> _shopInfoStream =
      StreamController<ItemDetailEvent?>.broadcast();

  Stream<ItemDetailEvent?> get shopInfoStream => _shopInfoStream.stream;

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

  requestShopInfo(Item item) {
    _shopApi.getShop(item.shopNameId).then((value) {
      print("requestShopInfo $value");
      if (value == null) {
        return;
      }
      _shopInfoStream.add(ItemDetailEvent(value, item));
    });
  }

  String findShopName(Item item) {
    if (shopList.isEmpty) {
      return "";
    }

    return shopList.firstWhere((shop) {
          return shop.nameId == item.shopNameId;
        }).nameDisplay ??
        "";
  }
}

class ItemDetailEvent {
  Shop shop;

  Item item;

  ItemDetailEvent(this.shop, this.item);
}
