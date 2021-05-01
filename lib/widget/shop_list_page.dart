import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:style_book/log/event_log.dart';
import 'package:style_book/model/shop_model.dart';
import 'package:style_book/provider/shop_provider.dart';
import 'package:style_book/widget/shop_detail_page.dart';
import 'package:style_book/widget/widget_builder.dart';

class ShopListPage extends StatefulWidget {
  ShopListPage({Key? key}) : super(key: key);

  @override
  _ShopListPageState createState() => _ShopListPageState();
}

class _ShopListPageState extends State<ShopListPage> {
  final List<Widget> items = [];
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    final provider = Provider.of<ShopProvider>(context, listen: false);
    provider.getProductList();

    EventLog.sendEventLog('app_open');
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShopProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Seller TOP 50"),
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: _listView(provider.shopList));
  }

  Widget _listView(List<Shop> list) {
    print("_listView $list");
    list.sort((a, b) => b.likes.compareTo(a.likes));
    if (list.isEmpty) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return ListView.builder(
        controller: _controller,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _listItemBuilder(index, list[index]);
        });
  }

  Widget _listItemBuilder(int index, Shop shop) {
    return InkWell(
      onTap: () {
        EventLog.sendEventLog("click_shop",
            eventProperties: {'shop': shop.toJson(shop)});
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ShopDetailPage(shop)));
      },
      child: _showContainer(index + 1, shop),
    );
  }

  Widget _showContainer(int rank, Shop shop) {
    final rankTextColor;
    if (rank <= 3) {
      rankTextColor = Color(0xffff5e9b);
    } else {
      rankTextColor = Color(0xff333d4b);
    }
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Text(
              rank.toString(),
              style: TextStyle(
                  color: rankTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Container(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              width: 120,
              child: WidgetUtils.shopPicture(shop.image ?? "")),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 2),
                child: Text(shop.name ?? "",
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )),
              ),
              Container(
                margin: EdgeInsets.only(top: 4),
                child: Text(
                  shop.name ?? "",
                  style: TextStyle(color: Colors.grey.shade800, fontSize: 15),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12),
                child: Text(
                  "♥ ${shop.likesToString()}",
                  style: TextStyle(color: Color(0xffff5e9b)),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
