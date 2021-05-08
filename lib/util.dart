import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'view/inapp_webview_page.dart';

launchUrl(BuildContext context, {required String url, String? title}) async {
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => InAppWebViewPage(url, title)));
}

String likeToStringFormant(int likes) {
  return NumberFormat.decimalPattern("vi").format(likes).toString();
}

Color bookmarkColor(bool isBookmark) {
  if (isBookmark) {
    return Color(0xffff5e9b);
  } else {
    return Color(0xffb0b8c1);
  }
}

Color thumbnailBookmarkColor(bool isBookmark) {
  if (isBookmark) {
    return Color(0xffff5e9b);
  } else {
    return Color(0x99ffffff);
  }
}

Widget thumbnailBookmarkWidget(
  bool isBookmarkItem, {
  double backgroundWidth = 108.0,
  double backgroundHeight = 26.0,
  double bookmarkSize = 16.0,
  double bookmarkRightPadding = 6.0,
}) {
  return Positioned.fill(
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: backgroundWidth,
            height: backgroundHeight,
            padding: EdgeInsets.only(right: bookmarkRightPadding),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0x40000000), Color(0x00000000)],
                    tileMode: TileMode.clamp)),
            child: Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                child: Image.asset("images/icon_star_mono.png",
                    width: bookmarkSize,
                    height: bookmarkSize,
                    color: thumbnailBookmarkColor(isBookmarkItem)),
              ),
            ),
          )));
}
