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
