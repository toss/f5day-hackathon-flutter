import 'package:flutter/material.dart';
import 'package:style_book/view/item_show_window_page.dart';
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

  @override
  void initState() {
    print("MainPageState initState");
    super.initState();
  }

  @override
  void deactivate() {
    print("MainPageState deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
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
          children: [ItemShowWindowPage(), ShopListPage(), ShopListPage()],
        ));
  }

  _onTapItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget? _onTapTitle(int index) {
    if (index == 0) {
      return Text("모아보기");
    }
    if (index == 1) {
      return Text("TOP 50  trang mua sắm");
    }
    return null;
  }
}
