import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
  print("initOneSignal");
  if (!kReleaseMode) {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  }
  OneSignal.shared.setAppId(oneSignalAppId);
  OneSignal.shared.disablePush(false);

  OneSignal.shared.clearOneSignalNotifications();
}

Future<void> initAmplitude() async {
  print("initAmplitude");
  final Amplitude analytics = Amplitude.getInstance(instanceName: "stylebook");
  // Initialize SDK
  analytics.init(amplitudeApiKey);
  analytics.trackingSessionEvents(true);
  final id = await initAdvertisingId();
  print("amplitude user unique id $id");
  analytics.setUserId(id);
}

Future<String?> initAdvertisingId() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    final userCredential = await FirebaseAuth.instance.signInAnonymously();
    return userCredential.user?.uid;
  } else {
    return user.uid;
  }
  /*return FirebaseAuth.instance.authStateChanges().map((user) {

    user?.uid;
    //return ProfileInputWidget();
  });*/
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await FirebaseAuth.instance.useEmulator('http://localhost:9099');
  // runApp(AuthExampleApp());
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ShopProvider(ShopApi())),
      ChangeNotifierProvider(
          create: (_) => ItemProvider(ItemApi(), BookmarkApi()))
    ],
    child: MyApp(),
  ));
}

/*
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
*/

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    /*if (Platform.isIOS) {
      return IosSplashPage();
    } else {
      return FutureBuilder(
          future:
              Future.wait([initOneSignal(), initAmplitude(), initAppsflyer()]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return MainPage();
            }
            return SplashPage();
          });
    }*/
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
