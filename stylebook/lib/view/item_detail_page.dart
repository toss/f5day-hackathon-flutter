import 'package:advertising_id/advertising_id.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:style_book/log/event_log.dart';
import 'package:style_book/provider/item_provider.dart';
import 'package:style_book/util.dart';

import '../model/item_model.dart';
import '../model/shop_model.dart';

class ItemDetailWidget extends StatefulWidget {
  final Item _item;
  final Shop _shop;

  ItemDetailWidget(this._shop, this._item);

  @override
  State<StatefulWidget> createState() => ItemDetailState(_shop, _item);
}

class ItemDetailState extends State<ItemDetailWidget> {
  final Item _item;
  final Shop _shop;

  bool _bookmark = false;

  ItemDetailState(this._shop, this._item);

  @override
  void initState() {
    super.initState();
    _bookmark =
        Provider.of<ItemProvider>(context, listen: false).isBookmark(_item);
    EventLog.sendEventLog("view_item_detail_page", eventProperties: {
      "item_id": _item.id,
      "shop_name_id": _item.shopNameId
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigation(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
              iconTheme: IconThemeData(color: Colors.white),
              expandedHeight: 375.0,
              flexibleSpace: Stack(
                children: [
                  Positioned.fill(
                      child: _item.getImageWidget(0, fit: BoxFit.fitWidth) ??
                          Placeholder()),
                  Positioned.fill(
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: double.infinity,
                            height: 80,
                            padding: EdgeInsets.only(right: 10, bottom: 10),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Color(0x40000000),
                                      Color(0x00000000)
                                    ],
                                    tileMode: TileMode.clamp)),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                "♥ ${likeToStringFormant(_item.likes)}",
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xffffffff)),
                              ),
                            ),
                          )))
                ],
              )),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            if (index == 0) {
              return Container(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.network(
                          _shop.imageProfile ?? "",
                          width: 54.0,
                          height: 54.0,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_shop.nameId ?? ""),
                            Text(_item.time)
                          ],
                        )
                      ],
                    ),
                    Text(_item.text ?? "")
                  ],
                ),
              );
            } else {
              return Container(
                padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
                child: _item.getImageWidget(index),
              );
            }
          }, childCount: _item.imageList().length + 1))
        ],
      ),
    );
  }

  Widget _bottomNavigation() {
    final provider = Provider.of<ItemProvider>(context);

    return Container(
      height: 84.0,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 10),
      ], color: Colors.white),
      child: Container(
        child: Row(
          children: [
            _imageTextButton('images/icon_star_mono.png', "Đánh dấu",
                color: bookmarkColor(_bookmark), callback: () {
              setState(() {
                _bookmark = !_bookmark;
                EventLog.sendEventLog("click_bookmark",
                    eventProperties: {"is_bookmark": _bookmark});
                AdvertisingId.id(true).then((value) {
                  if (value != null) {
                    print("item bookmark userId : $value");
                    provider.updateBookmark(value, _item.id, _bookmark);
                  }
                });
              });
            }),
            SizedBox(
              width: 24,
            ),
            //todo 나중에 추가
            /* _imageTextButton(
                'images/icon_chat_bubble_one_to_one_mono.png', "Câu hỏi",
                color: Color(0xffb0b8c1), callback: () {}),*/
            Flexible(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      EventLog.sendEventLog("item_detail_go_facebook",
                          eventProperties: {"url": _item.url});
                      launchUrl(context,
                          url: _item.url ?? "", title: _shop.nameDisplay);
                    },
                    style: ElevatedButton.styleFrom(primary: Color(0xffff5e9b)),
                    child: Text("Đến trang bán")),
              ),
              flex: 2,
            )
          ],
        ),
      ),
    );
  }

  Widget _imageTextButton(String path, String text,
      {Color? color, VoidCallback? callback}) {
    return TextButton.icon(
        onPressed: callback,
        icon: Image.asset(
          path,
          width: 24,
          height: 24,
          color: color,
        ),
        label: Text(
          text,
          style: TextStyle(color: Color(0xffb0b8c1)),
        ));
  }
}
