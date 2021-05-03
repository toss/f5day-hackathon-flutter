import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:style_book/provider/shop_provider.dart';
import 'package:style_book/view/item_bookmark_page.dart';
import 'package:style_book/view/item_show_window_page.dart';
import 'package:style_book/view/shop_list_page.dart';
import 'package:style_book/view/widget_component.dart';

import 'item_detail_widget.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        home: MainPageHome());
  }
}

class MainPageHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainPageState();
}

class MainPageState extends State<MainPageHome> {
  int _selectedIndex = 0;
  late StreamSubscription _event;

  @override
  void initState() {
    print("MainPageState initState");
    super.initState();
    final shopProvider = Provider.of<ShopProvider>(context, listen: false);
    _event = shopProvider.shopInfoStream.asBroadcastStream().listen((event) {
      print("MarketRankState listen $event");
      if (event == null) {
        return;
      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (c) => ItemDetailWidget(event.shop, event.item)));
    });
  }

  @override
  void deactivate() {
    print("MainPageState deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    _event.cancel();
    print("MainPageState dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _onTapTitle(_selectedIndex),
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        bottomNavigationBar: MainBottomNavigationBar(_selectedIndex, (int) {
          _onTapItem(int);
        }),
        body: IndexedStack(
          index: _selectedIndex,
          children: [ItemShowWindowPage(), ShopListPage(), ItemBookmarkPage()],
        ));
  }

  _onTapItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget? _onTapTitle(int index) {
    switch (index) {
      case 0:
        return Text("Mua sắm");
      case 1:
        return Text("TOP 50  trang mua sắm");
      case 2:
        return Text("Đánh dấu");
    }
    return null;
  }
}
