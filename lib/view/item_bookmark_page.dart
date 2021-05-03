import 'package:advertising_id/advertising_id.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:style_book/log/event_log.dart';
import 'package:style_book/provider/item_provider.dart';
import 'package:style_book/provider/shop_provider.dart';

class ItemBookmarkPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ItemBookmarkState();
}

class ItemBookmarkState extends State<ItemBookmarkPage> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ItemProvider>(context, listen: false);
    AdvertisingId.id(true).then((id) {
      if (id != null) {
        provider.fetchBookmarkList(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkItems =
        Provider.of<ItemProvider>(context, listen: true).bookmarkItemList;

    final shopProvider = Provider.of<ShopProvider>(context, listen: true);

    return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 12),
        itemCount: bookmarkItems.length,
        shrinkWrap: true,
        controller: ScrollController(),
        padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
        itemBuilder: (context, index) {
          final item = bookmarkItems[index];
          return InkWell(
            onTap: () {
              EventLog.sendEventLog("click_bookmark_item",
                  eventProperties: {'item': item.toJson(item)});
              shopProvider.requestShopInfo(item);
              // _launchUrl(url: item.postUrl ?? "", title: _shop.name);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AnimatedSwitcher(
                child: item.getFirstImage(),
                duration: Duration(seconds: 1),
              ),
            ),
          );
        });
  }
}
