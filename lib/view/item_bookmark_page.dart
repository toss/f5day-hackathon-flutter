import 'package:advertising_id/advertising_id.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:style_book/log/event_log.dart';
import 'package:style_book/provider/item_provider.dart';
import 'package:style_book/provider/shop_provider.dart';
import 'package:style_book/util.dart';

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
    final shopProvider = Provider.of<ShopProvider>(context, listen: true);
    final itemProvider = Provider.of<ItemProvider>(context, listen: true);
    final bookmarkItems = itemProvider.bookmarkItemList;

    final aspectRatio = MediaQuery.of(context).size.height /
        (MediaQuery.of(context).size.height + 210);

    print("aspectRatio $aspectRatio");
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: aspectRatio, crossAxisCount: 2),
        itemCount: bookmarkItems.length,
        shrinkWrap: true,
        padding:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0, bottom: 8.0),
        controller: ScrollController(),
        itemBuilder: (context, index) {
          final item = bookmarkItems[index];
          return InkWell(
            onTap: () {
              EventLog.sendEventLog("click_bookmark_item", eventProperties: {
                'item_id': item.id,
                'shop_name_id': item.shopNameId
              });
              shopProvider.requestShopInfo(item);
              // _launchUrl(url: item.postUrl ?? "", title: _shop.name);
            },
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AnimatedSwitcher(
                    child: item.getFirstImage(
                        width: 160, height: 160, fit: BoxFit.fitWidth),
                    duration: Duration(seconds: 1),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  child: Text(
                    shopProvider.findShopName(item),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff333d4b)),
                  ),
                  width: 160,
                ),
                SizedBox(
                  height: 4,
                ),
                SizedBox(
                  child: Text(
                    "♥ ${likeToStringFormant(item.likes)}",
                    style: TextStyle(fontSize: 12, color: Color(0xffb0b8c1)),
                  ),
                  width: 160,
                ),
              ],
            ),
          );
        });
  }
}
