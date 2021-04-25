import 'package:advertising_id/advertising_id.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:style_book/api/item_api.dart';
import 'package:style_book/api/shop_api.dart';
import 'package:style_book/provider/item_provider.dart';
import 'package:style_book/provider/shop_provider.dart';
import 'package:style_book/widget/stateless_widgets.dart';

const oneSignalAppId = "47e0b3c4-cd2b-4438-8d29-d3e921410f78";
const amplitudeApiKey = "20cb8330bbccaa8f0524200f15f98188";

Future<void> initOneSignal() async {
  if (!kReleaseMode) {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  }
  OneSignal.shared.setAppId(oneSignalAppId);
  OneSignal.shared.disablePush(false);

  OneSignal.shared.clearOneSignalNotifications();
}

Future<void> initAmplitude() async {
  final Amplitude analytics = Amplitude.getInstance(instanceName: "stylebook");
  // Initialize SDK
  analytics.init(amplitudeApiKey);
  analytics.trackingSessionEvents(true);
  var id = await AdvertisingId.id(true);
  print("AdvertisingId $id");
  analytics.setUserId(id);
}

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ShopProvider(ShopApi())),
      ChangeNotifierProvider(create: (_) => ItemProvider(ItemApi()))
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([initOneSignal(), initAmplitude()]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MainPage();
          }
          return SplashPage();
        });
  }
}
