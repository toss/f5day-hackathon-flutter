import 'dart:ui';

import 'package:advertising_id/advertising_id.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:style_book/api/item_api.dart';
import 'package:style_book/api/shop_api.dart';
import 'package:style_book/log/event_log.dart';
import 'package:style_book/main_provider.dart';
import 'package:style_book/provider/item_provider.dart';
import 'package:style_book/widget/shop_detail_page.dart';
import 'package:style_book/widget/widget_builder.dart';

import 'model/shop_model.dart';

Future<void> initOneSignal() async {
  print("kReleaseMode $kReleaseMode");
  if (!kReleaseMode) {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  }
  OneSignal.shared.setAppId("47e0b3c4-cd2b-4438-8d29-d3e921410f78");
  OneSignal.shared.disablePush(false);

  OneSignal.shared.clearOneSignalNotifications();
}

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => MainProvider(ProductApi())),
      ChangeNotifierProvider(create: (_) => ItemProvider(ItemApi()))
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Widget> items = [];
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    initOneSignal();

    final provider = Provider.of<MainProvider>(context, listen: false);
    provider.getProductList();

    final Amplitude analytics =
        Amplitude.getInstance(instanceName: "stylebook");
    // Initialize SDK
    analytics.init("20cb8330bbccaa8f0524200f15f98188");
    analytics.trackingSessionEvents(true);
    _advertisingId(analytics);
    analytics.logEvent('app_open');
  }

  _advertisingId(Amplitude amplitude) async {
    var id = await AdvertisingId.id(true);
    print("AdvertisingId $id");
    amplitude.setUserId(id);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Seller TOP 50"),
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: _listView(provider.items));
  }

  Widget _listView(List<Shop> list) {
    print("_listView $list");
    return ListView.builder(
        controller: _controller,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _listItemBuilder(list[index]);
        });
  }

  Widget _listItemBuilder(Shop shop) {
    return InkWell(
      onTap: () {
        EventLog.sendEventLog("click_shop",
            eventProperties: {'shop': shop.toJson(shop)});
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ShopDetailPage(shop)));
      },
      child: _showContainer(shop),
    );
  }

  Widget _showContainer(Shop shop) {
    final rankTextColor;
    if (shop.rank <= 3) {
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
              shop.rank.toString(),
              style: TextStyle(
                  color: rankTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Container(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              width: 120,
              child: WidgetUtils.shopPicture(shop.imageSmall ?? "")),
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
                  shop.tag ?? "",
                  style: TextStyle(color: Colors.grey.shade800, fontSize: 15),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12),
                child: Text(
                  "♥ ${shop.likes.toString()}",
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
