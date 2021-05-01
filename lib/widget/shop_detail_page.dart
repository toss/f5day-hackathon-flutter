import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:style_book/log/event_log.dart';
import 'package:style_book/model/item_model.dart';
import 'package:style_book/model/shop_model.dart';
import 'package:style_book/provider/item_provider.dart';
import 'package:style_book/widget/inapp_webview_page.dart';

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
    provider.getItemList(_shop.userName ?? "");
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
        WidgetUtils.shopPicture(_shop.image ?? ""),
        Container(
          margin: EdgeInsets.only(top: 24),
          child: Text(
            _shop.userName ?? "",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 6, bottom: 6),
          child: Text(
            _shop.name ?? "",
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
            return Container(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
              child: _listHeader(isLoading),
            );
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
                  _launchUrl(url: _shop.url ?? "", title: _shop.name);
                },
                child: Text("Go to Facebook"),
              ),
            );
          } else {
            return Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: _itemGridView(items),
            );
          }
        });
  }

  Widget? _listHeader(bool itemPreviewEmpty) {
    if (itemPreviewEmpty) {
      return null;
    }
    return Text(
      "Top 10",
      style: TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xffFF5e9b)),
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

    if (items.any((element) => element.postUrl == null)) {
      return InkWell(
        onTap: () {
          EventLog.sendEventLog("click_item_preview_empty",
              eventProperties: {'item': _shop.toJson(_shop)});
          _launchUrl(url: _shop.url ?? "", title: _shop.name);
        },
        //child: Image.network(_shop.imageBig ?? ""),
      );
    }
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 12),
        itemCount: items.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final item = items[index];
          return InkWell(
            onTap: () {
              EventLog.sendEventLog("click_item",
                  eventProperties: {'item': item.toJson(item)});
              _launchUrl(url: item.postUrl ?? "", title: _shop.name);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AnimatedSwitcher(
                child: _images(item),
                duration: Duration(seconds: 1),
              ),
            ),
          );
        });
  }

  Widget? _images(Item item) {
    final images = item.imageList();

    if (images.isEmpty) {
      return null;
    }
    return Image.network(images[0], fit: BoxFit.fitHeight);
  }

  _launchUrl({required String url, String? title}) async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => InAppWebViewPage(url, title)));
    //Navigator.pushReplacementNamed(context, routeName)
    /*final validate = await canLaunch(url);
    print("_launchUrl $url / $validate");
    if (validate) {
      await launch(url);
    } else {
      print("_launchUrl $url / $validate");
    }*/
  }
}
