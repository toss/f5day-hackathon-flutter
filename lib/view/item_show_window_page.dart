import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:style_book/log/event_log.dart';
import 'package:style_book/provider/item_provider.dart';

import '../provider/shop_provider.dart';
import '../util.dart';

class ItemShowWindowPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ItemShowWindowWidget(),
    );
  }
}

class ItemShowWindowWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ItemShowWindowState();
}

class ItemShowWindowState extends State<ItemShowWindowWidget> {
  final _controller = ScrollController();

  // late StreamSubscription _event;

  @override
  void initState() {
    super.initState();
    print("ItemShowWindowState initState");

    Provider.of<ItemProvider>(context, listen: false).fetchShowWindowList();
    final shopProvider = Provider.of<ShopProvider>(context, listen: false);
    /* _event = shopProvider.shopInfoStream.asBroadcastStream().listen((event) {
      print("MarketRankState listen $event");
      if (event == null) {
        return;
      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (c) => ItemDetailWidget(event.shop, event.item)));
    });*/
  }

  @override
  void dispose() {
    print("MarketRankState dispose");
//    _event.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ItemProvider>(context);
    final shopProvider = Provider.of<ShopProvider>(context);

    return ListView.builder(
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
            padding: EdgeInsets.only(left: 24.0, top: 36, bottom: 16.0),
            child: Text("Xem xếp hạng"),
          );
        }

        final aspectRatio = MediaQuery.of(context).size.height /
            (MediaQuery.of(context).size.height + 300);

        var axisCount = 3;
        if (provider.showWindowList.length < 3) {
          axisCount = 2;
        }

        var imageSize = 108.0;
        if (provider.showWindowList.length < 3) {
          imageSize = 160.0;
        }

        return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: axisCount, childAspectRatio: aspectRatio),
            itemCount: provider.showWindowList.length,
            shrinkWrap: true,
            padding:
                EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0, bottom: 8.0),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = provider.showWindowList[index];
              return InkWell(
                  onTap: () {
                    EventLog.sendEventLog("click_show_window_item",
                        eventProperties: {
                          'item_id': item.id,
                          'shop_name_id': item.shopNameId
                        });
                    shopProvider.requestShopInfo(item);
                    // _launchUrl(url: item.postUrl ?? "", title: _shop.name);
                  },
                  child: Column(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AnimatedSwitcher(
                        child: item.getFirstImage(
                            width: imageSize,
                            height: imageSize,
                            fit: BoxFit.fitWidth),
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
                        style:
                            TextStyle(fontSize: 12, color: Color(0xffb0b8c1)),
                      ),
                      width: 160,
                    )
                  ]));
            });
      },
      controller: _controller,
      itemCount: 2,
    );
  }

/*  Widget? _getImage(Item item) {
    final list = item.imageList();
    print("market image list $list");
    if (list.isEmpty) {
      return null;
    }

    return Image.network(list[0], fit: BoxFit.fitHeight);
  }*/
}
