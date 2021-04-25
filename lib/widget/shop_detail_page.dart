import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:style_book/log/event_log.dart';
import 'package:style_book/model/item_model.dart';
import 'package:style_book/model/shop_model.dart';
import 'package:style_book/provider/item_provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
    provider.getItemList(_shop.name ?? "");
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
              height: 52,
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
        WidgetUtils.shopPicture(_shop.imageSmall ?? ""),
        Container(
          margin: EdgeInsets.only(top: 24),
          child: Text(
            _shop.tag ?? "",
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
          'Likes ${_shop.likes.toString()}',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        )
      ],
    ));
  }

  Widget _itemList(List<Item> items) {
    return ListView.builder(
        itemCount: 3,
        controller: _controller,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
              child: Text(
                "Top 10",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffFF5e9b)),
              ),
            );
          } else if (index == 2) {
            return Container(
              padding: EdgeInsets.only(top: 80, bottom: 16),
              child: TextButton(
                onPressed: () {
                  EventLog.sendEventLog("click_facebook",
                      eventProperties: {'item': _shop.toJson(_shop)});
                  _launchUrl(_shop.url ?? "");
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

  Widget _itemGridView(List<Item> items) {
    print("Shop detail items $items");
    if (items.length == 0) {
      return Text("Loading...");
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
              _launchUrl(item.url ?? "");
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(item.image2 ?? "", fit: BoxFit.fitWidth),
            ),
          );
        });
  }

  _launchUrl(String url) async {
/*

    if (Platform.isIOS) {
      fbProtocolUrl = 'fb://profile/page_id';
    } else {
      fbProtocolUrl = 'fb://page/page_id';
    }
*/

    var validate = await canLaunch(url);
    print("_launchUrl $url / $validate");
    if (validate) {
      await launch(url);
    } else {
      print("_launchUrl $url / $validate");
    }
  }
}
