import 'package:flutter/material.dart';
import 'package:style_book/view/market_rank_widget.dart';
import 'package:style_book/view/shop_list_page.dart';
import 'package:style_book/view/widget_component.dart';

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

  List<Widget> _childWidgets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Seller TOP 50"),
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        bottomNavigationBar: MainBottomNavigationBar(_selectedIndex, (int) {
          _onTapItem(int);
        }),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            ShopListPage(),
            MarketRankStatelessWidget(),
            ShopListPage()
          ],
        ));
  }

  _onTapItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
