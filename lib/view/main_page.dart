import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:provider/provider.dart';
import 'package:style_book/log/event_log.dart';
import 'package:style_book/provider/shop_provider.dart';
import 'package:style_book/view/item_bookmark_page.dart';
import 'package:style_book/view/item_show_window_page.dart';
import 'package:style_book/view/shop_list_page.dart';
import 'package:style_book/view/widget_component.dart';

import 'item_detail_page.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    EventLog.sendEventLog('app_open');
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

class MainPageState extends State<MainPageHome> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  late StreamSubscription _event;

  @override
  void initState() {
    print("MainPageState initState");
    super.initState();

    WidgetsBinding.instance?.addObserver(this);

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

  Future<PermissionStatus> _permissionState() async {
    return await NotificationPermissions.getNotificationPermissionStatus();
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
    print("MainPageState build");

    _permissionState().then((value) {
      if (value != PermissionStatus.granted) {
        NotificationPermissions.requestNotificationPermissions(
            iosSettings:
                NotificationSettingsIos(sound: true, badge: true, alert: true));
      }
    });

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
    String title;
    switch (index) {
      case 0:
        title = "Mua sắm";
        break;
      case 1:
        title = "TOP 50  trang mua sắm";
        break;
      case 2:
        title = "Đánh dấu";
        break;
      default:
        return null;
    }
    EventLog.sendEventLog("dashboard", eventProperties: {"label": title});

    return Text(title);
  }
}
