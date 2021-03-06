import 'dart:convert';
import 'dart:io';

import 'package:advertising_id/advertising_id.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:style_book/api/bookmark_api.dart';
import 'package:style_book/api/item_api.dart';
import 'package:style_book/api/shop_api.dart';
import 'package:style_book/provider/item_provider.dart';
import 'package:style_book/provider/shop_provider.dart';
import 'package:style_book/view/main_page.dart';
import 'package:style_book/view/stateless_widgets.dart';

import 'log/event_log.dart';

const oneSignalAppId = "47e0b3c4-cd2b-4438-8d29-d3e921410f78";
const amplitudeApiKey = "20cb8330bbccaa8f0524200f15f98188";
const appsflyerDevKey = "ut9qtkwRKRdp9Fb8Ajrbik";

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

Future<void> initAppsflyer() async {
  final appsFlyerOptions =
      AppsFlyerOptions(afDevKey: appsflyerDevKey, showDebug: !kReleaseMode);

  AppsflyerSdk appsflyerSdk = AppsflyerSdk(appsFlyerOptions);

  appsflyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true);

  appsflyerSdk.onInstallConversionData((res) {
    Map response = jsonDecode(res);
    print("onInstallConversionData ${res.toString()}");
    final afStatus = response["af_status"];
    final afSub1 = response["af_sub1"];
    print("onInstallConversionData af_status $afStatus");
    print("onInstallConversionData af_sub1 $afSub1");

    EventLog.setProperties({"af_status": res.toString(), "af_sub1": afSub1});
  });
}

Future<void> initWebView() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Permission.camera.request();
  // await Permission.microphone.request();
  // await Permission.storage.request();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

    var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

    if (swAvailable && swInterceptAvailable) {
      AndroidServiceWorkerController serviceWorkerController =
          AndroidServiceWorkerController.instance();

      serviceWorkerController.serviceWorkerClient = AndroidServiceWorkerClient(
        shouldInterceptRequest: (request) async {
          print(request);
          return null;
        },
      );
    }
  }
}

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ShopProvider(ShopApi())),
      ChangeNotifierProvider(
          create: (_) => ItemProvider(ItemApi(), BookmarkApi()))
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            Future.wait([initOneSignal(), initAmplitude(), initAppsflyer()]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MainPage();
          }
          return SplashPage();
        });
  }
}
