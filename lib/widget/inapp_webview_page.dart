import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class InAppWebViewPage extends StatefulWidget {
  final String _url;
  final String? _title;

  InAppWebViewPage(this._url, this._title) : super();

  @override
  State<StatefulWidget> createState() =>
      InAppWebViewState(_url, _title ?? _url);
}

class InAppWebViewState extends State<InAppWebViewPage> {
  // final GlobalKey _globalKey = GlobalKey();

  String _url;
  String _title;

  InAppWebViewController? _webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  InAppWebViewState(this._url, this._title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black54),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(0),
        child: Expanded(
          child: InAppWebView(
            initialOptions: options,
            initialUrlRequest: URLRequest(url: Uri.parse(_url)),
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
          ),
        ),
      ),
    );
  }
}
