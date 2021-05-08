import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:style_book/log/event_log.dart';
import 'package:style_book/model/item_model.dart';
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
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    print("ItemShowWindowState initState");

    Provider.of<ItemProvider>(context, listen: false).fetchShowWindowList();
  }

  @override
  void dispose() {
    print("MarketRankState dispose");
//    _event.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
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
        if (itemProvider.showWindowList.length < 3) {
          axisCount = 2;
        }

        final itemCount = itemProvider.showWindowList.length;

        var imageSize = 108.0;
        var bookmarkDimHeight = 26.0;
        var bookmarkSize = 16.0;
        var bookmarkRightPadding = 6.0;
        if (itemCount < 3) {
          imageSize = 160.0;
          bookmarkDimHeight = 38.0;
          bookmarkSize = 24.0;
          bookmarkRightPadding = 10.0;
        }

        return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: axisCount, childAspectRatio: aspectRatio),
            itemCount: itemProvider.showWindowList.length,
            shrinkWrap: true,
            padding:
                EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0, bottom: 8.0),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = itemProvider.showWindowList[index];
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
                        child: Stack(
                          children: [
                            AnimatedSwitcher(
                              child: ShowWindowImageWidget(item, imageSize),
                              duration: Duration(seconds: 1),
                            ),
                            thumbnailBookmarkWidget(
                                itemProvider.isBookmark(item),
                                backgroundWidth: imageSize,
                                backgroundHeight: bookmarkDimHeight,
                                bookmarkRightPadding: bookmarkRightPadding,
                                bookmarkSize: bookmarkSize)
                          ],
                        )),
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

class ShowWindowImageWidget extends StatefulWidget {
  final Item _item;

  final double _imageSize;

  ShowWindowImageWidget(this._item, this._imageSize);

  @override
  State<StatefulWidget> createState() =>
      ShowWindowImageState(_item, _imageSize);
}

class ShowWindowImageState extends State<ShowWindowImageWidget> {
  final Item _item;

  late Timer _timer;

  int _index = 0;

  double _imageSize;

  ShowWindowImageState(this._item, this._imageSize);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer.periodic(new Duration(seconds: 3), (callback) {
      setState(() {
        _index = (_index + 1) % _item.imageList().length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _item.getImageWidget(_index,
            width: _imageSize, height: _imageSize, fit: BoxFit.fitWidth) ??
        SizedBox();
  }
}
