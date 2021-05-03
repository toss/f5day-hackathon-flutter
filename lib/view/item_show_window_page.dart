
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:style_book/log/event_log.dart';
import 'package:style_book/provider/item_provider.dart';

import '../provider/shop_provider.dart';

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
  State<StatefulWidget> createState() => MarketRankState();
}

class MarketRankState extends State<ItemShowWindowWidget> {
  final _controller = ScrollController();

  // late StreamSubscription _event;

  @override
  void initState() {
    super.initState();
    print("MarketRankState initState");

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
            padding: EdgeInsets.all(24.0),
            child: Text("Xem xếp hạng"),
          );
        }

        return GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 12),
            itemCount: provider.showWindowList.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = provider.showWindowList[index];
              return InkWell(
                onTap: () {
                  EventLog.sendEventLog("click_market_rank",
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
