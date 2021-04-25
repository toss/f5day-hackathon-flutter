import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:style_book/widget/shop_list_page.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Center(
            child: Image.asset(
      'images/app_logo.png',
      height: 90,
      width: 90,
    )));
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: ShopListPage(),
    );
  }
}
