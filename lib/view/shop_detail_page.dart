import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:style_book/log/event_log.dart';
import 'package:style_book/model/item_model.dart';
import 'package:style_book/model/shop_model.dart';
import 'package:style_book/provider/item_provider.dart';
import 'package:style_book/util.dart';
import 'package:style_book/view/item_detail_page.dart';

import 'widget_builder.dart';

class ShopDetailPage extends StatefulWidget {
  final Shop _shop;

  ShopDetailPage(this._shop) : super();

  @override
  State<StatefulWidget> createState() => ShopState(_shop);
}

class ShopState extends State<ShopDetailPage> {
  final Shop _shop;

  final _controller = ScrollController();

  ShopState(this._shop);

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ItemProvider>(context, listen: false);
    provider.getItemList(_shop.nameId ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ItemProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black54),
        elevation: 0,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _shopHeaderContainer(),
            SizedBox(
              height: 8,
            ),
            Expanded(
              child: _itemList(provider.items),
            )
          ],
        ),
      ),
    );
  }

  Widget _shopHeaderContainer() {
    return Container(
        child: Column(
      children: [
        WidgetUtils.shopPicture(_shop.imageProfile ?? ""),
        Container(
          margin: EdgeInsets.only(top: 24),
          child: Text(
            _shop.nameDisplay ?? "",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 6, bottom: 6),
          child: Text(
            _shop.nameId ?? "",
            style: TextStyle(fontSize: 24, color: Colors.grey.shade800),
          ),
        ),
        Text(
          'Likes ${_shop.likesToString()}',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        )
      ],
    ));
  }

  Widget _itemList(List<Item> items) {
    bool isLoading =
        items.isEmpty || items.any((element) => element.images.isEmpty);

    return ListView.builder(
        itemCount: 3,
        controller: _controller,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _listHeader(isLoading) ?? SizedBox();
          } else if (index == 2) {
            if (isLoading) {
              return SizedBox(height: 16);
            }
            return Container(
              padding:
                  EdgeInsets.only(left: 36, right: 36, top: 72, bottom: 16),
              child: TextButton(
                onPressed: () {
                  EventLog.sendEventLog("click_facebook",
                      eventProperties: {'item': _shop.toJson(_shop)});
                  launchUrl(context,
                      url: _shop.url ?? "", title: _shop.nameDisplay);
                },
                child: Text("Go to Facebook"),
              ),
            );
          } else {
            return _itemGridView(items);
          }
        });
  }

  Widget? _listHeader(bool itemPreviewEmpty) {
    if (itemPreviewEmpty) {
      return null;
    }
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 66.0),
      child: Text(
        "Sản phẩm nổi bật tuần này",
        style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xff333d4b)),
      ),
    );
  }

  Widget _itemGridView(List<Item> items) {
    print("Shop detail items $items");
    if (items.length == 0) {
      return Container(
        height: 96,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (items.any((element) => element.url == null)) {
      return InkWell(
        onTap: () {
          EventLog.sendEventLog("click_item_preview_empty",
              eventProperties: {'shop_name_id': _shop.nameId});
          launchUrl(context, url: _shop.url ?? "", title: _shop.nameDisplay);
        },
        //child: Image.network(_shop.imageBig ?? ""),
      );
    }
    final aspectRatio = MediaQuery.of(context).size.height /
        (MediaQuery.of(context).size.height + 210);

    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: aspectRatio,
        ),
        itemCount: items.length,
        padding:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 24.0, bottom: 8.0),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final item = items[index];
          return ItemImageWidget(_shop, item);
        });
  }
}

class ItemImageWidget extends StatefulWidget {
  final Item _item;
  final Shop _shop;

  ItemImageWidget(this._shop, this._item);

  @override
  State<StatefulWidget> createState() => ItemImageState(_shop, _item);
}

class ItemImageState extends State<ItemImageWidget> {
  Item _item;
  Shop _shop;

  late Timer _timer;

  int _index = 0;

  ItemImageState(this._shop, this._item);

  @override
  void initState() {
    _timer = Timer.periodic(new Duration(seconds: 3), (callback) {
      setState(() {
        _index = (_index + 1) % _item.imageList().length;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        EventLog.sendEventLog("click_item_detail_item", eventProperties: {
          'item_id': _item.id,
          'shop_name_id': _shop.nameId
        });
        Navigator.push(context,
            MaterialPageRoute(builder: (c) => ItemDetailWidget(_shop, _item)));
        //_launchUrl(url: item.postUrl ?? "", title: _shop.name);
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AnimatedSwitcher(
              child: _item.getImageWidget(_index,
                  width: 160, height: 160, fit: BoxFit.fitWidth),
              duration: Duration(seconds: 1),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            child: Text(
              _shop.nameDisplay ?? "",
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
              "♥ ${likeToStringFormant(_item.likes)}",
              style: TextStyle(fontSize: 12, color: Color(0xffb0b8c1)),
            ),
            width: 160,
          ),
        ],
      ),
    );
  }
}
