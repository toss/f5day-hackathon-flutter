import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:style_book/api/bookmark_api.dart';
import 'package:style_book/api/item_api.dart';
import 'package:style_book/model/bookmark_model.dart';
import 'package:style_book/model/item_model.dart';

class ItemProvider with ChangeNotifier, DiagnosticableTreeMixin {
  final ItemApi _api;

  final BookmarkApi _bookmarkApi;

  List<Item> items = [];

  List<Item>? _showWindowList;

  List<Item> get showWindowList => _showWindowList ?? List.empty();

  List<Item>? _bookmarkItemList;

  List<Item> get bookmarkItemList => _bookmarkItemList ?? List.empty();

  ItemProvider(this._api, this._bookmarkApi);

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

  updateBookmark(String userId, int itemId, bool isBookmark) {
    int onOff;
    if (isBookmark) {
      onOff = 1;
    } else {
      onOff = 0;
    }
    final request = BookmarkRequest(userId, itemId, onOff);
    _bookmarkApi.postBookmark(request).then((result) {
      if (result) {
        fetchBookmarkList(userId);
      }
    });
  }

  fetchBookmarkList(String userId) async {
    final bookmarkList = await _bookmarkApi.getBookmark(userId);
    var items = await _api.fetchPage("");

    items.where((element) {
      return true;
    });

    var bookmarkItems = items.where((item) {
      return bookmarkList.any((bookmark) {
        return item.id == bookmark.itemId;
      });
    });

    _bookmarkItemList = bookmarkItems.toList();
    notifyListeners();
  }

  bool isBookmark(Item item) {
    return _bookmarkItemList?.any((element) {
          return element.id == item.id;
        }) ??
        false;
  }
}
